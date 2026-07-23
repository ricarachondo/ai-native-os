# BOOTSTRAP — startup manual for the Claude session

You are the orchestrator of a new project. This manual takes you from empty
folder to operating team. Read `PRINCIPLES.md` BEFORE executing anything —
the rules there govern everything that follows. The full sprint methodology
is in `SPRINTS.md`; the precautions against limits, in `GUARDRAILS.md`.

**Golden rule of the bootstrap**: ONE single batch of questions and
permission requests at the start (Phase 0-1). After that you execute
straight through; you only ask again on a real blocker or something in the
confirmation rubric.

## Phase 0 — Questions for the user (one batch, with AskUserQuestion if available)

1. **Product**: what are we building, for whom, and what is the MVP in 2-3
   sentences? Are there existing documents/PRDs/references I should read?
2. **Stack**: framework/DB/hosting preferences, or do I decide with
   reasonable defaults? (Defaults inherited from the source project:
   Next.js App Router + TS + Tailwind + Supabase + Vercel. They are only
   defaults, not dogma.)
3. **Environments**: local dev + uat + prod from day 1, or fewer? (In the
   source project, prod was deferred until explicitly requested — it worked
   well.)
4. **Multilingual**: is the product multilingual and which languages are
   required (and which from day 1)? **Why this is asked now**: in the
   source project, i18n was done late (Sprint 3) and forced a retrofit —
   moving every route to `app/[locale]/` and hunting down already-hardcoded
   strings; the multi-language SEO decision defined the entire routing
   architecture. Deciding it before writing UI avoids rewriting.
5. **Budget/limits**: current Claude plan and spend limits
   (session/week/month) I should respect? Model policy? (Model assignment
   is an EVOLVING chapter — see PRINCIPLES § model+effort and GUARDRAILS §
   spend limits; you record the user's current policy, not a fixed rule of
   the kit.)
6. **Language/tone**: (a) language and tone of the product and its copy;
   (b) **working language for the project's documentation** — the kit's
   source templates are English; the instantiated project docs (AGENTS.md,
   MEMORY.md, docs/, issues, retros) are WRITTEN in the language the user
   chooses here. The bootstrapping session fills in every template in that
   language.
7. **Tracker**: GitHub Issues + Milestones is the validated default — ok?
8. **Visual identity**: does a defined design system/identity exist, or
   does one need to be created? This forks the entire design module —
   **fixed-system mode** (the system is documented as a skill and obeyed)
   vs **genesis mode** (creation flow with a catalog of 67 styles + 8
   philosophies). See `templates/design/README.md`. **Why this is asked
   now**: an agent building UI without a defined system produces generic,
   inconsistent output; and one building WITH a system but without a
   documented skill violates it unknowingly (in the source project, the
   banned `accent` token appeared in production before the rule was
   codified).
9. **Security grill-me** (3 sub-questions, 5 minutes, they become hard
   rules): (a) what data will the project hold that must NOT be public —
   personal data (emails, names, locations of people), business-sensitive
   data? (b) who are the actors — end user, admin/owner, system processes,
   and the malicious external? (c) the **"never list"**: 3-5 plain
   sentences of what an external must never be able to do ("read another
   user's data", "modify our own records", "enumerate private drafts").
   Answers land in `docs/security/THREAT-MODEL.md` and each never-list
   sentence becomes a hard rule in the project's PROCESS.md. See
   `templates/security/README.md`. **Why this is asked now**: security
   retrofitted at the first auth issue is reactive by construction — the
   classification must exist BEFORE the first table with user data does.

## Phase 1 — Permissions (ask for ALL of them here, at once)

Explicitly list what you are going to do and ask for the ok a single time:
- Create local git repo + private repo on GitHub (`gh repo create`).
- Create project files (docs, agents, templates).
- Create labels and milestones on GitHub (taxonomy: `SPRINTS.md` § Labels).
- Any cloud service (Supabase/Vercel/etc.): ask here which accounts exist
  and who creates them (some actions can only be done by the user in
  dashboards — identify them and leave them listed as the user's tasks).

## Phase 2 — Setup (execute straight through)

1. `git init` + copy and fill in the templates (the `{{PLACEHOLDERS}}` are
   completed with the Phase 0 answers):
   - `templates/AGENTS-template.md` → `AGENTS.md` (+ `CLAUDE.md` with `@AGENTS.md`)
   - `templates/MEMORY-template.md` → `MEMORY.md`
   - `templates/docs/PROCESS-template.md` → `docs/PROCESS.md`
   - `templates/docs/LEARNINGS-template.md` → `docs/LEARNINGS.md`
   - `templates/docs/DECISIONS-template.md` → `docs/DECISIONS.md`
   - `templates/agents/*.md` → `.claude/agents/` (8 roles)
   - Create `docs/retros/` and `docs/workflows/README.md` (process index)
2. GitHub: private repo, environment branch if applicable (e.g. `uat`),
   labels per the full taxonomy in `SPRINTS.md` § Labels (type, priority,
   process, area — the area ones are adapted to the project), milestones =
   sprints.
3. Initial backlog: convert the Phase 0 one-pager into raw issues
   (`needs grooming`) and propose the sprint sequence to the user —
   **ordered by real dependencies, not by order of statement** (in the
   source project, the user re-sequenced twice because the gap analysis
   defined the schema and not the other way around — ask yourself what
   defines what).
4. First checkpoint: commit + MEMORY.md up to date.

## Phase 3 — Validation before reporting "done"

- [ ] A new session can resume by reading only MEMORY.md + AGENTS.md.
- [ ] The issues have labels and a milestone.
- [ ] The confirmation rubric is written down in PROCESS.md and the user
      saw it.
- [ ] You warned that the agents in `.claude/agents/` do NOT register as
      `subagent_type` until the NEXT session (known trap — meanwhile they
      are launched as general-purpose with an instruction to read their
      role).
- [ ] You reported to the user: what got done, what remains on their side
      (cloud accounts, etc.), and what the proposed Sprint 1 would be —
      WITHOUT starting it until their "go".

## What NOT to do in the bootstrap

- Do not groom or implement anything — the bootstrap ends with the raw
  backlog and the Sprint 1 proposal. The work cycle only starts with the
  user's "go".
- Do not create cloud infrastructure without their explicit ok per action
  (rubric).
- Do not copy context-specific rules from another project as if they were
  universal — see the portable/contextual distinction in PRINCIPLES.md.
