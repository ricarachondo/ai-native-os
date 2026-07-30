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
- The pod is an INSTANCE of the kit's general **diamond dispatch**
  pattern (`templates/quality/README.md` § 5) — its rules (Stop Rule,
  one synthesis owner, evaluate before merge) apply here automatically.
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

## Mobile interaction preference: bottom sheets (documented preference)

On small screens, **prefer bottom sheets over centered dialogs and
dropdowns wherever they don't add friction** — thumb-reachable, contextual
(the page stays visible behind), and the current interaction convention
users already know. Codified as the audit playbook's dimension A10 and as
a rule for future work: new overlays are designed as mobile bottom sheets
FIRST, then mapped to a desktop presentation (dialog/popover) from the
same component API — never a desktop dialog adapted down.

Good fits: contextual actions, filters/sort, detail peek, short multi-step
flows (the Wolt pattern: paginated sheets for lightweight wizards).
Guardrails (friction test — if any fails, reconsider): never nest more
than one sheet level · always dismissible (swipe down + scrim tap +
visible affordance) · respects safe areas and keyboard (inputs must not
hide behind it) · focus management and `prefers-reduced-motion` per the
a11y checklist · content that needs full attention or legal confirmation
still uses a blocking dialog. The web-AND-mobile excellence principle
applies: the desktop mapping gets the same care.

References (review before installing any library, as always):
[gorhom/react-native-bottom-sheet](https://github.com/gorhom/react-native-bottom-sheet)
(React Native), [wolt_modal_sheet](https://github.com/woltapp/wolt_modal_sheet)
(Flutter, the multi-page pattern), and pattern galleries/guides for
design exploration. On web stacks, drawer-style components (e.g.
vaul-class) map the same pattern.

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

## Design-to-code: Figma MCP + Code Connect (operating method)

When the fixed system lives in **Figma**, this is how we translate it into
code. Validated on a real project run (2026-07-23).

### The read-FROM-Figma flow (this is the default, works on any plan)

The Figma **Dev Mode MCP** (`mcp__figma-desktop__*`, enabled per-file in
the desktop app's Preferences) is **read-only**: it turns a design into
code context. It does NOT author designs into Figma — the human designs,
the agent reads and implements.

Order — **tokens → components → screens** (never screens first; it produces
throwaway work):

1. **Tokens first.** `get_variable_defs` on the Foundations page returns
   the real values (hex, fonts, shadows) as DATA. Land them in the token
   layer (CSS vars / Tailwind `@theme`) before touching any component.
2. **Components next.** `get_design_context` on a component returns
   reference React+Tailwind code + a screenshot + token hints. Treat it as
   a **reference, not paste-in code** — it comes absolutely-positioned with
   hardcoded hex. ADAPT it to the project's stack: map every hex to a
   project token, every Figma variant/state to the component's variant
   system (`cva`, etc.). Never emit a raw hex where a token exists; never
   invent a prop the code component doesn't have.
3. **Screens last**, composed from the now-branded components.
4. **Verify with `get_screenshot`** (orientation + visual diff), not as the
   source of truth. The design-to-code skill mandates a screenshot after
   `get_design_context` for context — screenshots confirm, they don't
   specify.

Load the platform skill `figma:figma-design-to-code` BEFORE
`get_design_context`; it owns the workflow contract.

**Safety migration rule** (learned incident): remapping a shared semantic
token (e.g. shadcn `--primary`) globally can silently break contrast where
that token is used with an assumed text color. When a pastel system uses
"fill + dark text" but the component library assumes "saturated fill +
white text", change the COMPONENT variant, not just the token — and land
neutrals/surfaces via token first, risky filled variants via component
second, so nothing renders broken between commits.

### Code Connect (the stronger, Figma-hosted link) — plan-gated

Code Connect publishes the mapping "this Figma component ↔ this code
snippet" back to Figma, so inspecting a component in Dev Mode shows the
project's REAL component code instead of a generic translation. Worth it
for a maturing system — but there are **hard prerequisites** an agent must
check before promising it:

- **Figma Organization or Enterprise plan, Dev or Full seat.** Not
  available on Free/Professional — the API returns a plan error. This is a
  billing decision; the agent cannot enable it. **Verify first** by calling
  `get_code_connect_suggestions` — if it returns the plan error, STOP and
  tell the user; do not scaffold non-functional Code Connect files.
- **Components published** to a team library (local-only components are
  invisible to Code Connect).

Two flavors: (a) **MCP template files** `.figma.ts` (`figma.selectedInstance`
API, saved via `send_code_connect_mappings` — skill `figma:figma-code-connect`);
(b) **CLI parser** `.figma.tsx` (`figma.connect()`, published with
`npx figma connect publish` + a Figma token the USER runs locally — never
paste the token into the agent). Publishing always needs the user's token
and the paid plan.

**Default posture**: run the read-FROM-Figma flow now (works, no plan
change); document Code Connect as the activation path and only build its
files once the plan supports it — otherwise the files are inert deps.

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
