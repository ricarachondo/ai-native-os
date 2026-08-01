# `{{table_name}}`

> One file per table (`docs/database/<table>.md`). Format is fixed — see
> the module README. The business notes are the highest-value part: a
> column doc that only restates the type is not done.

## What it is

{{2-3 sentences in business language. A non-technical person should
understand it.}}

## Relationships

{{Which tables it connects to and what the relation MEANS in the
business, including on-delete behavior in business terms.}}

## Columns

> Group by theme when large (identity / lifecycle / content / audit).

| Column | What it answers | Type (simple) | Business notes (default, when null and why, rules) |
|---|---|---|---|
| {{}} | {{}} | {{}} | {{}} |

## Keys and hard constraints

{{Explained by what they PROTECT — "two published events can't share a
URL", not "unique index on slug".}}

## Relevant indexes

{{Only the ones with a specific business reason. Skip generic ones.}}
