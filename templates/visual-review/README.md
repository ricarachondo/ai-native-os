# Visual review surfaces — the human gate, upgraded

## What this module is

The process has [HUMAN] gates everywhere — grooming approvals, acceptance
reviews, design decisions, sprint closes. Historically every one of them was
served as a WALL OF TEXT, which taxes exactly the person the gate exists
for: a non-technical owner reviewing in business terms. This module adopts
an external toolset (Agent-Native skills, by Builder.io — see Credits) that
turns those gates into interactive visual surfaces the owner can click,
compare and COMMENT ON — and the comments flow back to the agent as
actionable anchors.

**This is a reviewing-surface adoption, not a process change.** Every gate,
owner and rule stays as defined in PROCESS; only the artifact the human
reviews gets richer.

## The five skills and where they plug in

| Skill | What it produces | Plugs into | Owner |
|---|---|---|---|
| `visual-plan` | Interactive plan: diagrams, file maps, annotated code, open questions | Grooming of L-size or architecture-heavy issues, migration/consolidation plans, anything with a [HUMAN] approval | PM |
| `visual-recap` | Interactive recap of a branch/diff: what changed, API/schema summaries, annotated diffs | Acceptance reviews, sprint-close summaries for the owner | PM / Tester |
| `visualize-repo` | Durable visual documentation workspace for a repo (APIs, components, models, flows) | Onboarding a new session or collaborator; complements `docs/database/` | Data Architect / SWE |
| `design-exploration` | 2–5 side-by-side interactive design directions; the owner picks; export to code handoff | Designer genesis mode and any new-surface spec needing a human pick | Designer |
| `visual-edit` | A running local app opened as clickable screens for flow review | Design audits of an already-running app | Designer |

## Usage rules (hard)

1. **The gate decides, not the tool.** A visual plan is produced when the
   gate's reviewer is the human owner AND the decision has structure worth
   visualizing (multi-step plans, design directions, schema changes). A
   3-line fix does not get a visual plan — that is decoration, and it costs
   tokens.
2. **Privacy defaults (security seam).** These surfaces are HOSTED by a
   third party. Default for private projects: **Local-Files Privacy Mode**
   (plans live as local MDX in the repo, synced to disk, not to the vendor
   cloud) and guest mode. Never place secrets, credentials, PII or
   unredacted production data in a plan/recap — the same never-list that
   governs issues applies. Public sharing of a plan is an [HUMAN] decision.
3. **Comments are the loop.** The point of the surface is that the owner's
   comments come back as anchors the agent can act on. A visual plan nobody
   comments on and that never changes a decision is a cost signal — see
   the demotion rule below.
4. **Install by reference, never by copy.** The vendor's installer is the
   canonical mechanism (it updates from their registry — copying the skill
   files into this kit would create silent drift, a failure mode this kit
   has already paid for once):
   ```bash
   npx @agent-native/core@latest skills add visual-plans   # plan + recap + repo
   npx @agent-native/core@latest skills add design-exploration
   npx @agent-native/core@latest skills add visual-edit
   ```
   Installs at user level (all projects). The MCP connections
   (`plan.agent-native.com`, `design.agent-native.com`) require a one-time
   authentication by the user in each client (`/mcp` → Authenticate).
5. **Vendor dependency is declared, not hidden.** If the vendor's hosted
   apps disappear or start charging beyond value, the fallback is the
   in-house path: the agent's own artifact-publishing (HTML pages) covers
   plans and recaps with no vendor, losing the comment-anchor loop. That
   fallback is why this adoption is LOW-RISK: the method survives the
   vendor.

## Evidence state

**Specified, pending first-party evidence** (usable today; ⏳ in the
ledger). Promotion to validated requires: one real grooming served as a
visual plan whose owner comments changed the plan, and one acceptance
review served as a visual recap. **Demotion cue**: three consecutive visual
plans with zero owner comments → the surface is not earning its tokens;
drop back to text for that gate class.

## Credits

Skills and hosted apps by [Builder.io's Agent-Native project]
(https://github.com/BuilderIO/agent-native) (package license: ISC).
Adopted 2026-08 after direct evaluation of the five skills' sources.
