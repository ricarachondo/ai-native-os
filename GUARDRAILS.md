# GUARDRAILS — precautions against limits

Limits are external conditions that will occur regularly — session and
context-window limits, plan spend limits (5-hour window, week, month —
depending on the current plan). They are not avoidable, but their impact is
preventable. This document gathers the precautions validated in a real
project run on this system (which absorbed 5 agent interruptions from 3
distinct causes without turning any of them into lost work). Everything is
**[PORTABLE]** unless marked otherwise.

---

## 1. Session and context-window limits

### 1.1 BEFORE — prevention (checkpoint discipline)

**Mother rule: everything that must survive an interruption lives in files,
never only in the chat.** The criterion for knowing when a checkpoint is
due is not "how many messages have gone by" but **"is there anything in the
chat that is not in a file?"**.

- **MEMORY.md** (working state, ≤80 lines, gets pruned): updated + commit +
  push at every phase/issue close, when the user says "checkpoint", and
  before a context compaction. Half-done work is committed on a
  `wip/<topic>` branch with an explicit TODO in MEMORY.md.
- **Progress files** (`.tmp/progress-{issue}.md`, gitignored): mandatory
  for any SWE issue touching more than ~3 files or a schema. The SWE
  updates it AFTER each sub-step: what is done and verified, what remains,
  what decisions were made and why — written as if the next reader were
  themselves without memory. *Validated with a real interruption: the
  relaunched SWE confirmed sub-step 1 done and resumed exactly where it
  left off, without rework.*
- **Issues and comments**: each agent's full reports go to the issue
  (queryable forever); what is approved in conversation is filed as an
  issue AT THE MOMENT. The chat is a buffer, not a record.
- **Grooming in sub-steps**: large issues are groomed as verifiable
  sub-steps — it bounds the damage of an interruption to one sub-step, not
  the whole issue.

### 1.2 DURING — truncated-report protocol

When an agent reports truncated, empty, or with a limit warning:

1. **Verify, don't trust**: a cut-off report ≠ bad work NOR good work.
   Order: read `.tmp/progress-{issue}.md` if it exists (cheap) → verify
   against the real repo (`git status`, `git diff --stat`, read the new
   code, run the tests yourself) → only then decide. *Evidence: a
   167-tool-call refactor reported almost empty and was complete and
   correct — the verification confirmed it, not the report.*
