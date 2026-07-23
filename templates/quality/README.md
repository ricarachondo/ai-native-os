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

## Files

- `BUG-template.md` — the bug issue template (install as
  `.github/ISSUE_TEMPLATE/bug.yml` or equivalent in the project's
  tracker).
- `CHANGE-CHECKLIST.md` — the full merge checklist (reference from the
  project's PROCESS.md § mandatory steps).

## Sources (reviewed 2026-07, mined with attribution)

- `mattpocock/skills` `diagnosing-bugs` (MIT) — the
  reproduce→minimize→hypothesize→instrument loop informing the bug
  template's repro discipline.
- Trail of Bits `differential-review` (CC BY-SA 4.0) — change-diff review
  framing.
- The ecosystem gap analysis that motivated building (not adopting) this
  module: no dedicated skill/agent found for deprecation impact,
  migration safety, or living debt aging as of 2026-07.
