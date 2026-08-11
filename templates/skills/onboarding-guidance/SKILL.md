---
name: onboarding-guidance
description: >
  Workflow-first user guidance (onboarding, feature discovery, support
  tours) under the kit's onboarding module. USE when: grooming any
  user-facing feature ("does this deserve highlighting?"); preparing the
  launch checklist's first-run item; a support/confusion signal or a
  funnel drop suggests users are lost; the user asks for tours,
  walkthroughs, onboarding, driver.js or product guidance; or the
  Designer is producing/updating the guidance-moments map. Owned by the
  DESIGNER role — this skill is its operating knowledge, not a new role.
---

# Onboarding & guidance (the Designer's operating knowledge)

The full process lives in the kit's `templates/onboarding/README.md` —
this skill is the executable summary + the judgment that doesn't fit a
table. Reference, don't restate: map → ladder → guardrails → events.

## Activation is the USER's call — hard gate

The cues (real users + recurring confusion; the launch first-run item)
produce a **PROPOSAL to the user**: which workflow, which mechanism, what
evidence, estimated size. **The user decides the first candidate and the
timing — always `[HUMAN]`.** No tour ships because a cue fired; cues
open the conversation, the user closes it.

## Operating procedure

1. **Map before mechanism**: no guidance work without its row in
   `docs/design/guidance-map.md` (workflow × moment × evidence ×
   mechanism × copy owner). A tour without a mapped workflow is
   decoration — decline and map first.
2. **Ladder discipline**: always propose the LOWEST rung that works
   (self-evident > empty-state CTA > single highlight > tour > help
   overlay). Climbing needs evidence, not enthusiasm.
3. **Guardrails are non-negotiable** (module § hard UX guardrails): ≤5
   steps, always skippable, never blocks, once-then-help, never
   mid-task, product tone, reduced-motion/keyboard/focus.
4. **Events or it didn't happen**: every guidance surface emits
   started/step/completed/skipped. High skip rate → demote the rung,
   never make the tour more insistent.
5. **Implementation goes through the project's shared wrapper**
   (driver.js behind one module; the design system styles it). The SWE
   builds; you spec.

## Judgment notes (the part tables can't hold)

- The best outcome of a guidance review is often DELETING guidance: if
  users stopped skipping because they stopped needing it, the feature
  matured — retire the tour.
- New-feature announcements decay: what deserved a highlight in week one
  is noise in week six. Every announcement carries its own retirement
  condition when specced.
- Support tours are a smell worth reading: a workflow that needs a
  re-invocable walkthrough is telling you where the redesign backlog is.
  File the observation as product input, not just the tour.

## Learning loop (this skill maintains itself)

A guidance launch that teaches something — a rung that worked
unexpectedly, a skip-rate pattern, a copy approach, a driver.js trap —
updates this skill AND the module in the same cycle. Skip-rate data from
real projects is the evidence that will eventually turn the module's
ladder from specified into validated.

## Install (reference, don't copy)

Kit machine: symlink from the user-level skills dir. External adopters:
copy, refresh on kit-sync review. (Birth contract for kit skills.)
