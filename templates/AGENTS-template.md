# {{PROJECT}}

<!-- The project's CLAUDE.md contains a single line: @AGENTS.md -->

## Session protocol (MANDATORY — token efficiency)

**On start**: read `MEMORY.md` (≤80 lines) BEFORE exploring or launching
agents. It contains state, startup commands, blockers and known traps. With
that + this file you have the complete context — do NOT re-explore the repo
unless the task requires it.

**Checkpoint**: when closing a phase/issue, when the user says
"checkpoint", or before a context compaction → update `MEMORY.md`
(compress what's done to one line, detail only what's pending, record new
traps), commit + push. Half-done work is committed on a `wip/<topic>`
branch with an explicit TODO in MEMORY.md. **Golden rule**: MEMORY.md never
exceeds ~80 lines — it gets pruned, not accumulated.

## Development process (autonomous team)

Read [`docs/PROCESS.md`](docs/PROCESS.md) at the start of every session
that is going to groom/implement/test/ship — it defines the cycle, the 5
roles (`.claude/agents/`) and the orchestrator's responsibilities. The
orchestrator coordinates, it does not execute. Learnings (read before every
sprint): [`docs/LEARNINGS.md`](docs/LEARNINGS.md). Decisions:
[`docs/DECISIONS.md`](docs/DECISIONS.md). Process index:
[`docs/workflows/README.md`](docs/workflows/README.md).

## What the product does

{{PRODUCT_DESCRIPTION_AND_USERS}}

## Stack and conventions

{{STACK}} · Product languages: {{LANGUAGES}} (decided in the bootstrap —
late i18n forces a retrofit) · Copy language: {{COPY_LANGUAGE}} ·
{{KEY_CONVENTIONS}}

## Backend / environments

{{ENVIRONMENTS_AND_RULES}} <!-- e.g.: local dev / uat / prod-on-request;
secrets rules: straight to destination, never to intermediate files nor
the chat -->
