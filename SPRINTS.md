# SPRINTS — detailed sprint methodology

How a sprint is planned, executed, closed and retrospected in a project
started with this kit. Everything in this document is **[PORTABLE]** unless
marked otherwise: it is validated in a real project run on this system (3
sprints closed, 9 issues shipped, 2 consecutive closes without carry-over).
The principles governing each rule are in `PRINCIPLES.md`; the limits
(session, spend) in `GUARDRAILS.md`.

**What a sprint is**: a GitHub milestone. There is no separate tracker and
no story points — the unit is the groomed issue. Boards/Projects are only
views over the same issues.

---

## 1. Planning

### 1.1 Defining the sprint scope

- **The PM proposes, the user decides.** Before grooming a sprint's
  content, the scope is agreed with the user: which issues go in, which
  candidates stay out and why. (In the source project this became an
  explicit commitment after Sprint 3: "decide the Sprint 4 scope with the
  user BEFORE grooming".)
- **Sequence by real dependencies, not by order of statement.** The key
  question is "what defines what?". *Evidence from the source project: the
  user re-sequenced the plan twice — the gap analysis defined the schema
  (not the other way around), and i18n was better done before adding more
  hardcoded UI.*
- **What goes in / what stays out is documented**: what is left out is
  noted with a rationale ("not included because X"), not just "there was no
  time". Every descope is documented, never silent.

### 1.2 Grooming each issue

The PM takes the raw issue (label `needs grooming`), **investigates the
real code before writing the spec** (never assume names, routes or
structures; risks are confirmed or discarded with evidence), and rewrites
it with:

1. **Explicit scope**, including out-of-scope.
2. **Measurable acceptance criteria**; the non-automatable ones are marked
   `[HUMAN]` (final visual verification, flows requiring the user's
   device).
3. **Test scenarios** (E2E) that the SWE must implement and the Tester
   verify.
4. **Dependencies** ("Depends on #N") — an issue is not started until its
   dependencies close.
5. **External data/content risks**: if a criterion depends on data the team
   does not control (an image from the pipeline, a value from a third
   party), it is marked as an explicit risk in the grooming — it is not
   discovered at verification time. *Incident in the source project: an AC
   assumed a real photo existed in a records inheritance chain and it
   didn't; it was only discovered when verifying against real data.*
6. **S/M/L cost size** (source-project reference, calibrate with your own
   data: S <100k tokens, M 100–250k, L >250k). If it estimates L and the
   remaining budget is doubtful, the PM splits it into S/M sub-issues
   **before** dispatching, documenting the change (see `GUARDRAILS.md` §
   Spend).
7. **Product questions that define architecture go in the FIRST grooming
   pass** — identify the decisions that change the shape of the solution
   (SEO/URLs in any issue touching routes, data model in any issue touching
   schema) and ask them to the user along with the other open questions. A
   second pass caused by a late question is a poor handoff and is recorded
   in the retro. *Incident in the source project: the multi-language SEO
   question arrived after the first pass → 82k tokens of re-grooming.*

When done, the PM removes `needs grooming` and adds type, area and priority
labels (§ 6).

---

## 2. Execution

### 2.1 The per-issue cycle

```
PM groom → SWE builds → Tester verifies → PM accepts → local merge →
infra/migrations BEFORE the code → push + env sync → oncall
```

Every issue goes through ALL stages — never commit directly "because it's a
simple change". In detail:

1. **SWE** implements in an isolated worktree (never the main checkout):
   code + unit tests + E2E for the issue's scenarios. Runs the FULL suite
   locally in green. Large issues (>~3 files or schema): sub-steps +
   `.tmp/progress-{issue}.md` updated per sub-step (see `GUARDRAILS.md`).
   **Does NOT commit** until approval.
2. **Tester** verifies independently: runs the whole suite themselves (does
   not read the SWE's results), manually verifies at least one key scenario
   outside the author's tests (the author's tests share the author's
   assumptions), and validates every criterion with concrete evidence
   (command + result). PASS/FAIL verdict on the issue.
3. **PM acceptance review** from the end user's perspective: flow, copy,
   empty states, consistency with the design system. It does not repeat the
   Tester's technical work.
4. **Local merge, no PRs**: the orchestrator commits in the worktree and
   merges to local `main` with a merge commit; the commit carries
   `Closes #N`.
5. **Infra before code**: migrations/infra changes are applied to the cloud
   BEFORE pushing the code to origin — the deploy must never run code that
   expects columns the DB does not have yet. (The migration is applied from
   already-merged `main`, not from the worktree — a [CONTEXTUAL] Supabase
   trap since it reads the cwd, but the ordering is portable.)
6. **Push + environment sync** (e.g. `git push origin main && git push
   origin main:uat`), clean up the worktree.
7. **Oncall** verifies the real deploy: READY status per environment +
   hitting the key routes live — **not just "build OK"**; a green build
   with the app returning 500 is a failure. On an error, it distinguishes
   regression vs pre-existing and assesses **severity by real user
   impact**, not by status code.

### 2.2 Parallelism and blockers

- **Maximum 2 independent issues at a time.** When dispatching a batch,
  leave "take the next two" queued — the pipeline does not stop while there
  is groomed, unblocked backlog.
- **A blocker on the user (label `human`) only stops ITS issue.** The team
  continues with the rest of the sprint; if the sprint runs out, groomed
  work from the next one is pulled forward. The user's pending items are
  presented in a numbered batch with a default recommendation (Mission
  Control), and the source of truth is the label on the issue, not a
  parallel list.
- Issues with `[HUMAN]` criteria approved by agents: they ship, get the
  `human` label, a comment states what remains to verify, and they stay
  open for the user to close — without blocking the team.

### 2.3 QA at every stage (non-negotiable)

Quality is not a stage, it is three independent verifications:

| Stage | Who | What it guarantees |
|---|---|---|
| Unit + E2E tests | SWE (writes AND runs) | The change does what the spec asks, without breaking the suite |
| Independent verification | Tester (runs everything themselves + one manual check) | The SWE's report is not self-validating; the author's assumptions are challenged |
| Real-environment verification | Oncall (live routes of the deploy) | What shipped works with real data and infra — not just "build OK" |

*Evidence from the source project of why the redundancy pays: the Tester
verifying independently uncovered that a "flaky" test was resource
contention (not a bug), and detected a stale server serving old code that
would have produced a false negative.*

---

## 3. Review / Close (Sprint Close)

- **When**: when all the milestone's issues reach a terminal state (closed
  or explicit carry-over), or when the user asks for it.
