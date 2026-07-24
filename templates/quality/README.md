# Delivery-quality module — bugs, changes, and carry-over with compound interest

> Self-contained module for the second half of "fast AND clean": a
> standardized bug entity (queryable forever), a change checklist that
> catches deprecation/migration fallout before the merge, and carry-over
> management that makes debt's compound interest VISIBLE instead of
> silently accumulating. Research note (2026-07): the skill/agent
> ecosystem's weakest area is exactly change-impact analysis
> (deprecation, backfill/rollback, breaking changes) — this module is
> built, not adopted, for that reason.

## 1 · The bug as a standardized entity

Bugs are filed with the fixed template (`BUG-template.md` → install as a
GitHub issue form so the structure is queryable by agents and humans).
The two rules that make it compound in value:

- **Pre-filing verification checklist** (inside the template): search for
  duplicates/prior occurrences WITH the query used as evidence · check
  whether it is a regression (did it work before? which commit?) · data
  or code? (corrupt data and buggy code are fixed differently) · affected
  flows listed.
- **Closing requires three fields**: root cause (not the symptom) · fix
  commit · **the regression test that now prevents it**. Hard rule: no
  bug closes without leaving a test — it is the only structural guarantee
  it stays fixed. If the root cause is process (not code), it also goes
  to LEARNINGS.md.

Severity is by REAL USER IMPACT, fixed scale: **S1** users blocked or
data at risk · **S2** core flow degraded, workaround exists · **S3**
non-core flow broken · **S4** cosmetic. Labels: `bug` + `S1`-`S4`.

## 2 · The change checklist (merge gate)

Applies to every merge; most items are "n/a" for small changes — the
value is that n/a is DECLARED, not assumed. The SWE fills it at
completion, the Tester verifies it, the reviewer rejects merges with
unaddressed items (`CHANGE-CHECKLIST.md` has the full version):

- **Deprecation**: what is deprecated · who consumes it (grep evidence,
  not intuition) · removal plan with date or trigger — deprecated
  without a removal plan is new debt in disguise.
- **Data migration**: reversibility/rollback · backfill plan · promotion
  order across environments · post-migration verification with counts,
  not faith.
- **Contract/API breaking changes**: listed explicitly, consumers
  updated in the same cycle.
- **Environment config**: new env vars set in ALL environments (a real
  incident class: the feature works in one environment and silently
  fails in another).
- **Docs sync**: database docs if schema changed · PII inventory if
  personal data changed · CONTROLS.md if a security practice changed —
  the existing hard rules converge here as one checklist.
- **Diagnosability**: does the change leave signals (logs, error
  tracking) to debug itself if it fails in production?

## 3 · Carry-over with visible compound interest

Debt that is not taken gets harder every sprint: the code around it
changes, the context evaporates, the fix cost grows. The system makes
that interest visible and puts the decision on the record:

- **Age**: every carry-over item records its origin sprint (label
  `carry-over` applied at Sprint Close). Age = sprints since origin.
- **PM decision framework** (at sprint planning, per item): **age** ×
  **interest** (does it touch code that changes often? then it gets
  expensive fast) × **user impact** × **effort**. The PM decides take or
  postpone — the decision AND its reason are recorded and reported to
  the user in the sprint plan summary. Never silent.
- **Floor (the only hard part)**: postponing an item with **age ≥3
  sprints or severity S1/S2** requires the user's explicit ok — the
  extreme cases of compound interest are the user's call, not the PM's.
- **The ledger**: a PINNED issue ("Carry-over ledger") updated at every
  Sprint Close — table of item · origin sprint · age · interest ·
  latest PM decision + reason. Pinned = the user sees the debt state
  from a phone in two taps, no queries. The Sprint Close ritual already
  reports carry-over; the ledger is its persistent, always-current view.

## 4 · Optimization loop (dispatch pattern — specified, pending first validation)

