# Onboarding & product tours module — guiding users, workflow-first

> For guiding real users through a product: first-run, new-feature
> discovery, and support moments. The tool (driver.js) is the easy part;
> this module exists because the PROCESS is what scales — which workflows
> get guidance, which mechanism each one deserves, and how you know it
> worked. A tour without an identified workflow is decoration.
> Complements (never replaces) the audit playbook's A8 rule: empty-states
> double as onboarding, and every new feature ships its empty-state CTA.

## The workflow-first process (before any tour exists)

The **Designer, in spec mode**, produces the project's **guidance-moments
map** (`docs/design/guidance-map.md`), and it is the precondition for any
tour work:

| Column | Meaning |
|---|---|
| Workflow | A real user journey ("create your first X", "find and act on Y") |
| Moment | first-run · new-feature announcement · support/confusion point |
| Evidence | Why this moment needs guidance (funnel drop, support signal, novelty) — "it seems useful" is not evidence after launch |
| Mechanism | The LOWEST rung of the ladder that works (below) |
| Copy owner | Who writes it, in the product's tone and language |

New features add their row AT GROOMING: the PM's question for every
user-facing feature is **"does this deserve to be highlighted to existing
users?"** — if yes, the guidance item ships in the SAME issue, not later.

## The mechanism ladder (always pick the lowest rung that works)

1. **Self-evident design** — the best guidance is not needing any.
2. **Empty-state with CTA** — the existing A8 rule; covers most first-run.
3. **Single highlight + popover** — one element, one message (a new
   button, a moved control). The workhorse for feature announcements.
4. **Multi-step tour** — only when a WORKFLOW (not a screen) needs
   walking: first-run of a genuinely multi-step surface.
5. **Re-invocable support overlay** — the same tours, reachable from a
   help entry point, for the support use case ("show me how again").

Climbing a rung requires the map's Evidence column to justify it.

## Hard UX guardrails (non-negotiable)

- **Max 5 steps** per tour — longer means the workflow needs redesign,
  not narration.
- **Always skippable**, from step one, without penalty.
- **Never blocks the real action** — guidance overlays, it does not gate.
- **Shown ONCE** (persisted per user), then re-invocable from help. An
  unskippable repeat tour is how products teach users to hate guidance.
- **Never interrupts a task in progress** — first-run fires on arrival,
  feature announcements on the next natural visit, not mid-flow.
- **Copy in the product's tone and language**, written by the copy owner
  in the map — not developer strings.
- **Accessibility is not a variant**: animated vs non-animated maps to
  `prefers-reduced-motion` (a user setting, not a style choice); keyboard
  navigation and focus management on; on small screens the popover
  position respects the thumb and the keyboard (the mobile
  bottom-sheet-first principle applies to guidance surfaces too).

## Instrumentation (mandatory — the module's data contract)

Every guidance surface emits: `tour_started` · `tour_step_viewed` (with
step id) · `tour_completed` · `tour_skipped` (with step where). Wired to
the analytics module's event taxonomy. Without this, a tour cannot prove
it helps — and **a high skip rate is the signal to remove or demote a
rung, not to make the tour more insistent**. (Principle 26: a feature
without its variables logged is unevaluable.)

## The tool: driver.js (buy, don't build)

[driver.js](https://github.com/kamranahmedse/driver.js) (driverjs.com) —
MIT, ~5kB gzipped, zero dependencies, TypeScript, actively maintained,
26k+ stars. Covers the whole ladder above rung 2: highlights, popovers
with positioning, multi-step tours, animation toggle, keyboard support.
House rules for adopting it:

- **One shared wrapper per project** (a single module owning theme,
  copy source, persistence of "seen", and event emission) — feature code
  calls the wrapper, never the library directly. The project's design
  system styles it; the library's default look never ships.
- Review before installing, like any dependency (house rule).
- The demos on driverjs.com (animated tour, tour without animation,
  highlight with popover, popover positioning) are the reference catalog
  for what each rung looks like.

## Ownership

| Piece | Owner |
|---|---|
| Guidance-moments map + copy | Designer (spec mode deliverable when the product has/nears real users) |
| "Deserves highlighting?" at grooming | PM (per user-facing feature) |
| Wrapper + implementation | SWE |
| Event taxonomy + skip-rate visibility | Platform Engineer (analytics envelope) |
| A11y verification (reduced-motion, keyboard, focus) | Designer audit checklist |

## Activation: cues propose, the USER decides — hard `[HUMAN]` gate

The cues below produce a PROPOSAL to the user (workflow, mechanism,
evidence, estimated size) — **never an activation. The user picks the
first candidate and the timing, always.** Roles do not ship guidance
because a cue fired.

- The launch checklist's first-run item (guidance decided before going
  public), OR
- Real users + a recurring confusion signal: support questions about the
  same flow, or an analytics funnel drop at a step guidance could fix.

Until then, the only standing obligation is the existing A8 rule
(empty-states + new-feature CTAs).

## Ownership: the Designer, via a kit skill — deliberately NOT a new role

Question answered (stated explicitly, per the house lesson): "does
episodic guidance work in every project justify a standing role?" — No:
guidance IS a UX discipline; the Designer already owns moments, copy and
accessibility, and a dedicated onboarding role would duplicate it the
same way a 'backend engineer' would have duplicated the SWE. The durable
knowledge lives in the kit skill
`templates/skills/onboarding-guidance/SKILL.md` (the Designer's operating
knowledge: procedure, judgment notes, learning loop). Trigger to revisit
(standard counters): guidance work in 3+ issues per sprint across 2+
projects sustained — then a dedicated role earns its evaluation.
