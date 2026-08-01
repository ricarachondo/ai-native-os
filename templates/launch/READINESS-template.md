# Launch readiness — {{PROJECT}} ({{LAUNCH_NAME}}, {{DATE}})

> Instantiated as `docs/launch/READINESS.md` when the launch gate ritual
> runs. One row per check of the launch module's checklist
> (`templates/launch/README.md`), each section dispatched to its owning
> role. 🔴 blockers must pass to launch; 🟡 first-week items become
> issues AT THAT MOMENT; later launches re-run the delta only.

Status legend: ✅ pass · 🔴 blocker (must pass) · 🟡 first-week (issue
filed) · ⚪ n/a (declared, with reason)

| # | Section | Check | Owner role | Status | Evidence | Date |
|---|---|---|---|---|---|---|
| 1 | Security | {{RLS / server-side enforcement / secrets / rate limits…}} | Security | ⚪ | {{command/report link}} | {{}} |
| 2 | Email deliverability | {{SPF/DKIM/DMARC, from-domain, unsubscribe}} | Platform | ⚪ | {{}} | {{}} |
| 3 | Findability | {{indexing, sitemap, meta, og}} | Platform | ⚪ | {{}} | {{}} |
| 4 | Speed — infra | {{cold starts, caching, CDN}} | Platform | ⚪ | {{}} | {{}} |
| 5 | Speed — UX | {{perceived load, skeletons, CWV}} | Designer/SWE | ⚪ | {{}} | {{}} |
| 6 | Analytics | {{events land, at least one conversion funnel defined}} | Platform | ⚪ | {{}} | {{}} |
| 7 | Processing reliability | {{timeouts, jobs out of request cycle, idempotent retries}} | Platform | ⚪ | {{}} | {{}} |
| 8 | Legal | {{ToS + privacy (generated from PII-INVENTORY)}} | USER approves | ⚪ | {{}} | {{}} |
| 9 | Final test | {{key flows on the LIVE surface}} | Tester | ⚪ | {{}} | {{}} |

## Verdict

{{GO / NO-GO — by whom, when, with the 🔴 list empty or the explicit user
override recorded in DECISIONS.md.}}
