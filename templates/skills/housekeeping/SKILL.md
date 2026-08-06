---
name: housekeeping
description: >
  Machine-wide disk & artifact housekeeping under the kit's lifecycle policy
  (GUARDRAILS § 2b). USE when: free disk is low or the session-start disk
  check fires (<15GB); the user mentions "disk full", "no space", "limpieza",
  "housekeeping", "borrar caches/imágenes/volúmenes"; a project is being
  paused or finished (hibernation); or after migrating/uninstalling a
  container runtime or heavy tool. Diagnoses with the kit's report-only
  script, classifies findings as genuinely-irrecoverable vs merely-costly,
  and proposes actions — it never deletes real data without the
  reproducibility gate + the user's ok.
---

# Housekeeping (disk & artifact lifecycle)

The policy lives in the kit's `GUARDRAILS.md` § 2b — this skill is its
executable arm. Two iron rules before anything else:

1. **This process proposes; deletion of anything in the irrecoverable
   class requires the reproducibility gate + the user's explicit ok.**
2. **Classify before acting**: genuinely IRRECOVERABLE (container volumes
   holding real local data · uncommitted files in worktrees) vs MERELY
   COSTLY to restore (builds, node_modules, caches, images — worst case is
   time/bandwidth). Verification effort is proportional to the class.

## Procedure

1. **Diagnose**: run the kit's `scripts/housekeeping.sh [DEV_ROOT]`
   (report-only — measures disk, dead runtime dirs, worktrees, builds,
   stale node_modules, caches; deletes nothing).
2. **Classify each finding** per the two classes above. Dead runtime data
   dirs from UNINSTALLED runtimes (e.g. a leftover VM disk after switching
   container runtimes) look safe but contain the projects' local DB
   volumes → irrecoverable class.
3. **For the merely-costly class**: propose the batch (builds, caches,
   dangling images — never `docker image prune -a` by default) and execute
   on approval. Paused projects' `node_modules`/`.next` are in this class.
4. **For the irrecoverable class, run the reproducibility gate FIRST**:
   per project with local data at stake — start its stack (on-demand),
   `db reset` + seed, verify real data reproduces (row counts, not
   vibes), stop the stack. A seed that depends on an external or paused
   source is itself a finding → file the tech-debt issue (seed must
   depend on the project's OWN live sources) and rescue that project's
   data before any deletion. Only with every affected project verified
   green → propose the deletion with the evidence attached.
5. **Worktrees**: `git status` clean AND branch content already in the
   target branch are BOTH preconditions; a worktree matching an open
   issue may be another session's ACTIVE work — check before assuming
   "orphan".
6. **Report**: free-space delta per item, what was verified, what was
   filed as debt, what was left alone and why.

## Hibernation (project pause/finish)

`supabase stop --no-backup` (or stack equivalent) + drop
`node_modules`/`.next` — ONLY after step 4's gate for that project.
Waking: install + start + reseed (~10 min). Finished projects: same, and
never purge shared images that other projects' next start would re-pull.
