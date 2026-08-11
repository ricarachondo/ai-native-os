#!/usr/bin/env bash
# role-defaults-check.sh — is the model+effort table actually APPLIED?
# The table in PROCESS § "Model and effort per role" is a rule; this is the
# mechanism. Without it, "we have a policy" and "every role runs on the
# strongest model by inertia" look identical from the outside.
#
# Usage: role-defaults-check.sh [project-dir]   (default: current dir)
set -uo pipefail
DIR="${1:-.}"
AGENTS="$DIR/.claude/agents"
FAIL=0

[ -d "$AGENTS" ] || { echo "ℹ️  $DIR has no .claude/agents — not a kit project."; exit 0; }

printf '%-22s %-10s %-10s %s\n' "ROLE" "MODEL" "EFFORT" "STATE"
for f in "$AGENTS"/*.md; do
  [ -f "$f" ] || continue
  role=$(basename "$f" .md)
  [ "$role" = "README" ] && continue  # the birth contract, not a role
  model=$(grep -m1 '^model:' "$f" | sed 's/^model:[[:space:]]*//')
  effort=$(grep -m1 -oE 'effort[-_ ]?default:[[:space:]]*[a-z]+' "$f" | grep -oE '[a-z]+$')
  state="ok"
  if [ -z "$model" ]; then state="❌ no model — inherits the session's, i.e. undeclared"; FAIL=1
  elif echo "$model" | grep -q '{{'; then state="❌ placeholder not substituted"; FAIL=1; fi
  if [ -z "$effort" ]; then state="${state%ok}❌ no effort declared"; FAIL=1; fi
  printf '%-22s %-10s %-10s %s\n' "$role" "${model:-—}" "${effort:-—}" "$state"
done

echo ""
if [ "$FAIL" -eq 0 ]; then
  echo "✅ Every role declares model and effort."
  echo "   (Whether the VALUES are right is the review question — the dispatch"
  echo "    log answers that after ~20 rows. This check only proves the policy runs.)"
else
  echo "❌ The model+effort table is NOT applied in this project."
  echo "   Undeclared roles do not fall back to the table — they inherit the"
  echo "   session model, which is how 'maximum everything by inertia' happens."
  echo "   Fix: set model + effort-default per role from PROCESS § Model and effort."
fi
exit "$FAIL"
