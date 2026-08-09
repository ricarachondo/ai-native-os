# Product analytics module — events with an owner

> Self-contained module: the project's product-event taxonomy as a LIVING
> contract with a named owner, so metrics stay trustworthy as the product
> grows. Born from a source project whose core value IS event tracking —
> and whose competitive research proved the failure mode this module
> prevents: the reference competitor derived video metrics from section
> visibility time instead of emitting real events, producing contradictory
> numbers on the same screen ("1 rewatch" and "No rewatches yet").
> Generalizes audit dimensions A11/A12 of `../quality/AUDIT-PLAYBOOK.md`.
>
> **Validation status**: ⏳ specified from real evidence, first full run
> pending (that project is the first to exercise it).

## The living document (per project)

`docs/analytics/EVENTS.md` — one row per event:

| Event | Payload (fields + types) | Emitted by | Consumed by | Why it exists (the question it answers) |
|---|---|---|---|---|

Plus three sections: **conversion funnels** (at least one defined before
launch — the launch checklist demands it), **metric definitions** (each
user-facing metric names its ONE source query/view), and **retired
events** (kept with dates — old data outlives old code).

## Hard rules (adopt verbatim)

1. **One metric, one source.** Every user-facing number names exactly one
   query/view it comes from. Two surfaces showing "the same" metric from
   different derivations is a bug, not a nuance.
2. **Events are emitted, never inferred.** If a metric matters, its event
   exists at the source (a real `video_played`, not "time visible in the
   video section"). Derivations are allowed only as clearly-labeled
   proxies with the derivation written down.
3. **Same-cycle sync.** Any issue that adds/changes/retires an event
   updates `EVENTS.md` in the same cycle — stale event docs are rejected
   like a schema change with stale database docs.
4. **Enums, not free strings.** Event names and section/screen identifiers
   come from closed enums the docs list; the tracker rejects unknown
   values server-side.
5. **Privacy by shape.** Payloads carry the minimum: booleans/ids over
   raw values where possible (`has_value: true`, never the value). New
   personal datum in a payload → PII-INVENTORY update, same cycle.

## Ownership

The **Data Architect** owns the taxonomy (spec mode reviews any new/changed
event before grooming, mirroring its schema role); the **Platform
Engineer** owns delivery reliability (batching, retries/idempotency, rate
limits on the ingest endpoint) and runs the analytics section of the
launch gate. Trivial payload tweaks stay with the SWE under rule 3 — the
same scope guard as the database module.

## Bootstrap (per project)

At first instrumentation (not before — memory before agent): create
`docs/analytics/EVENTS.md` from the events the MVP actually emits, define
the first funnel, and wire rule 3 into the PM's grooming checklist. If
the project has success metrics with thresholds (from a PRD), map each to
its funnel/event here — an unmeasurable target is a wish.
