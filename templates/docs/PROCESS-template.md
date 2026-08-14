# Development Process — {{PROJECT}}

> Skeleton distilled from the ai-native-os kit. Sections marked {{...}} are
> filled in during the bootstrap; the rest is the validated system —
> changing it requires the triggers meta-rule (below). Detailed sprint
> methodology: the kit's `SPRINTS.md`. Precautions against session/spend
> limits: the kit's `GUARDRAILS.md`.

## Overview

GitHub Issues + Milestones (=Sprints) as the single tracker; boards only as
a view. Five agents cover the full cycle; the orchestrator (top-level
session, with the user as supervisor) coordinates and merges — it does NOT
groom, implement, test or accept personally.

This document is the spec the agents execute directly. Every process in the
project, once productized, is documented to that same bar (index:
`docs/workflows/README.md`).

## Links

- Repo: {{REPO_URL}} · Issues: {{ISSUES_URL}} · {{OTHERS}}

## Issue lifecycle

```
Orchestrator files → PM groom → SWE builds → Tester verifies → PM accepts → Ship
```

1. The orchestrator files the raw issue from the user's intake
   (chat/feedback/screenshot), label `needs grooming`. **Hard rule**: what
   the user approves in conversation is filed as an issue AT THAT MOMENT,
   before moving to the next topic. Same with out-of-scope problems
   discovered along the way — a new issue on the spot, never a silent fix
   (exception: small bugs within the same scope, which the SWE fixes and
   reports).
2. The PM investigates the real code and rewrites: scope, measurable
   acceptance criteria (`[HUMAN]` for the non-automatable), dependencies,
   test scenarios, **S/M/L cost size** (<100k / 100-250k / >250k tokens,
   calibrate with your own data), and external data/content dependency
   risks. Product questions that define architecture go in the FIRST pass.
   An L with a doubtful budget is split before dispatching. **Every new
   user action (publish/save/send) specifies its feedback on 3 axes:
   severity (success/info/warning/error) × duration (transient vs
   persistent) × channel (toast/inline/banner/invisible-monitoring-only) —
   it is not left implicit nor discovered in production.** Mandatory
   field: "touches auth / sensitive data / public surface?" — yes →
   `security` label at birth (see § Security).
3. The SWE implements in an isolated worktree + tests. Issues >~3 files or
   with schema: sub-steps + `.tmp/progress-{issue}.md` kept updated. Does
   NOT commit. **The dispatch enumerates the issue's mandatory gates**
   (specific E2E coverage, security gate, docs sync) instead of leaving
   them implicit in the issue body — a requirement the prompt does not
   name loses to the twelve acceptance criteria that are competing for
   attention (PRINCIPLES #33).
4. The Tester runs EVERYTHING independently (does not trust the SWE's
   report) and verifies every criterion. Reports pass/fail on the issue.
5. PM acceptance review from the end user's perspective.
6. The orchestrator commits in the worktree, merges locally to main (no
   PRs), **migrations/infra to the cloud BEFORE pushing the code**, push +
   environment sync, cleans up the worktree.
7. On-Call verifies the real deploy (status + curl to key routes, not just
   "build OK"). Severity by real user impact, not by status code.

**Parallelism**: up to 2 independent issues at a time. A blocker on the
user (label `human`) only stops ITS issue; if the sprint runs out, groomed
work from the next one is pulled forward.

## Labels

Full taxonomy in the kit's `SPRINTS.md` § Labels: type (`bug`, `feature`,
`enhancement`, `refactor`, `docs`, `chore`) · priority (`P0` must-have /
`P1` important, prioritized in the next available sprint / `P2`
nice-to-have) · process (`needs grooming`, `human`) · area:
{{PROJECT_AREA_LABELS}}.

## Mission Control

When dispatching/receiving agents, when the sprint changes, or on request:
a board with data queried at that moment — active agents, latest result,
sprint board, **blocked-on-user as a numbered batch** (each item: 1-line
context + default recommendation + what happens if there is no answer;
source of truth = `human` label), backlog + detected gaps, environment
health, cost/tokens.

## Communication contract with the user (altitude, not length)

The user's profile is declared at bootstrap ({{USER_PROFILE}}) and governs
the ALTITUDE of every report. For a non-technical owner (product,
strategy, design, business, operations) the default shape is:

1. **The finding or decision in business terms** — what changed, what it
   means for the product or the user, in the first two lines.
