# ai-native-os — how to start a project with an agent team

Distilled from a real production project run end-to-end on this system
(July 2026): everything learned iterating on way-of-working, processes,
agent roles, loops, rules and triggers, packaged so that starting a NEW
project on any topic is nearly plug-and-play. The documents are
transversal: they serve any project and any user — they name no people.
Throughout the kit, **"the user"** means the person who owns and runs the
project and interacts with it (approves, redirects, unblocks); it is a
role, never an individual.

## Pillar: the AI-native company

Every project started with this kit adopts as its motto the essence of the
YC AI-native company ideas (from YC's public talks and writing on AI-native
companies):

- **Closed loop that learns**: every process captures information, feeds it
  back, and improves over time (retro → LEARNINGS → read before the next
  sprint), instead of decisions that get executed and never measured.
- **Queryable organization**: every important action produces an
  agent-readable artifact (issues, comments, retros, decisions) — nothing
  lives only in the conversation.
- **Software factory**: the human defines WHAT to build and judges the
  result; the agents write the how (spec + acceptance criteria + tests
  before implementing).
- **Transparency by default**: full agent reports go to the tracker, not
  summaries; the Sprint Close is relayed to the user in full.
- **Raising the floor**: a new session (or person) arrives with the
  complete context immediately — MEMORY + PROCESS + LEARNINGS — without
  months of tacit absorption.
- **Maximize tokens, not headcount**: a small team of well-instrumented
  (and measured) agents replaces what used to require a large team.

The operational detail of each idea lives in `PRINCIPLES.md`; the concrete
mapping of where each one already runs, in each project's
`docs/workflows/README.md`.

## How to use it

