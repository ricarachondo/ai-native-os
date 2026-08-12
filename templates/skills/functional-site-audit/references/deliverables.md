# Deliverable templates

Two twin documents per flow: an **analysis** (with evidence) and a **PRD** (what to build). Plus an .html twin and versioned screenshots.

## Analysis — `<site>-<flow>-analysis.md`

```
# Reverse-engineering of <flow> — <site>
> Functional reverse-engineering audit (DATE). Real walkthrough with network
> interception. Roles: functional analyst + QA explorer [+ AI agent engineer].
> Scope, limits, "no purchases/no publishing" note. Sibling docs + evidence links.

## 1. Executive summary
Prose + a numbered list of the KEY FINDINGS (the decisions a reader must remember).

## 2. Flow map
```mermaid
flowchart TD
  ... happy path + branches + error exits + URL states ...
```

## 3. Per-screen / per-component cards
For each: states, fields (type/required/validation/defaults), actions (→ effect),
microinteractions, associated network.

## 4. Network & persistence
Endpoints table (moment → request). REAL captured payload(s) in a code block.
Where state lives (backend vs localStorage/cookies). URL-state family if any.

## 5. Microinteractions

## 6. Data model (inferred from payloads)
Exact field names, types, sentinel values, relationships.

## 7+. Specialized sections (per active module)

## N. Implications — adopt / improve
Two columns: what to adopt, what to improve vs the reference (include antipatterns).

## Evidence & traceability
| # | Observation | Evidence (captured how) |
```

## PRD — `prd-<product>-<flow>.md`

```
# PRD — <product> <flow>
**Status / Date / Author.** Related documents (cross-link the analysis + sibling PRDs).

## 1. Problem
## 2. Objective  (+ Non-goals)
## 3. Success metrics   (table with targets)
## 4. Principles (validated in the reference)
## 5. Functional scope   (sub-sections per surface)
## 6. Flow (mermaid)
## 7. Technical requirements
   - Reference architecture (ported from the analysis), agent + tools if applicable,
     retrieval/indexing, streaming/state/media, security/anti-abuse, evals + telemetry.
## 8. Edge cases
## 9. Risks & open questions   (table)
## 10. Acceptance criteria
## 11. Phasing / sequencing   (P0 MVP vs v1.1 vs later) + cross-PRD dependencies
```

## HTML twin
Self-contained `<site>-<flow>-analysis.html`: dark theme, CSS variables, styled tables,
cards, and the evidence table. Same content, portable packaging for pasting into an LLM/design tool.
Validate tag balance before delivering.

## Screenshots
`screenshots/<flow>/NN-descriptive-name.png` (ordinal + description) captured anonymously
with Playwright, respecting the hard limits (stop at auth/payment; own assets for e2e).
Add a `screenshots/README.md` mapping each file to what it shows. Link the folder from the analysis.
Note: Chrome-MCP screenshots are ephemeral (live in the conversation) — re-capture to disk if they must persist.

## Discipline reminders
- Observed vs inferred, always explicit. Label speculation.
- Every strong claim → a row in the evidence table.
- Close key patterns with adopt/improve.
- N≥3 examples before calling something a rule.
