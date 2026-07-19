# Database documentation module — plug and play

> Self-contained module: living, business-language documentation of a
> project's database, kept in sync with the schema as a hard rule. The goal
> is that anyone — a teammate, an agent with fresh context, or an external
> user who needs to work with the data — understands the full model without
> reading migrations: what each table represents in the business, what each
> column means and why it is sometimes empty, how everything relates, and
> which hard rules each constraint protects. Validated first in a real
> project run on this system (a two-source event catalog with draft
> lifecycle and row-level security).

## What each project creates

A `docs/database/` folder in the project repo, with:

| File | What it contains |
|---|---|
| `<table>.md` — **one per table** | What the table is in the business, its relationships, every column explained, keys/constraints, indexes with their reason to exist. |
| `relationships.md` | The full model's relationship map (an ER diagram helps), **including semantics the foreign keys don't show** — inheritance/override patterns, deduplication keys, and relationships that live outside the database (external services, storage, auth providers). |
| `schema.md` | Schema-level overview: design philosophy (the 3-5 decisions that shape the model), enums, naming and typing conventions, and the migration history in one line each. |
| `architecture.md` | The infrastructure around the database: environments and how changes promote between them, **who writes what through which path** (a small diagram of clients and their access route), the security model layer by layer, storage, external systems that complete the model, and known operational constraints (plan limits, pausing behavior, rate limits). |
| `README.md` | Index + the per-table format + the maintenance rule, so the folder is self-explaining. |

## Per-table format (fixed)

1. **What it is** — 2-3 sentences in business language. If a non-technical
   person read it, they should understand it.
2. **Relationships** — which tables it connects to and what that relation
   MEANS in the business (not just "FK to X"). Include what happens on
   delete, in business terms ("if the series disappears, its dates survive
   as standalone events").
3. **Columns** — name, what it answers/represents, type in simple terms,
   and **business notes**: default, when it is null and why (a legitimate
   "we don't know" is different from missing data), and the rules that
   apply. Group columns by theme when the table is large (identity /
   lifecycle / content / audit trail), and say explicitly which groups only
   apply to which discriminator values.
4. **Keys and hard constraints** — explained by what they PROTECT, not just
   listed ("two published events can't share a URL", not "unique index on
   slug").
5. **Relevant indexes** — only the ones that exist for a specific business
   reason ("the most frequent query is the public catalog ordered by
   date"). Skip generic ones.

The business notes are the highest-value and highest-effort part — they
capture the WHY that a schema dump can never show. A column doc that only
restates the type is not done.

## Maintenance rule (hard — adopt verbatim)

**Every migration or change that touches the schema, the relationships, the
security model (RLS/policies/permissions), storage, or the data
infrastructure updates `docs/database/` in the same issue cycle that
introduces it.** Like code and tests, database documentation is part of the
Definition of Done, not a separate task:

- The SWE updates the affected table doc(s) plus
  `relationships.md`/`schema.md`/`architecture.md` as applicable, in the
  same worktree as the change.
- The PM/reviewer verifies it in the acceptance review — a schema change
  with stale docs is rejected the same as a feature with no tests.

This rule exists because database docs written "later" are written never,
and stale docs are worse than none: an agent (or person) that trusts them
makes confidently wrong decisions.

## Bootstrap (existing projects)

For a project with an existing schema: pilot the format with the CENTRAL
table and a representative subset of columns first, get the user's ok on
the format (the business-notes depth is a taste decision), then complete
the rest. Don't document all tables in one pass before validating — the
expensive part is the business context, and rewriting it twice because the
format changed is pure waste. Sources for the business notes: migrations
and their comments, the decision log, issue history, and the code that
reads/writes each column.

## Do we need a data-architect role? (evaluated — not yet)

The kit's standing principle applies (*memory before agent*, PRINCIPLES.md
#13): the format above is executable by the existing roles — the SWE writes
the doc updates as part of the change, the PM verifies them, and data-
architecture DECISIONS (new table vs column, inheritance patterns,
denormalization) already have an owner: they surface in grooming and the
user approves them like any architecture question. A permanent specialist
role would add a handoff without adding authority.

**Trigger to create the role** (standard counters mechanism): if in one
sprint 3+ issues require non-trivial data-architecture decisions (new
tables, remodeling, migration strategy debates), or the schema-doc rule is
caught stale twice in acceptance review, create a `data-architect` agent:
audit mode (review the model against the docs and the real query patterns)
+ spec mode (propose the data model for a new feature BEFORE grooming,
mirroring the Designer's two modes). Until a counter crosses, the rule +
format is the whole system.