2. **Relaunch referencing the VERIFIED state** ("this is already done and
   confirmed, this is missing") — never re-explain the issue from scratch
   nor assume a restart is needed.
3. **Maximum 2 relaunches of the same role on the same issue**; at the
   third interruption, stop and escalate to the user with the verified
   state, instead of burning tokens in a cycle that does not converge.
4. **Inline verification by the orchestrator when what's missing is small**
   (e.g.: only the verdict is missing and the work is already done): the
   orchestrator verifies directly instead of relaunching a full role that
   would re-read everything. *Real measured saving: ~20k inline vs ~130k
   for a full Tester — ~110k tokens in one case.* A full relaunch is
   reserved for when the work itself is incomplete.
5. **Kill the dead agent's orphaned processes** (dev servers, watchers)
   BEFORE verifying or relaunching — **verifying ownership first** (process
   cwd via `ps`/`lsof`): only processes of already-dead agents are killed,
   never the server of a live agent mid-test. Killing them loses nothing
   (the state lives in worktree files; the process relaunches identically);
   leaving them alive does cause false test results (they serve stale
   code).

### 1.3 Handoff protocol to a new session

For a fresh session (a new orchestrator, or the same one after an
interruption) to resume without loss, `MEMORY.md` must ALWAYS contain:

- **Current state**: closed sprints/phases compressed to one line; the
  in-progress work in detail; date of the last checkpoint.
- **Marked blockers** (🔴 or equivalent): what is expected from the user,
  issue by issue (the source of truth remains the `human` label).
- **Exact startup commands** (copy-paste): bring up the stack, run tests,
  query the tracker.
- **Known traps**: what a new session would re-discover expensively (they
  accumulate; they are pruned only when resolved at the root).
- **Next steps in order**.

**Hard rule for the new session**: it NEVER starts new work without (a)
reading `MEMORY.md` (+ `AGENTS.md`, and `docs/PROCESS.md`/
`docs/LEARNINGS.md` if it is going to groom/implement/test/ship) and (b)
**verifying the real state of the repo** (`git status`, recent `git log`,
live worktrees) — the memory says where things left off; the repo says what
is true. If they differ, the repo wins and the memory is corrected.

**Enriched checkpoint elements (2026-07-09, taken from the community and
validated against our experience)**:
- **Failed approaches**: besides the state and the pending work, record
  what was tried and did NOT work (with the error) — it prevents a new or
  post-compaction session from re-investigating already-discarded dead
  ends.
- **Proactive threshold**: if context usage reaches ~85%, do a full
  checkpoint immediately — do not wait for automatic compaction to fire.
- **Briefing, not log**: the checkpoint is an actionable summary with a
  hard size cap (≤80 lines in MEMORY.md), never a transcript.
- **Environment note**: in the desktop app, a full context does NOT kill
  the session — it compacts automatically and continues; disciplined
  checkpointing makes that compaction lose the minimum. A manual new
  session is a fidelity optimization, not a necessity. (Native session
  auto-spawn was requested from Anthropic and closed as not-planned —
  issue anthropics/claude-code#25695.)

**Why MEMORY.md and not a separate HANDOFF.md (2026-07-09)**: the community
pattern of a per-session `HANDOFF.md` solves the same problem, but it is
designed for sessions with a deliberate ending (CLI + `/clear`). Here
interruptions are unplanned → the checkpoint must be continuous, not a
farewell. Also: (a) a single source of live state — every element of the
HANDOFF format already has a home (goal/state → MEMORY §State; failures →
§Failed approaches; decisions → DECISIONS.md; next step → §Next steps;
per-issue tactics → progress files); (b) git gives its historical file and
INDEX for free (`git log -p MEMORY.md`). **Rule: a single live orchestrator
per project.** Trigger: if PARALLEL orchestrators over the same project are
ever needed, then adopt per-session handoff files + an append-only index
(the community's multi-session pattern), because two sessions writing a
single MEMORY.md would step on each other.

**How NOT to do the handoff (tested in practice, 2026-07-08)**: using
`scheduled-tasks`/cron to fire the fresh session works technically (the
resulting session is a full, addressable session, verified via the sessions
API), but the product categorizes it as a "Routine" — separate from the
user's normal session list, buried under an extra menu. **Validated
recommendation**: for a handoff the user must find and continue easily, use
a normal "+ New session" (same project/folder) with a prompt like "let's
continue" — it achieves the same continuity (it reads `MEMORY.md`) without
falling outside the main list. Reserve `scheduled-tasks` for automations
that genuinely must run without the user opening them (reminders, periodic
checks).

The bootstrap validation already requires this by design: "a new session
can resume by reading only MEMORY.md + AGENTS.md" is a done criterion.

---

## 2. Spend limits (5-hour window / week / month, depending on plan)

The token budget is the team's real capacity — it is managed as such, with
data and not intuition:

- **S/M/L cost estimate at grooming** for every issue (source-project
  reference: S <100k, M 100–250k, L >250k tokens — calibrate with your own
  project's data and compare estimated vs actual at every retro).
- **Split L before dispatching**: if an issue estimates L and the remaining
  budget (session/month) is doubtful, the PM splits it into S/M sub-issues
  BEFORE dispatching — it is slicing by capacity, with capacity = tokens.
- **Re-prioritize toward the smaller thing, documenting the descope**: when
  the budget is doubtful, a smaller build that fits is preferred, and the
  cut is documented in the backlog — descope documented, never silent.
- **Record tokens/duration per agent from day 1**: the Task notifications
  already carry `subagent_tokens`/`duration_ms` — you just have to write
  them down. It feeds retro question 5 (expected / preventable-rework /
  poor-handoff buckets) and the size calibration. Without this data, every
  efficiency discussion is theater.
- When an interruption due to a spend limit happens anyway, the § 1.2
  protocol applies — in particular the inline verification (point 4), which
  was born exactly from a monthly-spend-limit interruption.

Note on models: downgrading the model is NOT the first savings lever — see
`PRINCIPLES.md` § 19 (evolving chapter): saving badly costs more due to
rework, and any assignment change requires a pilot with data and an intact
QA gate.

### The first lever is effort, not the model (2026-07-15, validated in the source project)

The `effort` parameter (`low`/`medium`/`high`/`xhigh`/`max`) of the SAME
model controls total spend — text, thinking, and number of tool calls —
while keeping the quality tier better than downgrading the model
([official doc](https://platform.claude.com/docs/en/build-with-claude/effort)).
A validated pattern, with its safeguards:

- **Staged rollout, never big-bang**: start with ONE mechanical role (e.g.
  oncall at `low`), measure in the retro, extend only with data. **Real
  risk**: low effort reduces tool calls, and the QA gates depend on long
  sequences (full suite, criterion by criterion) — a verifier at low effort
  without safeguards may verify less than it reports.
- **Low effort ALWAYS with an explicit checklist in the dispatch**
  (mitigation from the official doc) + **escalation rule**: on any anomaly,
  the agent reports and stops — the diagnosis is re-dispatched at high
  effort.
- **Size budget in the dispatch** (task budgets): tell the agent the
  issue's size and its indicative token budget — the grooming estimate
  becomes the agent's self-regulation. A signal, not a cap.
- **Mid-task advisory** (the full behavior of the [advisor tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool)
  without its API — the pause→message→continue mechanism of agent
  harnesses allows it with context intact). Two paths:
  (a) **Proactive — the agent asks**: in long tasks, the agent may request
  strategic guidance (a doubt expensive to revert, an issue structurally
  different from what was groomed, a budget about to be exceeded) by ending
  its turn with an `ADVISORY REQUEST` block: the situation in ≤5 lines + a
  specific question + ITS recommendation — never blank. Max 2 per issue
  (equivalent to `max_uses`); a third doubt = a poorly groomed issue,
  escalate. (b) **Reactive**: before the second relaunch of a stuck role,
  the orchestrator/PM reads its progress and produces a short correction
  plan; the SAME agent continues. In both paths the advisor ONLY advises,
  never executes (like the API's advisor, which runs without tools) —
  accountability stays with the agent. The native API version (cheap
  executor + smart advisor) is a trigger-gated candidate if the harness
  exposes it and the project bills per token.

External validation of this document's memory pattern: the
[official memory tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool)
and [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents)
recommend exactly this architecture — persistent files + an
"assume interruption" protocol + multi-session progress recording +
compaction combined with memory + periodic pruning. Refinement adopted from
there: **just-in-time reading** — large institutional files (learnings)
carry a thematic index at the top and agents read only their sections, not
the whole file.

---

## 3. Triggers and counters — the general mechanism

The same discipline that governs the limits governs all process evolution.
**Meta-rule**: every new rule or piece of infrastructure is defined with:

1. An **objective counter** (what is measured, without ambiguity),
2. a **numeric threshold**, and
3. a **trigger tied to an existing ritual** (the Sprint Close: the PM
   updates the counters table at EVERY close — an automatic check, it does
   not depend on anyone remembering).

Never "revisit later" without a number. Crossing the threshold fires the
**proposal**, not the construction — building always requires the user's
ok. First operate with the current rules; only evaluate changing them when
a counter crosses its threshold.

*Evidence that it works: in the source project, a finding repeated across 3
sprints (Playwright contention) was automatically promoted from
recommendation to active config — nobody had to remember; the repeated
pattern fired the fix. And conversely: the watchdog, the efficiency role
and the nightly agent were NOT built because their counters did not cross
the threshold.*

The typical trigger candidates (watchdog, nightly agents, RAG,
computer-use) are listed with their status in `README.md` § Future
territory — none validated yet.
