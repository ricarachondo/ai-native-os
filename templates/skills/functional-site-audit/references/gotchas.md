# Tactical gotchas & quick checklist

## Pitfalls table (learned the hard way)

| Symptom | Cause | Fix |
|---|---|---|
| Chrome extension disconnects mid-task | Chrome service worker sleeps | Retry once; if it persists, migrate to Playwright |
| `libXdamage.so.1` missing in Playwright | Sandbox lacks Chromium libs | `cd /tmp && apt-get download libxdamage1 && dpkg -x libxdamage1*.deb /tmp/libs && export LD_LIBRARY_PATH=/tmp/libs/usr/lib/aarch64-linux-gnu` (adjust arch) |
| Page goes blank after instrumenting fetch | You consumed `res.body` with getReader | Use `res.clone()`; never read the original body |
| Huge response truncates / breaks the tool | Tooling size cap | Save to file + jq/python; or resend a simpler query with a larger cap |
| Click fails after a resize | Stale coordinates | Re-screenshot; prefer `find`/element refs over coordinates |
| Mobile viewport doesn't change in Chrome MCP | Resize doesn't affect the logical viewport | Real emulation in Playwright |
| A message sends twice | Site double-submit (bug) | Document it as a QA finding |
| SPA returns an empty shell | Read before JS render | Wait for networkidle; or use a JS-executing tool (get_page_text) |
| `wait > 10s` / `scroll > 10` rejected | Chrome-MCP limits | Chain waits; setTimeout via javascript_tool; scroll in steps |
| Playwright timeout on `.click()` | Element not stable / off-screen | `scroll_into_view_if_needed` + `click(force=True)`; or click by role/text |

## Per-engagement checklist

```
[ ] Intake: scope, depth, deliverables, ETHICAL limits confirmed
[ ] Folder structure + task list with a verification step
[ ] Recon: tool tier, tech fingerprint, flow map (Mermaid)
[ ] Instrumentation: fetch/XHR interceptor (clone!), storage, client spies
[ ] Deep pass: card per screen (states/fields/actions/network)
[ ] Adversarial pass: validations, double-submit, refresh, back, session, forced errors
[ ] Payloads captured -> real data model
[ ] Active modules: conversational AI / mobile / notifications / series / backend
[ ] Cross-cutting: a11y, performance, i18n, business/telemetry
[ ] Analysis .md (summary, map, cards, network, model, evidence table)
[ ] PRD .md (problem, metrics, scope, technical, edge, acceptance, phasing)
[ ] HTML twin + versioned screenshots + README
[ ] Verification: HTML valid, evidence cross-checked, coverage, dated, artifacts cleaned
[ ] Adopt/improve on every key pattern; antipatterns documented
```

## Meta-risks to watch
- **Confirmation bias** — the user may want "X does it well"; actively document what X does badly.
- **Hallucination by analogy** — don't fill backend gaps with "the usual"; keep observed/inferred discipline.
- **Exhaustiveness vs usefulness** — every finding must inform a product decision, else it goes to an appendix.
- **Perishable snapshot** — date everything; save the instrumentation snippets to re-audit later.
