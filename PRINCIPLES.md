# Distilled principles (with the incident that originated each one)

Each principle states whether it is **[PORTABLE]** (applies to any project)
or **[CONTEXTUAL]** (born from a specific stack/hardware — verify before
adopting). The "why" is not decorative: if you don't know the incident, you
will relax the rule exactly when it matters.

General frame: these principles are the operational implementation of the
AI-native pillar in `README.md` § Pillar (closed loop, queryable
organization, software factory, transparency, raising the floor,
tokens-not-headcount).

## Organization and roles

1. **[PORTABLE] The orchestrator coordinates, it does not execute.** Fixed
   roles (hybrid PO+SM PM, SWE, Tester, On-Call, optional Designer) in
   subagents with fresh context; the holistic view lives in the
   orchestrator and the files, not in the subagents. *Evidence: 9 issues
   shipped without loss of vision; the Master-Clone alternative was
   evaluated and discarded with our own data.*
2. **[PORTABLE] PM = PO + Scrum Master, no separate PO.** The human already
   is the real PO; an intermediate agent would only relay. Revisit only if
   volume overloads the PM.
3. **[PORTABLE] Views over existing data > a tracker of our own.** GitHub
   Issues/Milestones as the single source; boards/mission-control only
   render. *It prevented building a homegrown Jira twice.*

## Work cycle

(The full cycle, phase by phase, is in `SPRINTS.md` — here are the
principles that govern it.)

4. **[PORTABLE] Everything approved is filed as an issue AT THE MOMENT of
   approval**, before moving to the next topic. *Incident: a mockup
   approved in conversation was never filed; the human caught it, not the
   process.*
5. **[PORTABLE] The human defines WHAT and judges; the agents write the
   how.** Spec + acceptance criteria + test scenarios BEFORE implementing;
   product questions that define architecture go in the FIRST grooming
   pass. *Incident: the SEO question arrived late → double grooming, 82k
   tokens of poor handoff.*
6. **[PORTABLE] SWE in an isolated worktree, does not commit until
   approval; the orchestrator merges locally (no PRs) and syncs
   environments.** Large issues carry `.tmp/progress-{issue}.md` updated
   per sub-step. *Validated against a real interruption: the relaunched
   agent resumed without rework.*
29. **[CONTEXTUAL→verify] Worktree isolation (principle 6) isolates code,
    not necessarily a shared local dev database.** When the stack runs
    one local database service (e.g. Postgres via a local Supabase/Docker
    stack) shared by project_id/port across all worktrees, two SWEs
    touching schema in parallel WILL step on each other's resets — and
    the same root cause (shared mutable state + parallelism) can resurface
    one layer down even after the worktree-level case is fixed, e.g. test
    files racing on a shared seeded row inside a single worktree once the
    test runner parallelizes them. *Evidence: two independent SWEs in the
    source project both detected and self-recovered from the same
    collision; days later a variant hit at the test-file layer, which the
    worktree-level fix (serialize schema verification across worktrees)
    did not cover.* Treat "shared local state + parallelism" as a family
    of risk to re-check at each new layer of parallelism introduced
    (worktrees, test files, test runners), not a single fix-and-forget —
    and record the concrete mitigation (isolated ports, serialized
    verification, per-file test data) in the project's own LEARNINGS.md,
    since the exact stack/tooling is contextual even though the pattern
    is not.
7. **[PORTABLE] Verify, don't trust**: a truncated/cut-off agent report ≠
   bad work NOR good work — verify against the repo (`git diff`, run the
   tests yourself) before acting. And if what's missing is small, the
   orchestrator verifies inline instead of relaunching a full role (real
   measured saving: ~110k tokens on one occasion). Detail: `GUARDRAILS.md`.
8. **[PORTABLE] Maximum 2 relaunches of the same role on the same issue**;
   on the 3rd, escalate to the human.
9. **[CONTEXTUAL→verify] Operational stack traps** (Playwright workers on
   small machines, orphaned servers on the test port, `npm install` after
   merging a worktree with new deps, migrations read from the cwd, etc.):
   they live in each project's LEARNINGS.md, they are NOT copied as
   universal rules.

## Memory and documentation

10. **[PORTABLE] Four files, four lifespans**: `MEMORY.md` = working state
    (≤80 lines, gets pruned; every session reads it BEFORE exploring) ·
    `LEARNINGS.md` = append-only, never deleted · `DECISIONS.md` = one line
    per durable decision (ADR-lite) · `docs/retros/` = full narrative per
    sprint. Whatever must survive an interruption lives in files, never
    only in the chat.
11. **[PORTABLE] Checkpoint discipline**: MEMORY.md + commit + push at
    every phase/issue close and before compaction. The criterion is not
    "how many messages have gone by" but "is there anything in the chat
    that is not in a file?". Full protocol (before/during/handoff):
    `GUARDRAILS.md`.
