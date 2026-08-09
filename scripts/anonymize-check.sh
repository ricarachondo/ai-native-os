#!/usr/bin/env bash
# anonymize-check.sh — run BEFORE every push to this public kit.
# The Contributing rule (no private project names, personal names, paths,
# account ids, deployment URLs) is discipline until something checks it —
# and it has been broken more than once by well-meaning sessions.
#
# Deny-list lives OUTSIDE the repo (it would itself be a leak):
#   ~/.config/ai-native-os/private-names.txt   — one term per line, # comments ok
# Without that file the script still catches the generic shapes.
#
# Usage: scripts/anonymize-check.sh [--staged]   (default: whole worktree)
set -uo pipefail

PRIVATE_LIST="${HOME}/.config/ai-native-os/private-names.txt"
FAIL=0

files() {
  if [ "${1:-}" = "--staged" ]; then git diff --cached --name-only --diff-filter=ACM
  else git ls-files; fi
}

scan() { # $1=pattern $2=label
  local hits
  hits=$(files "${MODE:-}" | xargs grep -niE "$1" 2>/dev/null \
    | grep -v '^scripts/anonymize-check.sh' \
    | grep -viE 'example\.(com|org)|user@|name@|you@|@domain|@yourapp' \
    | head -20)
  if [ -n "$hits" ]; then
    echo "❌ $2:"; echo "$hits" | sed 's/^/   /'; FAIL=1
  fi
}

MODE="${1:-}"

# Generic shapes that are always leaks
scan '/Users/[a-z]|/home/[a-z]' "Personal filesystem paths"
scan '[a-z0-9._%+-]+@[a-z0-9-]+\.(com|net|org|io|dev|cl|es|co)\b' "Email addresses"
scan 'https://[a-z0-9-]+\.(vercel\.app|supabase\.co|netlify\.app)' "Deployment/instance URLs"
scan '(sk-|sk_live_|ghp_|xox[baprs]-)[A-Za-z0-9_-]{16,}' "Credential-shaped strings"

# Project/person names from the private list, if present
if [ -f "$PRIVATE_LIST" ]; then
  terms=$(grep -vE '^\s*(#|$)' "$PRIVATE_LIST" | paste -sd'|' -)
  [ -n "$terms" ] && scan "\\b($terms)\\b" "Private project/person names (from your local deny-list)"
else
  echo "ℹ️  No deny-list at $PRIVATE_LIST — generic checks only."
  echo "   Create it (one private name per line) so project names are caught mechanically."
fi

if [ "$FAIL" -eq 0 ]; then echo "✅ Anonymization check passed."; else
  echo ""
  echo "Fix before pushing: identity out, lesson and numbers in. A source"
  echo "project is 'a source project'; keep the incident, drop the name."
fi
exit "$FAIL"
