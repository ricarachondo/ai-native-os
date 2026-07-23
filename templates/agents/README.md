# Birth contract — how ANY new role, pod, or workflow inherits the system

> The guarantee the user asked for explicitly: nothing new joins the team
> without automatically adopting everything already built. Inheritance is
> BY CONSTRUCTION (this contract + the change checklist), never by
> remembering.

## The architecture of rules (why inheritance is automatic)

- **Transversal rules live in ONE place**: the project's `docs/PROCESS.md`
  and the kit modules (security, quality, launch, database, design). Every
  role file's first instruction is to READ them — so when a transversal
  rule changes, every existing AND future role inherits it on its next
  dispatch, with zero per-role edits. Projects inherit kit changes through
  the kit-sync marker at every session start.
- **Role files carry ONLY what is specific to that role** (its modes, its
  checklist extension, its boundaries) plus references. **A transversal
  rule copied into N role files is a drift bug**: copies rot silently when
  the source changes. Reference, don't copy.
- **Pod/pattern-specific rules** live in the pattern's module section
  (design pod in the design module, diamond/loop in the quality module) —
  a pod dispatch instruction cites the pattern; the pattern's rules apply
  to every instance automatically.

## The contract (every new role/pod/workflow file MUST include)

1. **Read-first line**: read the project's `docs/PROCESS.md` (+ the
   module(s) that govern this role's domain) before acting.
2. **Scope**: what it does, and its modes if more than one.
3. **Boundaries**: what it must NOT do (implement? commit? touch cloud
   state? see secrets?) — stated, not implied.
4. **When to invoke / cues**: the situations that activate it, AND the
   scope guard (when NOT to invoke — no empty handoffs).
5. **Output format**: the house triaged format for audit-type roles
   (Must fix / Should fix / Could improve / What works well + open
   questions with recommendation); evidence-only findings.
6. **Reporting path**: posts to the tracker (queryable), summary to the
   orchestrator.

## The creation checklist (enforced via the change checklist)

Creating a new role/pod/workflow is a CHANGE, so it passes the merge
change checklist like any other — with these specific items:

- [ ] Contract sections 1-6 present in the new file
- [ ] Transversal content referenced, not copied (grep the new file for
      restated PROCESS rules — restatements are findings)
- [ ] Registered in: the PROCESS roles table · the project's AGENTS.md
      role list/count · the kit's validation ledger (new = ⏳ by
      definition) · the kit's templates if the role is portable (the
      two-question rule applies to roles too)
- [ ] If it is a dispatch pattern: cues declared (patterns that only
      activate when the user remembers them don't compound)

## Why this is enough (and what it does not cover)

A new role created under this contract adopts, without any extra step:
the confirmation rubric, secrets handling, worktree discipline, the
change checklist, bug rules, carry-over rules, security gates, effort
assignment, and every future transversal rule — because they all live in
the documents it reads at dispatch. What the contract can NOT do is force
a role file written OUTSIDE the process to comply — that's why creation
goes through the change checklist, and why the reviewer rejects a new
role file missing the contract, the same as code without tests.
