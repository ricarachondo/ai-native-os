# Design module — plug and play

> Self-contained module for adding design capability to any project's agent
> team. Origin: a joint evaluation (2026-07-14) of
> [designer-skills](https://github.com/julianoczkowski/designer-skills) (8
> process skills, Apache 2.0), [awesome-design-skills](https://github.com/BrunoSSts/awesome-design-skills)
> (catalog of 67 design systems, MIT), and the industry model of UX/UI
> agent teams — validated first in a real project run on this system.

## Step 0 — Fork (bootstrap question)

**Does the project have a defined visual identity / design system?**

- **YES → fixed-system mode**: the existing system is a CONSTRAINT, not a
  starting point. It is documented as a project skill (format § Design
  system skill) and all design agents obey it. Aesthetic philosophies and
  token generators are NOT used — the identity is already decided. (This
  was the source project's case.)
- **NO → genesis mode** (specified, first-party validation pending — every
  real project so far had a fixed system; usable today): the full creation
  flow is run (§ Flow), including
  choosing an aesthetic direction from the catalog (§ Catalog) and token
  generation. When finished, the project switches to fixed-system mode
  forever — the system is created once, then obeyed.

## The Designer role (2 modes)

Generic template in `../agents/designer.md`. Reports to the PM; never
implements product code.

1. **Audit mode** (existing surfaces): triaged findings (Must fix / Should
   fix / Could improve / What works well) with captures and class diffs,
   against the project's design system. Checklist: hierarchy, tokens,
   complete states (default/hover/focus/active/disabled +
   empty/loading/error), operational typography (the font loads, line
   lengths), responsive/mobile, accessibility (AA, tap targets, focus),
   hardcoded values where a token exists.
2. **Spec mode** (new surfaces, BEFORE the PM's grooming):
   - **Grill-me**: interrogate every unresolved design decision; if the
     answer is in the code/documents, explore instead of asking; every
     question to the human carries its own recommendation.
   - **Design brief** (the project's `DESIGN_BRIEF-template.md`):
     problem → solution as an experience → user/JTBD → tone → design
     system application (reuse/extend/new pattern as an open question) →
     constraints → out of scope → default decisions → open questions.
   - **Information architecture** (only if the surface has its own
     navigation/flow): view map with URLs, hierarchy per view, flows WITH
     error paths, what grows vs what is fixed.
   - **State detection**: always check `docs/design/<feature>/` first and
     resume what exists, never recreate.

## Design pod (parallel exploration on demand)

For large surfaces (size M+ with no existing pattern to copy), the
orchestrator dispatches 2-3 independent parallel explorations of the same
feature from different angles (e.g. radical mobile-first / desktop density
/ adaptation of an external pattern). The Designer acts as
**synthesizer-judge**: compares the variants against the brief and the
design system, and produces THE final brief with a "Synthesis decisions"
section (what it took from which variant and why).

- **Validation status**: specified, first-party validation pending (see
  kit README § Validation ledger) — usable today; the cues above (size M+,
  no pattern to copy) are its activation triggers, no user prompt needed.
- The pod is a **dispatch pattern**, not a permanent structure — the agent
  economy makes parallel exploration cheap, but two roles deciding the same
  thing produce contradictory specs; that is why the synthesis has ONE
  owner.
- **Trigger to formalize** (standard counters mechanism): if the pod is
  dispatched on 3+ issues in the same sprint, evaluate a design sub-team
  with fixed roles. A design-heavy project (e.g. portfolio, marketing site)
  may start directly in pod mode.
- Why NOT a permanent 5-role team (Research/Wireframe/Visual/Handoff/
  Orchestrator, the industry model): Research and Handoff duplicate the PM
  and the SWE — the duplication produces contradictory specifications that
  someone has to reconcile, even if the tokens were free.

## Flow (genesis mode, complete)

```
grill-me → design brief → aesthetic direction (catalog) → tokens → IA → grooming (vertical slices) → build (prior inventory) → design review
```

With a user confirmation gate between phases (do not advance without
confirming) and per-feature persistence in `docs/design/<feature>/`. In
fixed-system mode the aesthetic-direction and token phases are skipped.

## Rules that integrate into the OTHER roles (not only the Designer)

- **PM**: every UI issue is a vertical slice (buildable, reviewable and
  verifiable on its own); grooming of new surfaces consumes the Designer's
  brief — never groom blind.
- **SWE**: prior inventory MANDATORY on UI issues — list existing
  components/tokens/fonts and declare what is reused/extended BEFORE
  creating anything new. (Real incident in the source project: a duplicated
  date picker because the SWE did not inventory first.)
- **Tester/Reviewer**: the design system skill's QA checklist is executable
  in review (grep for banned tokens, raw hex values, states).

## Design system skill (SKILL.md + DESIGN.md format)

Every project in fixed-system mode documents its system in two files
(format adopted from awesome-design-skills):

- `SKILL.md` — instructions an agent obeys: tokens with real values,
  typography, hard rules (do/don't), executable QA checklist, and **known
  gaps** (what the system does not define yet — so an agent asks instead of
  inventing).
- `DESIGN.md` — the intent for humans: why the system is the way it is,
  why the hard rules are hard, and how it evolves (a new pattern = the
  owner's decision, never a brief's whim).

Live reference: a fixed-system project keeps this as
`.claude/skills/<design-system>/` in its own repo.

## Catalog of aesthetic directions (genesis mode)

Two complementary sources, installable via CLI:

**1. awesome-design-skills — 67 complete design systems** (MIT,
SKILL.md+DESIGN.md format, `npx typeui.sh pull <name>`):

agentic · ant · artistic · basic · bento · bold · brutalism · cafe · claude
· claymorphism · clean · codex · colorful · contemporary · corporate ·
cosmic · creative · dithered · doodle · dramatic · editorial · enterprise ·
expressive · fantasy · fiction · flat · friendly · futuristic · geometric ·
glassmorphism · gradient · immersive · impeccable · levels · lingo ·
material · matrix · minimal · modern · mono · neobrutalism · neon ·
neumorphism · pacman · paper · perspective · power · premium · professional
· pulse · refined · retro · riso · roku · sega · shadcn · sketch ·
skeumorphism · sleek · spacious · square · stitch · storytelling ·
terracotta · tetris · vibrant · vintage

**2. designer-skills — 8 philosophies with implementation parameters**
(Apache 2.0, `npx skills add julianoczkowski/designer-skills`): Dieter Rams
· Swiss/International · Japanese Minimalism (Ma) · Brutalist · Scandinavian
· Art Deco · Neo-Memphis · Editorial/Magazine — each with concrete
parameters for typography, color, layout, spacing, motion and detail.

**How to choose**: the brief defines the emotional tone; 2-3 candidates are
preselected from the catalog; a design pod can be run (one variant per
candidate) and synthesized. Mixing is allowed (one philosophy as the base +
one catalog system as a token reference). The result is frozen into the
project's SKILL.md and the catalog is never consulted again.

**Safety rule** (applies to both sources): they are instructions for
third-party agents — REVIEW the content before installing them in a
sensitive project, the same as any dependency. Prefer copying/adapting the
reviewed content over installing the whole plugin unread.