12. **[PORTABLE] Full reports to the tracker, summaries to the chat.** Each
    agent posts its entire report as an issue comment — queryable forever;
    the summary is only the index.
13. **[PORTABLE] Memory before agent**: do not automate (nightly agents,
    watchdogs, automatic synthesis) until the manual memory/base is proven
    AND a counter crosses its threshold. See `README.md` § Future territory
    for the list of what is not yet validated.

## Rules about rules

14. **[PORTABLE] Triggers meta-rule**: every new rule or piece of
    infrastructure is defined with an objective counter + numeric threshold
    + trigger tied to an existing ritual (Sprint Close). Never "revisit
    later".
15. **[PORTABLE] Sprint Close with 5 fixed questions** (balance /
    carry-over / processes / commitments / cost-efficiency) + counters
    table. The 5th classifies costs into **expected / preventable-rework /
    poor handoff** — high cost ≠ a finding; only recurring waste is.
    Detail of each question: `SPRINTS.md` § Retrospective.
16. **[PORTABLE] Explicit confirmation rubric**: shared cloud DB,
    infra/billing, production, destructive git, credentials → ALWAYS a
    human ok per action, even if the issue is approved. Everything else
    runs on the sprint's "go" alone. Secrets: straight to their final
    destination, never to intermediate files nor the chat.
17. **[PORTABLE] Decisions pending on the human**: `human` label on the
    issue = source of truth; they are presented in a numbered batch with a
    default recommendation. A blocker only stops ITS issue — the team
    continues with the rest and pulls from the next sprint if this one runs
    out.
27. **[PORTABLE] A security gate's conditions attach to a future
    triggering event, not to the sprint boundary.** When a gate finds a
    forward-looking risk (not a bug in what shipped), don't force a binary
    block-vs-undated-P1 choice: file it as APPROVED WITH CONDITIONS,
    where each condition names a concrete trigger — "before public
    signups open," "before real third-party credentials load in a shared
    environment" — not just a priority label. The merge proceeds today;
    the debt becomes impossible to silently defer past the moment it
    actually turns exploitable. *Evidence: used twice in the source
    project (an auth-surface gate, then a webhook-plus-cron gate) — both
    times the conditions got tracked with their trigger event and neither
    slipped past it unnoticed.*
30. **[PORTABLE] "Approved with conditions" is two different mechanisms —
    name which one applies, don't let the phrase blur them.** Principle 27
    covers conditions tied to a FUTURE event (merge proceeds now). The
    other shape is BLOCKING-NOW: a finding that violates an absolute hard
    security rule on the exact surface being merged today, or one of the
    security role's own non-negotiable checklist items on code shipping
    right now — fix before merge, no deferral, regardless of an
    orthogonal perimeter control that happens to currently mask it (e.g.
    a temporary access wall in front of the whole app doesn't excuse a
    handle-enumeration bug in the page behind it). Decision rule: event-
    tied requires a genuinely separate future precondition (real
    third-party credentials, a feature not yet public) to become
    reachable at all; blocking-now is exploitable today by construction.
    *Evidence: the source project's first two gate-condition cases were
    both event-tied; its third sprint produced two blocking-now findings
    on surfaces being merged same-day (a SQL-wildcard enumeration bug,
    a non-constant-time secret comparison) — conflating them with the
    event-tied phrasing would have let both ship.*
31. **[PORTABLE] When a security gate proposes a literal code fix for
    later implementation, it states whether it checked the codebase for
    an existing equivalent pattern.** A gate's own proposed remediation
    can itself be the defect a LATER gate has to catch — the implementer
    built exactly what was asked, so the rework isn't implementer error,
    it's an unreferenced existing pattern in the same repo. *Evidence: a
    gate proposed a plain string-inequality secret comparison as "the
    concrete fix" for a deferred finding; a later gate on the issue that
    implemented it flagged the same non-constant-time gap the codebase
    had already solved twice elsewhere.* A 30-second grep for
    existing helpers at authoring time is cheaper than a full extra
    verification cycle sprints later.

26. **[PORTABLE] A policy without its variables logged is unevaluable.**
    When a rule makes something VARIABLE (which model, which effort level,
    which budget), the measurement schema gains that variable IN THE SAME
    change — decision inputs are logged at decision time, because outputs
    alone (tokens, duration) cannot evaluate inputs, and inputs are
    unreconstructible later. Every new policy declares its evaluation
    data contract (the exact columns) at creation, and "evaluate
    periodically" without a named data contract is intention, not a
    mechanism. *Incident: model-per-task and effort policies ran for 5
    real sprints while the logs captured only tokens/duration — the
    policies' own variables (model, effort) were never recorded because
    the tooling handed us outputs for free and nobody logged their own
    choices; the historical evaluation the user later asked for was
    impossible to produce, only approximable from the policy-in-force
    dates in the decision log.*

## Cost and models