1. Create the new project's folder (for example `~/dev/<project>/`).
2. Open a Claude Code session there and tell it:
   > Read `BOOTSTRAP.md` from the kit repo (this repo's local path) and
   > start the setup.
3. The session asks ONE batch of questions up front (product, stack,
   environments, languages, budget, permissions) and then executes the full
   setup without interrupting again except on a real blocker.

## What it contains

| File | What it is | For whom |
|---|---|---|
| `BOOTSTRAP.md` | Step-by-step startup manual | The Claude session (LLM) |
| `PRINCIPLES.md` | The distilled principles, with the real incident that originated each one and whether it is portable or context-specific | Both |
| `SPRINTS.md` | Detailed sprint methodology: planning, execution, close, retrospective, and the label taxonomy | Both |
| `GUARDRAILS.md` | Precautions against limits: session/context, spend, and the triggers/counters mechanism | Both |
| `templates/` | Skeletons ready to copy and fill in: AGENTS.md, MEMORY.md, PROCESS.md, LEARNINGS.md, DECISIONS.md, 8 agent roles, design module, database-documentation module, launch-readiness module, security module, delivery-quality module | The session |

## Improvement loop (this repo learns too)

The kit is NOT static. Rule: at every Sprint Close of any project, if the
retro produces a **project-agnostic** learning (about process, not stack),
it is proposed here as a commit — so the next project starts with
everything learned in the previous ones. Context-specific learnings
(hardware, stack, APIs) stay in their project's LEARNINGS.md, marked as
non-portable.

**Two-question rule (every evaluation, always)**: any practice/pattern/
tool under consideration answers TWO questions SEPARATELY — (1) does the
source project need it now? (a project decision; "no" or "later" is
fine); (2) does the KIT need it documented? Default YES with activation
conditions whenever the practice is sound: the kit serves ANY project,
so "our current project doesn't need it" is grounds for a CONDITIONAL
entry (cues + evidence state), never for omission.

Decision history of the kit itself: this repo's `git log`.

## Future territory — NOT yet validated

Honesty rule: this kit distinguishes THREE evidence states, and labels
them: (1) **validated** — practices proven in real projects: the body of
the kit. (2) **Specified, pending first-party validation** — patterns documented
in full whose only missing piece is a real run in OUR projects: usable
TODAY by anyone who needs them — the marker is epistemic honesty, not a
gate; the first real use IS the validation (report the outcome and the
marker drops). When external evidence exists (the pattern is reported
working by a credible source), the marker says so with the citation —
"externally evidenced, first-party validation pending" is a stronger
state than "specified only", and both are usable. (3) **Future territory** — NOT
specified, and building them prematurely has real cost: do not adopt by
default; each has its adoption trigger under the counters meta-rule
(`GUARDRAILS.md` § Triggers):

- **Watchdog / automatic flow reactivation**: an external process that
  detects session interruptions nobody picks up and relaunches. Trigger
  defined in the source project: 2 incidents within a 3-sprint window where
  no live process picks up the interruption and the user has to ask "what
  happened?". At distillation time: 1/2 — not built.
- **Nightly agents / automatic memory synthesis** (dream-cycle style):
  first the proven manual memory ("memory before agent"), then the agent.
  Trigger defined in the source project: 3 occurrences of sources left
  unsynthesized >7 days or explicit "synthesize this" requests. At
  distillation time: 0/3.
- **RAG** (semantic search over the project's memory/documentation): not
  tried in any project. Proposed trigger (define the counter upon
  adoption): new sessions repeatedly failing to find existing context by
  reading MEMORY/LEARNINGS/issues directly.
- **Computer-use**: agents operating UIs without an API. Not tried.
  Proposed trigger: a recurring workflow that can only be executed through
  a UI and that blocks the team N times (define N when creating the
  counter).

Note: **QA is not on this list** — it is a validated, central practice of
the system (independent verification by the Tester, QA per stage of the
cycle, oncall gates against the real environment): see `SPRINTS.md` § QA
per stage.

When any of these gets validated with data in a real project, it is
promoted from future territory into the body of the kit — never before.

### Validation ledger (evidence state per piece — kept honest here)

| Piece | State |
|---|---|
| Core cycle, PM/SWE/Tester/On-Call roles, memory files, sprint rituals, kit-sync protocol | ✅ Validated (2+ real sprints) |
| Database-docs module | ✅ Validated (full real schema documented) |
| Security Engineer gates | ✅ Validated (real sensitive issues gated) |
| Designer — audit mode | ✅ Validated (real audits shipped fixes) |
| Designer — spec mode | ✅ Validated (real briefs consumed by grooming) |
| **Design pod** | ⏳ Specified, first-party validation pending — activation was never gated on it |
| **Genesis mode** (design catalog flow) | ⏳ Specified, pending — every real project so far had a fixed system |
| Data Architect role | ⏳ Specified (2026-07), first dispatch pending |
| Platform Engineer role / launch gate ritual | ⏳ Specified (2026-07), first launch pending |
| Security module docs (threat model, PII, controls) | ⏳ Instantiated in a real project; first full cycle under the new rules pending |
| Bug template / change checklist / carry-over ledger | ⏳ Instantiated; first real sprint under them pending |
| **Optimization loop** | ⏳ Externally evidenced (Anthropic's effective-harnesses engineering post reports the pattern working), first-party validation pending |
| CI/CD chapter (conditional) | ⏳ Specified with adoption cues; first-party adoption pending (a source project schedules it for a later phase) |
| API-contract docs (conditional) | ⏳ Specified; no source project has external API consumers yet |
| Diamond dispatch (general pattern) | Instances: parallel independent issues ✅ validated · design pod and research fan-outs ⏳ pending first formal run |
| Birth contract (role/pod/workflow creation) | ⏳ Specified; applies to the next role created |

⏳ never means blocked — it means "when you run it, you are the evidence:
report back and the row flips".

## Origin

Source project: a private production project built end-to-end with this
system — 3 sprints closed, 9 issues shipped, 2 consecutive closes without
carry-over at the time of distillation. Its `docs/PROCESS.md`,
`docs/LEARNINGS.md`, `docs/DECISIONS.md` and `docs/retros/` are the living,
complete example of this system working; the project stays private — the
lessons live here, anonymized. Conceptual references: YC's AI-native
company ideas (see § Pillar).

## Credits & prior art

- [designer-skills](https://github.com/julianoczkowski/designer-skills)
  (Apache 2.0) — 8 design philosophies with concrete implementation
  parameters. Evaluated and adapted as a source for the design module
  (`templates/design/README.md`).
- [awesome-design-skills](https://github.com/BrunoSSts/awesome-design-skills)
  (MIT) — catalog of 67 complete design systems in SKILL.md+DESIGN.md
  format, installable via `npx typeui.sh pull <name>`. Evaluated and
  adapted as a source for the design module.
- ["The 37 Pre-Launch Checks"](https://nicoburkart.notion.site/e6e88fff5ddf48a09248e2c8368445d1)
  by Nico Burkart — reviewed in full and adapted as the base of the
  launch-readiness module (`templates/launch/README.md`); its 7 sections
  and 3-priority scheme are his, the processing-reliability section and
  the role/ownership mapping are this kit's.
- Security/quality tooling reviewed for the security and delivery-quality
  modules (2026-07): Anthropic's `security-guidance` plugin and
  `claude-code-security-review`; [trailofbits/skills](https://github.com/trailofbits/skills)
  (CC BY-SA 4.0 — `differential-review` and `insecure-defaults` informed
  checklist items, with attribution); PostHog's `security-audit` skill
  ("confirm exploitability" discipline);
  [mattpocock/skills](https://github.com/mattpocock/skills) (MIT —
  `diagnosing-bugs` informed the bug template); GRC control packs
  (Scytale and community ISO/SOC2 collections) as control-list references.
- A public "Graph Engineering" explainer by techwith.ram (Instagram
  carousel, 2026-07) — reviewed against this system; most concepts were
  already institutionalized here, and its Stop Rule ("where does the work
  split?") plus the generalized diamond shape were adopted with credit
  (`templates/quality/README.md` § 5, PRINCIPLES.md #24).
- Anthropic official documentation referenced throughout:
  the [effort parameter](https://platform.claude.com/docs/en/build-with-claude/effort),
  the [advisor tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool),
  the [memory tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool),
  and [Effective harnesses for long-running agents](https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents).
- YC's public material on AI-native companies, which inspired the § Pillar.

## Contributing

Contributions follow the same honesty rule as the kit itself: only
practices validated in real projects, with the incident/evidence that
motivated them.

**Anonymization rule (non-negotiable)**: learnings promoted from private
projects ALWAYS arrive translated to English and anonymized — identity out,
lesson and numbers in. Nobody commits evidence containing private project
names, personal paths, account identifiers, deployment URLs, or people's
names. When a person must be referenced, they are always "the user" (the
role that owns and interacts with the project) — never a name, in content
or in commit messages.

**History rule (learned the hard way)**: publishing an existing repo means
publishing its FULL git history, not just the final tree. Anonymizing the
files without auditing the history is a slow-motion leak — every
pre-anonymization version stays browsable commit by commit. Before making
any repo public: audit the history for private references, and if they
exist, squash to a clean initial commit (keeping the real history in a
local-only branch). "Validated in a real project run on this system (5 agent
interruptions, zero lost work)" is the right shape; the project's name is
not part of the lesson.