2. **The numbers that carry the decision**, not every number produced.
3. **What needs their input**, with a recommendation and its cost/risk.
4. **Technical evidence lives in the artifact** (issue comment, doc,
   run record) and is LINKED, never pasted: column names, `file:line`,
   type signatures, query output and stack traces belong to the record.
   The house pillar already says "full reports to the tracker, summaries
   to the chat" — it applies to the orchestrator too, not only to agents.
5. **Identifiers appear only when the user must act on them.**
6. **Depth on demand**: an explicit trigger ("explain X", "show me the
   detail") switches to teaching mode for that topic — the user learning
   the technical layer is a goal, but it is pulled, never pushed.

What does NOT get trimmed, ever: decisions taken, risks, blockers, what
was verified vs assumed, cost, and anything the user must approve. The
contract reduces ALTITUDE, never visibility or control.

Live-narration discipline: report the conclusion and what it cost, not a
play-by-play of each tool call — the collapsed tool lines already show
the work happened.

## Role-defaults check (orchestrator session start)

One command with the kit-sync and disk checks:
`scripts/role-defaults-check.sh .` — proves the model+effort table is
actually applied. A role without a declared model does not fall back to
the table; it inherits the session's model, and "we have a policy" then
looks identical to "everything runs on the strongest model". Red check →
fix before dispatching anything.

## Disk check (orchestrator session start)

Cheap, once per session: check free disk space; **<15GB free → propose
housekeeping to the user** before starting new work (stop unused local
stacks, prune dangling images, review paused projects for hibernation —
kit `GUARDRAILS.md` § 2b). Same cost-shape as the kit-sync check.

## Continuity against session limits

Full protocol in the kit's `GUARDRAILS.md`. Operational summary:

1. Truncated report ≠ bad work NOR good work: read `.tmp/progress-*.md`,
   verify the repo (`git status/diff`, run the tests yourself), and only
   then decide. Relaunch referencing the VERIFIED state, never from
   scratch.
2. If what's missing is small, the orchestrator verifies inline — cheaper
   than a full role re-reading everything.
3. **Maximum 2 relaunches of the same role per issue; at the 3rd, escalate
   to the user.**
4. When an agent dies: kill its child processes (orphaned servers/ports)
   verifying first that they belong to it, before verifying or relaunching.
5. New session: reads MEMORY.md + verifies the real state of the repo
   BEFORE starting new work — if they differ, the repo wins.

## When the user's explicit confirmation is required

ALWAYS, per individual action (even if the issue is approved): shared cloud
DB, infra/billing, production, destructive git, credentials (secrets go
straight to their final destination — never to intermediate files nor the
chat). Everything else runs on the sprint's "go" alone. `PushNotification`
if the team is left blocked waiting for it.

## Sprint end (Sprint Close)

Assembled by the PM when all the milestone's issues reach a terminal state.
**Its artifacts are a precondition for the next sprint's "go"**, not a
deferrable closing step: retro file, milestone closed, carry-over ledger
updated, counters moved, metrics rows present. This is the only ritual
that audits global state, so nothing reports it when it stops running
(kit `SPRINTS.md` § 3).
Format: Shipped / Not shipped / Carry-over / New backlog / Next sprint
recommendation / **5 fixed-question retrospective** (detail of each one:
the kit's `SPRINTS.md` § Retrospective):

1. **Balance** — what we accomplished, what not, why (distinguish a
   correctly discovered scope boundary from a real failure).
2. **Carry-over** — still a priority? correct slicing? interruptions?
   Every carry-over item gets the `carry-over` label with its origin
   sprint, and the pinned **Carry-over ledger** issue is updated (item ·
   age · interest · latest decision + reason). At the NEXT sprint's
   planning the PM decides take/postpone per item using **age × interest
   (does it touch fast-changing code?) × user impact × effort** — decision
   and reason recorded and reported, never silent. Floor: postponing an
   item with age ≥3 sprints or severity S1/S2 requires the user's explicit
   ok. Full module: the kit's `templates/quality/README.md`.
3. **Processes** — bottlenecks; is the DoD still realistic?
4. **Commitments** — concrete, measurable actions, not intentions.
5. **Cost and efficiency** — real tokens/duration table per agent; most
   expensive issue classified as **expected / preventable-rework / poor
   handoff**; which interaction pattern with the user worked or generated
   friction.

**Audit rituals at every close** (playbook `templates/quality/AUDIT-PLAYBOOK.md`):
the Security Engineer runs dimension A1 and the Tester dimension A2 as
part of the close; the FULL 12-dimension sweep + backward review runs when
the product is functionally complete, before the launch gate.

**Housekeeping at close**: if this project has no sprint immediately
following, propose hibernation (kit `GUARDRAILS.md` § 2b) — stop the
local stack without backup, drop `node_modules`/`.next`. Otherwise just
stop the stack + prune dangling images.

The orchestrator ALWAYS relays the full report to the user in the
conversation. Narrative → `docs/retros/YYYY-MM-DD-sprint-N.md`; real
learnings → `docs/LEARNINGS.md` (append-only); durable decisions →
`docs/DECISIONS.md` (one line); project-agnostic learnings → proposal to
the kit.

**Kit sync (two directions, fixed cadence)**:
- **Upstream (at Sprint Close, mandatory)**: project-agnostic learnings are
  promoted to the kit IN the same close — translated to English, anonymized
  (identity out, lesson and numbers in), committed and pushed. While there,
  note in the report if the kit has updates this project has not evaluated
  yet (note only — adoption happens at the next sprint start).
- **Downstream (marker-based, checked at EVERY orchestrator session
  start)**: the project keeps a one-line living marker in this section —
  `kit-sync: {{LAST_ADOPTED_SHA}} ({{DATE}})` — updated in the same edit as
  each adoption. At session start, run `git ls-remote <kit-remote> main`
  (one command, free when nothing changed) and compare with the marker.
  Equal → done, zero extra work. Different → pull and review ONLY the
  `marker..HEAD` commits.
- **Adoption by TYPE of change**, not all alike:
  - **Learnings/traps** (informational, error-preventing): adopt
    IMMEDIATELY, in any session — waiting for the sprint boundary wastes
    the improvement exactly when it helps.
  - **Process rule/structure changes**: defer to the next sprint boundary
    (half a sprint under one rule and half under another = inconsistency),
    EXCEPT hard rules born from an incident (damage-preventing → adopt
    now, with a note to the user).
  - Adoption is always SELECTIVE (portable/contextual distinction); changes
    that alter the project's own hard rules require the user's ok.

### Automatic triggers for new infrastructure

**Meta-rule**: every new rule/infra is defined with an objective counter +
threshold + trigger tied to the Sprint Close — never "revisit later".
Crossing the threshold fires the PROPOSAL, not the construction (that
requires the user's ok).

| # | What it measures | Threshold | Status |
|---|---|---|---|
| 1 | Interruptions no live process picks up | 2 in 3 sprints → external watchdog | 0/2 |
| 2 | Same preventable/poor-handoff finding unresolved despite a light fix | 2 of 3 sprints → efficiency role | 0/3 |
| 3 | {{PROJECT_SPECIFIC_TRIGGER}} | {{...}} | 0/N |
| 4 | Close of the last planned sprint | → PM switches to proposing improvements with data | pending |

## Roles

| Agent | File | Role |
|---|---|---|
| Product Manager (hybrid PO+SM) | `.claude/agents/product-manager.md` | Grooms specs + acceptance review + facilitates the retro |
| Software Engineer | `.claude/agents/software-engineer.md` | Implements + tests, does not commit |
| Tester | `.claude/agents/tester.md` | Verifies everything independently |
| On-Call | `.claude/agents/oncall-engineer.md` | Real deploy post-push |
| Designer | `.claude/agents/designer.md` | Two modes: triaged audit of existing UI + spec of new surfaces (grill-me → brief → IA) before grooming. See the full module in the kit's `templates/design/README.md` (fixed-system/genesis fork, design pod) |
| Data Architect | `.claude/agents/data-architect.md` | Two modes, mirroring the Designer: triaged audit of the real data model vs `docs/database/` vs actual query patterns + spec of the data model for new features (data grill-me → proposal) before grooming. Only for NON-trivial data decisions — trivial schema changes stay with the SWE. Full module: the kit's `templates/docs/database/README.md` |
| Platform Engineer | `.claude/agents/platform-engineer.md` | Two modes: standing reliability audit of the backend platform (timeouts, rate limits, background jobs, retries/idempotency, observability, email/DNS infra) + launch gate (executes its sections of the launch-readiness checklist). Audit/spec only — findings become issues the SWE builds. Full module: the kit's `templates/launch/README.md` |
| AI Engineer | `.claude/agents/ai-engineer.md` | Two modes: spec of AI/conversational surfaces before grooming (interaction contract, golden set defined up front, context/tool scoping, budgets) + eval/audit (runs golden + adversarial sets, reports numbers, blocks regressions). Spec/eval only. Full module: the kit's `templates/ai-features/README.md` |
| Security Engineer | `.claude/agents/security-engineer.md` | Gate on sensitive issues (auth/secrets/row-security/tokens/PII) and pre-promotions, plus on-demand audits. Fixed core checklist (secrets, server-side authz, IDOR, input validation, state-transition visibility) + the project's own frozen extension. Evidence-backed findings only — does not implement |

## Model and effort assignment — EVOLVING CHAPTER

**This chapter does NOT fix concrete models**: it depends on the user's
current plan and is re-evaluated periodically (next recorded evaluation:
{{NEXT_EVALUATION_DATE}}, with the user's reference articles).

- The project's current policy: {{CURRENT_MODEL_POLICY — the user defines
  it in the bootstrap; record it here with date and review condition}}.
- Stable conceptual framework (see the kit's `PRINCIPLES.md` § 19): the
  model is decided by the **blast-radius × automatic verifiability** matrix
  (not the cost size); effort is a separate dial instructed in the dispatch
  prompt; the Advisor pattern ("strong model plans, simple model executes,
  evaluate afterwards") as a pilot candidate; downgrade the model only with
  the QA gate intact, retry on a higher model at the first failure, and a
  pilot with data BEFORE adopting any table.
- Precondition: record tokens/duration per agent from day 1.

## Design

Sequence for NEW surfaces: Designer in spec mode (grill-me → brief → IA in
`docs/design/<feature>/`) → PM grooms consuming the brief (never blind) →
SWE (with prior inventory) → Tester → [Designer audit, optional]. UI issues
= vertical slices (buildable and verifiable on their own). Design pod (2-3
parallel explorations + Designer as synthesizer-judge) for size M+ surfaces
with no pattern to copy — a dispatch pattern, not a permanent structure
(trigger to formalize: 3+ pods in one sprint). Full module: the kit's
`templates/design/README.md`.

## Database documentation

Living, business-language docs of the data model in `docs/database/`: one
file per table (what it is, relationships, columns with business notes,
keys, indexes with their reason) + `relationships.md` + `schema.md` +
`architecture.md`. **Hard rule**: every issue that touches the schema,
relationships, security model (RLS/policies), storage, or data
infrastructure updates these docs in the same cycle — the SWE writes the
update, the PM verifies it in acceptance review as part of the Definition
of Done. A schema change with stale docs is rejected like a feature with
no tests. Full module (format, bootstrap for existing schemas, and the
data-architect role trigger): the kit's `templates/docs/database/README.md`.

## Security (proactive, not reactive)

Full module: the kit's `templates/security/README.md`. Operational summary:
- **Bootstrap**: security grill-me → `docs/security/THREAT-MODEL.md`
  (sensitive data, actors, never list); each never-list sentence is a hard
  rule here from day one.
- **Grooming**: mandatory PM field "touches auth / sensitive data / public
  surface?" — yes → `security` label at birth → Security Engineer gate is
  automatic.
- **Living docs with hard sync rules**: `PII-INVENTORY.md` (new personal
  datum → same-cycle update; privacy policy generates FROM it) and
  `CONTROLS.md` (certification-readiness map: control → practice →
  evidence).
- **Tooling**: `security-guidance` plugin + `/security-review` complement
  the role gate, never replace it. Third-party security skills are
  reviewed before installing.

## Delivery quality (bugs, changes, carry-over)

Full module: the kit's `templates/quality/README.md`. Operational summary:
- **Bugs** use the fixed template (tracker issue form): pre-filing
  verification (duplicate search with the query as evidence, regression
  check, data-or-code, affected flows) and mandatory close fields — root
  cause, fix commit, **the regression test** (no bug closes without one).
  Severity S1-S4 by real user impact.
- **Every merge** passes the change checklist
  (`templates/quality/CHANGE-CHECKLIST.md`): deprecation with grep
  evidence + removal plan, migration rollback/backfill/verification,
  breaking changes with consumers updated, env vars in all environments,
  docs sync, diagnosability. "n/a" is declared, never assumed.
- **Carry-over**: see § Sprint end — age, PM decision framework, floor
  rule, pinned ledger.

## AI features (conversational / model-dependent surfaces)

Full module: the kit's `templates/ai-features/README.md`. Operational
summary:
- **Hard rule**: a prompt without an eval is a change without a test. The
  golden set is defined BEFORE implementation and runs before any
  prompt/context/model change merges.
- **Grooming**: any conversational/AI feature is `security-relevant` by
  default → both the Security Engineer and the AI Engineer gates fire.
  The AI Engineer's spec runs BEFORE grooming (like the Designer's).
- **Security seam**: the Security Engineer owns the authorization
  boundary (caller privileges — the AI feature is NEVER the authz
  boundary — no secrets in context, never-list re-tested through the
  chat); the AI Engineer owns the model-specific surface (injection, tool
  scoping, refusal design) and PROVES it with adversarial evals.
- **Platform Engineer** owns the operational envelope (cost/latency
  ceilings, provider-failure behavior, prompt versioning).

## Launch readiness (gate ritual)

Before ANY public launch (first launch, or a major surface going public
later): the orchestrator runs the launch-readiness checklist as a batch —
each section dispatched to its owning role (Security → security role or
Platform Engineer · Email/Findability/Speed-infra/Analytics/Processing
reliability → Platform Engineer · Speed-UX → Designer/SWE · Legal →
prepared for the USER's explicit approval · Final test → Tester, on the
live surface). Results land in `docs/launch/READINESS.md` (status +
evidence + date per check). 🔴 blockers must pass to launch; 🟡 first-week
failures are filed as issues AT THAT MOMENT; later launches re-run the
delta. Full checklist and ownership map: the kit's
`templates/launch/README.md`.

## Agent metrics log (measurement, principle 20 mechanized)

Every agent dispatch appends ONE row to `docs/metrics/dispatches.csv`:
`date,sprint,issue,role,model,effort,tokens,duration_min,relaunch,bucket`
(bucket = expected / preventable-rework / poor-handoff, filled at retro).
The task notification already carries tokens/duration — recording model
and effort at dispatch time is the missing habit. The Sprint Close renders
the dashboard from this file (model/effort mix per role over time, cost
per issue trend, relaunch counts) — visualization is cheap once the data
is structured; unstructured retro prose cannot be trended.

## Model and effort per role — DEFAULTS, not a framework to interpret

Why this is a table and not a decision rule: the previous version asked
each dispatch to weigh blast-radius × verifiability. Under time pressure
that judgment collapses to "use the strongest model" every time — nobody
is ever blamed for over-spending on quality, and a weak model's cost
(rework) is visible while the token cost is not. Result observed in a
real project: every role pinned to the strongest model, no effort
declared anywhere, zero measurements. That is not "no policy" — it is a
maximum-everything policy chosen by inertia.

The judgment happens ONCE, when this table is written. Then it just runs.

| Role | Model | Effort | Why |
|---|---|---|---|
| PM (groom + acceptance) | strong | high | Product judgment; a bad spec costs the whole issue |
| SWE — size M/L or schema | strong | high | Blast radius real even with tests |
| SWE — size S / mechanical | mid | medium | High automatic verifiability (tests + Tester catch it) |
| Tester | strong | medium | **QA gate — never downgraded**; execution is mechanical, reading failures is not |
| On-Call | mid | low | Checklist against the real deploy, highest verifiability; escalate on ANY anomaly |
| Designer · Data Architect · AI Engineer · Security | strong | high | Judgment-heavy, low automatic verifiability, expensive to undo |
| Platform (audits) | strong | medium | Script-driven diagnosis, judgment in the triage |

**Three rules that make downgrading safe** (the balance the user asked
for — quality is not traded away, its cost is bounded):
1. **Escalate on first failure**: a dispatch that fails or returns weak
   output is relaunched one tier up. The downside of a cheap default is
   one wasted dispatch, never a bad merge.
2. **QA gates never downgrade**: Tester, security and acceptance keep
   their tier regardless of what the executor used.
3. **Effort is the first lever, before the model** — cheaper to tune and
   reversible per dispatch.

**Every dispatch records model + effort** in `docs/metrics/dispatches.csv`
(PRINCIPLES #26 — a policy without its variables logged is unevaluable).
This table is a HYPOTHESIS until that log has data: review it at the
Sprint Close after ~20 recorded dispatches and adjust with evidence, not
opinion.

## Token efficiency (effort, task budgets, advisory)

See the kit's `GUARDRAILS.md` § "The first lever is effort" for the full
pattern and its safeguards. Operational summary:

- **Staged effort**: rollout per role starting with the most mechanical one
  (oncall at `low` + explicit checklist + escalation rule: anomaly → stop
  and report, re-dispatch at high effort). Extend only with retro data —
  low effort reduces tool calls and the QA gates depend on long sequences.
- **Task budgets**: every SWE dispatch includes size + indicative token
  budget (a self-regulation signal, not a cap).
- **Mid-task advisory** (advisor without the API): proactive (the agent
  requests it with an `ADVISORY REQUEST` block: situation + question + its
  recommendation; max 2/issue) and reactive (a correction plan before the
  2nd relaunch). The advisor only advises, never executes.
