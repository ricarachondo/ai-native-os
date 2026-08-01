# Relationships — {{PROJECT}}

> Instantiated as `docs/database/relationships.md`. The full model's
> relationship map, INCLUDING semantics the foreign keys don't show.

## Relationship map

```mermaid
erDiagram
  {{TABLE_A}} ||--o{ {{TABLE_B}} : "{{meaning}}"
```

## Semantics beyond the FKs

- {{inheritance/override patterns, deduplication keys, soft links}}

## Relationships that live OUTSIDE the database

- {{external services, storage buckets, auth providers — what connects to
  what, and what breaks if the external side disappears}}
