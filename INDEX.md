# Kit index — what to read, when

> Navigation map, created because the kit grew past what one sitting
> absorbs. One line per piece: what it is and WHEN a session actually
> needs it. Nothing here replaces the documents — this is the map, not
> the territory.

## Root documents

| File | What | Read when |
|---|---|---|
| `README.md` | Pillars, evidence states + validation ledger, improvement loop (two-question rule), credits | First contact with the kit; before any evaluation of a new practice |
| `BOOTSTRAP.md` | Step-by-step project setup (9 question areas incl. design fork + security grill-me) | Starting a NEW project |
| `PRINCIPLES.md` | 25 numbered principles with their originating incidents | Session start refresh; when a decision feels like re-litigating something |
| `SPRINTS.md` | Sprint methodology detail + label taxonomy | Sprint planning/close |
| `GUARDRAILS.md` | Session/context/spend limits, triggers-counters mechanism, effort-first lever, advisory pattern | Cost/limits questions; defining any new rule (counters) |
| `INDEX.md` | This map | When you can't find where a rule lives |

## Templates — project skeletons

| Piece | What | Read when |
|---|---|---|
| `templates/docs/PROCESS-template.md` | The project process spec (issue lifecycle, roles, all module summaries, kit-sync) | Instantiating a project; the project's own copy is then the source |
| `templates/docs/STACK-DEFAULTS.md` | Early-stage stack defaults + the web-AND-mobile excellence principle | Bootstrap with undecided stack |
| `templates/docs/LEARNINGS/DECISIONS/MEMORY/AGENTS templates` | The four memory files | Bootstrap |
| `templates/agents/README.md` | **Birth contract** — how any new role/pod/workflow inherits the system | CREATING any new role/pod/workflow |
| `templates/agents/*.md` (8 roles) | PM · SWE · Tester · On-Call · Designer · Security · Data Architect · Platform | Dispatching or instantiating that role |

## Modules (plug-and-play)

| Module | What | Read when |
|---|---|---|
| `templates/design/README.md` | Fixed-system/genesis fork, Designer modes, design pod, catalog | UI work; bootstrap question 8 |
| `templates/docs/database/README.md` | Business-language DB docs format + hard sync rule + conditional API-contract chapter | Any schema work; bootstrap |
| `templates/security/README.md` | Threat model, PII inventory, controls map, hybrid authz checklist, credential handling | Security-touching issues; bootstrap question 9; certification questions |
| `templates/launch/README.md` | 8-section pre-launch checklist + gate ritual + conditional CI/CD chapter | Before ANY public launch; reliability audits |
| `templates/quality/README.md` | Bug entity, change checklist, carry-over interest, optimization loop, diamond dispatch | Every merge (checklist); bugs; sprint planning (carry-over); any parallel dispatch (Stop Rule) |

## The rules most often needed mid-task

- Parallel dispatch? → Stop Rule (quality § 5).
- Touching schema/PII/security config? → same-cycle docs sync (change checklist).
- New role? → birth contract.
- New practice to evaluate? → two-question rule (README § Improvement loop).
- Postponing debt? → carry-over framework + floor (quality § 3).
- Metric-shaped goal? → optimization loop (quality § 4).
