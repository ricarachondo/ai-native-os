# MEMORY — {{PROJECT}} (working memory across sessions)

> **Protocol**: every new session READS this file before exploring
> anything, verifies the real state of the repo (`git status`, recent
> `git log`), and then `docs/PROCESS.md` + `docs/LEARNINGS.md` if it is
> going to groom/implement/test/ship. Updated at every checkpoint. Max ~80
> lines: what's done is compressed to one line, only what's pending carries
> detail.

## Current state ({{DATE}})

{{STATE — closed sprints in one line; in-progress work in detail;
blockers marked 🔴 with what is expected from the user}}

- Process: `docs/PROCESS.md` · Learnings: `docs/LEARNINGS.md` ·
  Decisions: `docs/DECISIONS.md` · Retros: `docs/retros/`

## How to resume (exact commands)

```bash
{{STARTUP_COMMANDS}}
```

## Cloud infra

{{ENVIRONMENTS_AND_ACCOUNTS_STATUS}}

## Autonomous development team

5 agents in `.claude/agents/` — they do not register as `subagent_type`
until a new session; meanwhile launch them as `general-purpose` instructing
them to read their role first. Cycle: PM groom → SWE (isolated worktree,
`.tmp/progress-{issue}.md` if large) → Tester → local merge to main →
migration/infra BEFORE pushing code (if applicable) → push + env sync →
oncall. Sprint Close with 5 questions + counters (`docs/PROCESS.md` §
Sprint end).

**Confirmation rubric**: cloud DB/infra/prod/destructive git/credentials
ALWAYS ask for the user's ok per action; everything else runs on the
sprint's "go".

## Next steps (in order)

1. {{...}}

## Known traps (do not re-discover)

- Custom agents do not register until a new session (see above).
- {{STACK_TRAPS — they accumulate here, pruned when resolved at the root}}
