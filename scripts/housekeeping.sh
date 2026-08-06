#!/usr/bin/env bash
# housekeeping.sh — machine-wide disk/artifact diagnostic (GUARDRAILS § 2b).
# REPORT-ONLY by design: it never deletes anything. It measures, classifies,
# and prints suggested commands — deletion judgment (especially the
# reproducibility-before-deletion gate for real data) belongs to the
# operator/agent, not to a script.
#
# Usage: housekeeping.sh [DEV_ROOT]   (default: ~/dev)
set -uo pipefail

DEV_ROOT="${1:-$HOME/dev}"
THRESHOLD_GB=15

section() { printf '\n== %s ==\n' "$1"; }

section "Disk"
df -h / | awk 'NR==2 {print "Free: "$4"  (used "$5")"}'
FREE_GB=$(df -g / | awk 'NR==2 {print $4}')
if [ "${FREE_GB:-0}" -lt "$THRESHOLD_GB" ]; then
  echo "⚠️  Below ${THRESHOLD_GB}GB — housekeeping recommended before new work."
fi

section "Dead container-runtime leftovers (irrecoverable class — verify before deleting)"
for d in "$HOME/.colima" "$HOME/.lima" "$HOME/Library/Containers/com.docker.docker"; do
  if [ -d "$d" ]; then
    du -sh "$d" 2>/dev/null | sed 's/$/   ← runtime data dir present/'
  fi
done
echo "(A dir here from an UNINSTALLED runtime = orphaned VM disk. Gate: verify"
echo " per-project seed reproducibility BEFORE deleting — see GUARDRAILS § 2b.)"

section "Container runtime usage"
if docker info >/dev/null 2>&1; then
  docker system df
  echo "Suggested (safe): docker image prune -f   # dangling only — never -a by default"
else
  echo "Docker daemon not running (fine under the on-demand policy)."
fi

section "Git worktrees (uncommitted work = irrecoverable class)"
for repo in "$DEV_ROOT"/*/ "$DEV_ROOT"/*/*/; do
  [ -d "$repo/.git" ] || continue
  wt=$(git -C "$repo" worktree list 2>/dev/null | tail -n +2)
  [ -n "$wt" ] && { echo "-- $repo"; echo "$wt"; }
done
echo "External worktree-looking dirs:"
find "$DEV_ROOT" -maxdepth 2 -type d -name "*-wt-*" 2>/dev/null | sed 's/^/  /'
echo "(Before removing any: git status clean AND branch content already in main.)"

section "Disposable build artifacts (safe class — regenerable)"
find "$DEV_ROOT" -maxdepth 3 -type d \( -name ".next" -o -name "dist" -o -name ".turbo" \) \
  -not -path "*/node_modules/*" -exec du -sh {} \; 2>/dev/null | sort -rh | head -10

section "node_modules by project + staleness (paused candidates for hibernation)"
find "$DEV_ROOT" -maxdepth 3 -type d -name "node_modules" -not -path "*/node_modules/*" 2>/dev/null |
while read -r nm; do
  proj=$(dirname "$nm")
  size=$(du -sh "$nm" 2>/dev/null | cut -f1)
  # last commit age as the "activity" signal (mtime lies; git doesn't)
  if [ -d "$proj/.git" ]; then
    last=$(git -C "$proj" log -1 --format=%cr 2>/dev/null || echo "?")
  else
    last="no-git"
  fi
  printf '%-8s %s  (last commit: %s)\n' "$size" "$proj" "$last"
done | sort -rh | head -12
echo "(Projects with old last-commit → hibernation candidates: rm node_modules/.next,"
echo " stop stack with --no-backup AFTER the reproducibility check.)"

section "Caches (safe class)"
for c in "$HOME/Library/Caches/ms-playwright" "$HOME/Library/pnpm" \
         "$HOME/Library/Caches/Homebrew" "$HOME/.npm"; do
  [ -d "$c" ] && du -sh "$c" 2>/dev/null
done
echo "Suggested: pnpm store prune · brew cleanup -s · keep only current playwright browsers"

section "Summary"
echo "Classify every candidate per GUARDRAILS § 2b before acting:"
echo "  IRRECOVERABLE if wrong: container volumes with real data, uncommitted worktree files"
echo "  MERELY COSTLY:          builds, node_modules, caches, images (re-pull/re-install)"
echo "This script deletes nothing. It reports; you (or the agent + user ok) decide."
