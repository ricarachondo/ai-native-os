# Data architecture — {{PROJECT}}

> Instantiated as `docs/database/architecture.md`. The infrastructure
> AROUND the database.

## Environments and promotion

{{local / uat / prod — how schema changes promote; hard rule: migrations
to the cloud BEFORE the code that expects them.}}

## Who writes what through which path

```
{{small diagram: each client (browser, SSR, crons, webhooks) → its access
route (anon key + RLS / service role / dedicated endpoint)}}
```

## Security model, layer by layer

{{RLS policies → API-level checks → rate limits → never-list rules that
constrain this model (link THREAT-MODEL.md).}}

## Storage

{{buckets, what lives there, who reads/writes, public vs signed URLs.}}

## External systems that complete the model

{{video/CDN/email/enrichment providers — what data of ours they hold.}}

## Known operational constraints

{{plan limits, pausing behavior, rate limits, region/latency.}}
