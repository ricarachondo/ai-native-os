# Controls map — {{PROJECT}} (certification-readiness)

> Control → our practice → where the evidence lives. Seeded from ISO/IEC
> 27001:2022 Annex A themes (see the module README § Certification).
> Updated when a mapped practice changes. Unmapped = a known gap, listed
> at the bottom — never silently absent.

| Control area (ISO 27001:2022 Annex A) | Our practice | Evidence |
|---|---|---|
| 5.x Organizational (policies, roles) | PROCESS.md + role files + THREAT-MODEL.md | The files themselves, git history |
| 5.15-5.18 Access control / identity | {{server-side authz rules, RLS, least-privilege tokens}} | {{gate reports, policies in migrations}} |
| 5.34 / 8.10-8.12 Privacy & PII | PII-INVENTORY.md + deletion paths + secrets rules | The inventory, issue history |
| 6.x People (awareness) | The agents ARE the workforce: rules live in role files | Role files + gate reports |
| 8.9 Configuration management | {{env promotion discipline, env vars per environment}} | Change checklist, deploy history |
| 8.16 Monitoring | {{error tracking + oncall verification}} | Oncall reports, tracker |
| 8.25-8.34 Secure development lifecycle | The issue cycle: spec → build → independent test → gates → merge | PROCESS.md + every issue's trail |
| 5.24-5.28 Incident management | Bug template: severity by user impact, root cause, regression test | Bug issues |

## Known gaps (unmapped or partial)

- {{gap → what closing it would take}}