For problems with an **objective scalar metric** (memory, p95 latency,
bundle size, cost, the agents' own token spend) — never for feature work.
The shape: *"reduce {metric} of {target}; up to {N} experiments; keep a
log; verify under {realistic conditions}"*.

**Preconditions (the loop is worthless without them):**
1. The metric is measurable automatically and reliably, and a **baseline**
   is recorded before experiment 1 — otherwise N experiments produce N
   opinions.
2. The verification harness exists (e.g. a reproducible load test). The
   harness is the real investment; the loop is the easy part.
3. **QA gate intact**: no experiment "wins" if it breaks tests —
   correctness traded for performance is debt in disguise.

**Dispatch** (orchestrator → Platform Engineer defines metric + baseline +
harness + success criterion; SWE runs the loop):

```
Goal: reduce {metric} of {target} from {baseline} to {target value}.
Budget: up to {N} experiments. Log every experiment to the issue as:
  #k · hypothesis → change → measurement → conclusion (kept/reverted)
Stop when: target reached · budget exhausted · 5 consecutive experiments
without improvement (diminishing returns — stop and report).
Verify each kept change under {realistic conditions}. Tests stay green.
Failed experiments are findings, not noise — they stay in the log.
```

The log lives on the issue (queryable forever); the final report includes
the baseline→result delta and the reverted paths.

**When to activate (cues — no user prompt needed)**: any role can PROPOSE
this pattern when it recognizes the shape; the user approves like any
issue. The cues: (a) grooming reveals an issue whose goal IS a scalar
metric ("make X faster/cheaper/smaller") — the PM proposes the loop
instead of a vague "optimize" spec; (b) a Platform Engineer audit or the
launch checklist produces a measurable finding (score, latency, cost)
above target; (c) a retro/counter shows recurring cost or performance
complaints on the same surface. Every dispatch pattern in this kit
declares its cues — patterns that only activate when the user remembers
them don't compound.

**Validation status**: externally evidenced — the pattern is reported
working in Anthropic's effective-harnesses engineering post (see kit
README § Credits); first-party validation pending. This does NOT gate its
use — the pattern is activated by needing
it, and the first real run is its validation: report the outcome (via the
improvement loop, or a Contributing issue if you are an external adopter)
and this marker drops. See the kit README § honesty rule for the
distinction between this status and "future territory".

## 5 · Diamond dispatch (the general parallel pattern)

Split → explore in parallel → evaluate → merge with ONE synthesis owner.
This is the kit's single general pattern for parallel agent work; the
design pod, parallel independent issues, and multi-angle research
fan-outs are all INSTANCES of it — don't invent a new parallel structure
when the diamond already fits.

- **Activation cue (the Stop Rule — ask it before every parallel
  dispatch)**: *"Where does the work split?"* If you can't name
  independent pieces, it's a chain, not a graph — use a single agent.
  More agents on unsplit work is cost and failure points, not leverage.
- **The merge has one owner**: parallel explorers never decide — a
  designated synthesizer-judge compares against the brief/criteria and
  produces THE result with a "synthesis decisions" section (what came
  from which branch and why). Two owners of the same decision produce
  contradictory specs.
- **Evaluate before merge**: quality/fact-check filters run on each
  branch BEFORE synthesis (the house verify-don't-trust rule applied to
  parallel work).
- Relation to the optimization **loop** (§ 4): the diamond is the
  STRUCTURE of one dispatch (how work splits and rejoins); the loop is
  the DYNAMICS across iterations (repeat until a stop criterion). They
  compose: a loop's each iteration may be a diamond.

**Validation status**: parallel independent issues ✅ validated; the
design pod instance and research fan-outs ⏳ pending first formal run
(see the kit README § Validation ledger).

## 6 · Audit playbook (the backward-looking review discipline)

`AUDIT-PLAYBOOK.md` is the reusable checklist for reviewing a project
"hacia atrás" — finding the gaps that feature work never looked at, in the
assumptions nobody questioned. It is the accumulated audit knowledge of a
real project run, made project-agnostic:

- **12 audit dimensions** (Part A): security · test coverage · robustness ·
  performance · accessibility · UX friction · states & feedback ·
  onboarding · animations · mobile interaction (bottom sheets) · logs/
  events/observability · notifications mapping — each a "look for X"
  checklist distilled from real findings.
- **Backward review** (Part B): a regression pass that confirms
  previously-closed findings are still fixed AND still test-covered (a fix
  without a regression test is a finding waiting to recur), and that the
  "rules for future work" from prior audits are actually being followed.
- **Output contract & cadence** (Part C): every sweep produces a dated
  audit doc + tracked issues (tagged fix-now vs decision) + a focused owner
  notification. Security and coverage run every Sprint Close; UX dimensions
  on a periodic sweep and at each new surface's build time.

The founding discipline: **objective correctness (robustness, a11y
semantics, perf) is fix-now; aesthetics / mechanism-choice / paid-infra is
the owner's decision** — propose, don't impose. And **verify before you
assert** — a finding isn't real until the full data path (including the
caller) has been read.

## Files

- `BUG-template.md` — the bug issue template (install as
  `.github/ISSUE_TEMPLATE/bug.yml` or equivalent in the project's
  tracker).
- `CHANGE-CHECKLIST.md` — the full merge checklist (reference from the
  project's PROCESS.md § mandatory steps).
- `AUDIT-PLAYBOOK.md` — the reusable audit checklist (12 dimensions +
  backward-review pass); run as a periodic sweep and for the
  Sprint-Close security/coverage rituals.

## Sources (reviewed 2026-07, mined with attribution)

- `mattpocock/skills` `diagnosing-bugs` (MIT) — the
  reproduce→minimize→hypothesize→instrument loop informing the bug
  template's repro discipline.
- Trail of Bits `differential-review` (CC BY-SA 4.0) — change-diff review
  framing.
- The ecosystem gap analysis that motivated building (not adopting) this
  module: no dedicated skill/agent found for deprecation impact,
  migration safety, or living debt aging as of 2026-07.
