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

## Cost and models

18. **[PORTABLE] S/M/L estimated-cost size at grooming** (calibrate with
    the project's own real data); an L with a doubtful budget is split
    BEFORE dispatching, documenting the descope.
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
    Without data, every efficiency discussion is theater.

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