- **Who**: the PM (natural extension of its bookend role), with real data
  from the tracker (`gh issue list --milestone ... --state all`).
- **Report format**:
  - **Shipped** (per environment) — what ended up visible/working and
    where.
  - **Not shipped / descoped** — why, with a rationale.
  - **Carry-over** — the exact state it was left in (groomed but not
    implemented / implemented but not tested / tested but not accepted) and
    what remains.
  - **New backlog discovered** — where each item came from and suggested
    priority.
  - **Recommendation for the next sprint** — with the dependencies that got
    unblocked and the risks worth resolving early.
  - **5-question retrospective** (§ 4).
  - **Updated trigger counters table** (§ 3 of `GUARDRAILS.md`) — the PM
    updates it at EVERY close; it is an automatic check, it does not depend
    on anyone remembering.
- **Full relay to the user**: the orchestrator ALWAYS relays the entire
  report in the conversation — leaving it as a GitHub comment is not
  enough. It is the moment when the user decides whether to reprioritize
  before giving the "go" to the next sprint.

---

## 4. Retrospective — the 5 fixed questions

The PM facilitates it wearing the Scrum Master hat: it actively asks the
SWE and the Tester the "why" of each weak point — it does not settle for
the surface state nor self-evaluate alone.

**1. Overall balance — what did we accomplish, what not, and why?**
- Sprint objectives and which were completed.
- What worked so well it must be repeated (practices, collaboration,
  tools — with the concrete case, not generic).
- What was left unfinished and why, explicitly distinguishing: technical
  surprise / external dependency / overestimation / mid-sprint priority
  change / **a correctly discovered scope boundary — which is NOT a
  failure**, it is the process working. *Example from the source project:
  an AC depended on a curated content item that did not exist; it was
  discovered during verification against real data and reclassified
  instead of forcing a false close.*

**2. Carry-over analysis**
- Is the pending work still the user's top priority, or did it change?
- Were the tasks too big? What should change in the slicing?
- Were there interruptions (urgent bugs, support) that diverted the plan?

**3. Processes and workflows**
- Did the work flow through groom→SWE→Tester→PM→merge→push→oncall?
- Bottlenecks (waits, external dependencies, slow tests)?
- Is the Definition of Done still realistic or is it generating hidden
  work?

