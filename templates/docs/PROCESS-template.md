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
   it is not left implicit nor discovered in production.**
3. The SWE implements in an isolated worktree + tests. Issues >~3 files or
   with schema: sub-steps + `.tmp/progress-{issue}.md` kept updated. Does
   NOT commit.
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
Format: Shipped / Not shipped / Carry-over / New backlog / Next sprint
recommendation / **5 fixed-question retrospective** (detail of each one:
the kit's `SPRINTS.md` § Retrospective):

1. **Balance** — what we accomplished, what not, why (distinguish a
   correctly discovered scope boundary from a real failure).
2. **Carry-over** — still a priority? correct slicing? interruptions?
3. **Processes** — bottlenecks; is the DoD still realistic?
4. **Commitments** — concrete, measurable actions, not intentions.
5. **Cost and efficiency** — real tokens/duration table per agent; most
   expensive issue classified as **expected / preventable-rework / poor
   handoff**; which interaction pattern with the user worked or generated
   friction.

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