18. **[PORTABLE] S/M/L estimated-cost size at grooming** (calibrate with
    the project's own real data); an L with a doubtful budget is split
    BEFORE dispatching, documenting the descope.
28. **[PORTABLE] S/M/L sizing should weight external-integration count
    and mid-issue architecture-pivot risk, not just apparent scope size.**
    Two issues sized identically at grooming cost 27% apart in
    implementer tokens; the delta traced cleanly to one integrating two
    third-party services (each its own client, webhook/signature surface,
    live schema-drift risk) against the other being 100% internal.
    Separately, small schema-only issues can legitimately blow their
    token band by 50-80% not from rework but from a real mid-issue
    discovery ("the proposed fix is a no-op, pivoting to a different
    mechanism") — that overrun is `expected`, not `preventable-rework`,
    when the pivot is reported rather than hidden. Add both as explicit
    sizing multipliers: count of external services integrated, and
    "resolves an open architecture question mid-implementation" as a flag
    that bumps the budget even for an otherwise-small issue.
19. **[PORTABLE — EVOLVING CHAPTER] Model + effort per task.** This chapter
    does NOT fix concrete models as a rule: assignment depends on the
    user's current plan and is re-evaluated periodically — each project
    records its own current policy and next evaluation date in its
    `docs/PROCESS.md`. What IS stable is the **conceptual framework** for
    deciding:
    - The model is decided by the **error blast-radius × automatic
      verifiability** matrix, NOT by the cost size (an S task may demand a
      high model due to the expected output quality or an iteration
      history — saving badly costs more than the fixed model, because of
      the rework).
    - **Effort is a separate dial** from the model: it is instructed in the
      dispatch prompt, it does not come implicit in the model choice.
    - **Advisor pattern**: "strong model plans, simple model executes,
      evaluate afterwards" — a pilot candidate, not a current rule.
    - Downgrade the model only in the low-damage +
      strong-automatic-verification quadrant, always with the **QA gate
      intact** (Tester/oncall are not downgraded along with the executor)
      and retry on a higher model at the first failure.
    - **Pilot with data before adopting** any assignment table: measure in
      a real sprint, compare against the baseline, only then codify.
    - Precondition for all of the above: record tokens/duration per agent
      from day 1 (principle 20).
20. **[PORTABLE] Record tokens/duration per agent from day 1** (the Task
    notifications already carry it — you just have to write it down).
    Without data, every efficiency discussion is theater. And judge the
    SYSTEM on numbers that can't argue back — outcomes (money landed,
    users retained, tests that ran), not agent activity.

## Dispatch patterns and role creation

24. **[PORTABLE] The Stop Rule before every parallel dispatch**: ask
    "where does the work split?" — no nameable independent pieces → it's
    a chain, use a single agent. The general parallel pattern is the
    diamond (split → parallel explore → evaluate → merge with one
    synthesis owner); pod/research/parallel-issues are its instances.
    Detail: `templates/quality/README.md` § 5.
25. **[PORTABLE] Every new role/pod/workflow is born under the birth
    contract** (`templates/agents/README.md`): it inherits the
    transversal rules by REFERENCE (reads PROCESS.md and the applicable
    modules), declares its cues and boundaries, and its creation passes
    the change checklist. Transversal rules live in ONE place — a rule
    copied into N role files is a drift bug, not thoroughness.

## Interaction with the user

21. **[PORTABLE] Explicit status at the start of every turn**: which agent
    is running, what finished, what is blocked on the user — never assume
    they reconstruct it from the history.
22. **[PORTABLE] Mission Control on demand**: active agents, latest result,
    sprint board, blocked-on-human, backlog, environment health, cost —
    with data queried at that moment.
23. **[PORTABLE] Ask EARLIER, not less.** Cost goes down when the right
    context arrives in the first handoff. And blocking questions are asked
    at the moment (they are not batched if they stall an issue).
32. **[PORTABLE] Act on friction and unconfirmed severity the same cycle
    they surface — never wait for a second occurrence.** Two distinct
    triggers deserve the identical orchestrator reflex: (a) an agent
    reports operational friction in passing without requesting action
    (disk space, a flaky dependency, a slow step) — investigate and fix
    it now rather than letting it become a hard blocker for a later
    dispatch; (b) a severity call from an earlier pass gets informally
    re-characterized under different, non-matching language by a later
    verifier (e.g. "known flakiness" resurfacing as "possible real
    leak") — dispatch a dedicated, definitive investigation immediately
    rather than either dismissing the new language or silently
    inheriting the old verdict into the next report as settled fact.
    Both failure modes compound the same way: something unconfirmed gets
    treated as confirmed simply because nobody stopped to check. *Evidence:
    a source-project orchestrator caught a disk-space report from an
    implementer and freed it via a safe, reversible cleanup before the
    next dispatch could fail on it; separately, a security ambiguity that
    had been informally called "test flakiness" for two sprints got a
    dedicated adversarial investigation the moment a different verifier's
    language declined to repeat that verdict — confirmed benign, but only
    because it was checked rather than assumed.*