**4. Future commitments**
- **Concrete and measurable** actions for the next sprint, not vague
  intentions ("zero second grooming passes for questions that could have
  been asked in the first" yes; "groom better" no).
- Does the way work is sized need adjusting?

**5. Cost and efficiency**
- Real table of tokens/duration per agent for the sprint (the data already
  comes in the Task notifications — you just have to write it down, see
  `GUARDRAILS.md`).
- The most expensive issue, classified — never accept the raw number
  without interpreting it — into one of three buckets:
  - **Expected**: proportional to the real scope (a refactor touching 8
    files). Not a finding.
  - **Preventable/rework**: inflated by something avoidable — relaunching
    while re-reading already-processed context, re-verifying what was
    already covered, redoing work due to an ambiguous spec.
  - **Poor handoff**: a subtype of the previous one — the cost came from an
    agent (or the user) not giving the next one enough context. It points
    to a process fix (better spec/prompt), not to "accepting it".
- Which interaction pattern with the user worked well or generated
  friction/rework.

**Where each output of the close lands:**

| Output | Destination | Lifespan |
|---|---|---|
| Full retro narrative | `docs/retros/YYYY-MM-DD-sprint-N.md` | Evergreen, history |
| Learning that changes a concrete behavior | `docs/LEARNINGS.md` | Append-only, never deleted (generic retro-theater does not go in) |
| Durable decision approved by the user | `docs/DECISIONS.md` | One line (ADR-lite) |
| **Project-agnostic** learning (process, not stack) | Proposed commit to the kit repo | The next project starts with it |
| Updated working state | `MEMORY.md` | Pruned (≤80 lines) |

Before starting a new sprint, the orchestrator must have read
`docs/LEARNINGS.md` — so as not to repeat mistakes from previous sprints.

---

## 5. Dead ends and bugs discovered along the way

What happens when an issue's work reveals a problem outside its scope (a
bug in another module, tech debt, a design dead end):

- **Hard rule: file a new issue AT THE MOMENT**, with the `needs grooming`
  label and a note of where it came from — before moving to the next
  topic, not "to be created later" and not silently fixing out of scope.
  *Incident in the source project: a mockup approved in conversation was
  never filed; the user caught it asking "didn't this become an issue?" —
  the rule existed and was not applied, which is why the trigger is
  temporal: AT THE MOMENT.*
- The same applies to what the user approves in conversation (mockups,
  design decisions): an issue on the spot.
- **Bounded exception**: small bugs WITHIN the same scope that the SWE
  finds while implementing — they fix them in the same pass and **report
  them explicitly** in their comment (cheaper than a full rejection cycle).
  Never silently: if it is not in the report, it did not happen. *Evidence
  from the source project: the SWE fixed and reported 3 unspecified bugs;
  they would have come out later as Tester rejections.*
- The Sprint Close lists all newly discovered backlog with its origin
  (§ 3) — and Mission Control shows "detected gaps" (approved without an
  issue) so the process catches them before the user does.

---

## 6. GitHub label taxonomy

Created in the bootstrap (Phase 2). Four dimensions; an issue normally
carries one of each:

### Type

| Label | Use |
|---|---|
| `bug` | Incorrect behavior of something that already exists |
| `feature` | New capability |
| `enhancement` | Improvement of something existing (UX, performance, copy) |
| `refactor` | Internal change with no new visible behavior |
| `docs` | Documentation |
| `chore` | Maintenance (deps, config, tooling) |

### Priority

| Label | Meaning |
|---|---|
| `P0` | Must-have — blocks the sprint/MVP objective; handled before everything else |
| `P1` | Important — **prioritized in the next available sprint** (does not wait indefinitely in the backlog) |
| `P2` | Nice to have — goes in only if there is capacity, may live in the backlog |

### Process

| Label | Meaning |
|---|---|
| `needs grooming` | Raw issue, not yet a spec — agents do NOT pick it up |
| `human` | Blocked on the user: pending decision or `[HUMAN]` manual verification — source of truth for "blocked-on-human" |

### Area — [CONTEXTUAL: adapt per project]

Examples validated in the source project: `frontend`, `api`, `database`,
`pipeline`, `infra`, `integration`. Each project defines its own in the
bootstrap according to its architecture — what is portable is the dimension
(every issue says which part of the system it touches), not the names.
