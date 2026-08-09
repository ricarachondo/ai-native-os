#!/usr/bin/env bash
# session-cost.sh — where did this session's context actually go?
# Aggregates a Claude Code transcript by CATEGORY (never prints content).
# Measure before optimizing: the intuitive answer ("my messages are long")
# is usually wrong — in the source measurement, chat prose was 7% while
# tool traffic was 73%.
#
# Usage: session-cost.sh <path-to-transcript.jsonl>
#        session-cost.sh --latest   (most recent transcript in this project)
set -uo pipefail

T="${1:-}"
if [ "$T" = "--latest" ] || [ -z "$T" ]; then
  T=$(ls -t "$HOME"/.claude/projects/*/*.jsonl 2>/dev/null | head -1)
fi
[ -f "$T" ] || { echo "Usage: session-cost.sh <transcript.jsonl> | --latest"; exit 1; }

python3 - "$T" <<'PY'
import json,sys,collections
cat=collections.Counter(); cnt=collections.Counter()
def add(k,t): cat[k]+=len(t)//4; cnt[k]+=1
for line in open(sys.argv[1]):
    try: d=json.loads(line)
    except: continue
    m=d.get("message") or {}; role=m.get("role") or d.get("type"); c=m.get("content")
    if isinstance(c,str): add("user_text" if role=="user" else "assistant_prose", c); continue
    if not isinstance(c,list): continue
    for b in c:
        if not isinstance(b,dict): continue
        t=b.get("type")
        if t=="text": add("user_text" if role=="user" else "assistant_prose", b.get("text",""))
        elif t=="thinking": add("thinking", b.get("thinking",""))
        elif t=="tool_use": add("tool_call_input", json.dumps(b.get("input",{})))
        elif t=="tool_result":
            cc=b.get("content"); add("tool_result", cc if isinstance(cc,str) else json.dumps(cc))
        elif t=="image": cat["images"]+=1600; cnt["images"]+=1
tot=sum(cat.values()) or 1
print(f"{'category':<20}{'~tokens':>10}{'%':>7}{'items':>8}")
for k,v in cat.most_common(): print(f"{k:<20}{v:>10,}{100*v/tot:>6.1f}%{cnt[k]:>8}")
print(f"{'TOTAL':<20}{tot:>10,}")
print()
tool=cat['tool_result']+cat['tool_call_input']
print(f"Tool traffic: {100*tool/tot:.0f}%  ·  Chat prose to the user: {100*cat['assistant_prose']/tot:.0f}%")
print("If tool traffic dominates, the lever is HOW the session works (offload")
print("exploration to subagents, read narrow, fewer edit round-trips, split")
print("sessions) — not shortening the messages the user actually reads.")
PY
