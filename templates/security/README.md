# Security module — secure by default, certification-ready by construction

> Self-contained module: security designed in at bootstrap (not retrofitted
> at the first auth issue), privacy as a maintained inventory (not a
> generated policy), and an evidence trail that makes an eventual ISO
> 27001 / SOC 2 certification a documentation exercise instead of a
> retrofit. Complements the Security Engineer role
> (`../agents/security-engineer.md`) and the launch module's Security
> section.

## The three living documents (per project, `docs/security/`)

| File | What it is | Hard maintenance rule |
|---|---|---|
| `THREAT-MODEL.md` | ONE page: sensitive-data classification, actors, the **never list** (3-5 plain sentences of what an external must never be able to do), mitigations per threat, and the project's **frozen authz extension** (§ Hybrid checklist below). Doubles as the risk-register-lite. | Reviewed whenever a never-list rule is touched or a new actor/surface appears — in the same issue cycle. |
| `PII-INVENTORY.md` | Every piece of personal data the project holds: field, where it lives, why, retention, deletion path, who can see it. The privacy policy is GENERATED from this — never the other way around. | Any change that collects/stores a new personal datum updates the inventory in the same cycle (the Security Engineer flags it if missing; the Data Architect's spec mode declares PII columns up front). |
| `CONTROLS.md` | Certification-readiness map: control → our practice → where the evidence lives. Seeded from ISO/IEC 27001:2022 Annex A themes (see § Certification below). | Updated when a mapped practice changes (e.g. a new gate, a new environment). |

## Proactive flow (how security enters the cycle, not beside it)

1. **Bootstrap**: security grill-me (BOOTSTRAP.md question 9) produces
   `THREAT-MODEL.md`; each never-list sentence becomes a PROCESS.md hard
   rule on day one — before the first table with user data exists.
2. **Grooming**: the PM's issue template carries a mandatory field —
   "touches auth / sensitive data / public surface?" If yes, the issue is
   born with the `security` label and the Security Engineer gate is
   AUTOMATIC, not someone's judgment call under deadline.
3. **Data design**: the Data Architect's spec mode declares which proposed
   columns are PII and who can read them — privacy enters at the model,
   not at the policy.
4. **While coding**: adopt Anthropic's official `security-guidance` plugin
   (3 layers: per-edit patterns, per-turn diff review, per-commit deep
   review) and the built-in `/security-review` where available — tooling
   complements the role gate, never replaces it.
5. **Pre-merge / pre-promotion**: the Security Engineer gate (role
   template) with the hybrid checklist below.
6. **Launch**: the launch module's Security section (RLS, server-side
   enforcement, exposed files, secrets, https, rate limits).

## Hybrid authz checklist (rigid core + frozen project extension)

A rigid-only list goes blind to project specifics; a questions-only
approach depends on whichever agent's judgment that day. The hybrid
freezes judgment once, then verifies mechanically:

- **Rigid core** (lives in the Security Engineer role template, applies to
  ANY project): every endpoint authenticated or public BY RECORDED
  DECISION · authz always server-side · IDOR tested per resource (swap the
  id and try — test, don't reason) · input validation on every write ·
  rate limits on writes and expensive calls · capability tokens
  unpredictable, constant-time compared, never logged · privileged actions
  leave a trail · state transitions that change visibility change
  authorization WITH them.
- **Generative questions** (once per project, at bootstrap or first
  audit): multi-tenancy? inherited/derived permissions? capability tokens
  and their blast radius if leaked? state machines that flip visibility?
  data hidden from some viewers but not others? admin surfaces? — Answers
  are FROZEN into `THREAT-MODEL.md` as the project's own checklist
  extension; from then on the extension is as rigid as the core. (Same
  pattern as the design module's genesis → fixed-system fork.)

## Certification-readiness (ISO 27001 / SOC 2) — honest scope

A certification is granted to an ORGANIZATION (an ISMS: policies, risk
management, internal audits, management review), not to a codebase. What
this module delivers is **certification-ready by construction**: when the
user decides to certify, the gap is paperwork, not re-engineering.

The key insight: this system already produces auditable evidence as a
byproduct — issues are the change log, `DECISIONS.md` is the risk-decision
record, role gates are the documented reviews, the PROCESS itself is the
secure-SDLC (ISO 27001:2022 Annex A controls 8.25-8.34). `CONTROLS.md`
just writes the mapping down. Seed structure:

| Control area (ISO 27001:2022 Annex A) | Our practice | Evidence |
|---|---|---|
| 5.x Organizational (policies, roles, threat intel) | PROCESS.md + role files + THREAT-MODEL.md | The files themselves, git history |
| 5.15-5.18 Access control / identity | Server-side authz hard rules, RLS day 1, least-privilege tokens | Security gate reports on issues, DB policies in migrations |
| 5.34 / 8.10-8.12 Privacy & PII, data deletion, DLP | PII-INVENTORY.md + deletion paths + secrets rules | The inventory, issue history of PII changes |
| 6.x People (awareness) | The agents ARE the workforce: rules live in role files, applied every dispatch | Role files + gate reports |
| 8.9 Configuration management | Env promotion discipline, env vars documented per environment | Change checklist, deploy history |
| 8.16 Monitoring | Error tracking + oncall verification (launch module § 5, platform role) | Oncall reports, tracker |
| 8.25-8.34 Secure development lifecycle | The entire issue cycle: spec → build → independent test → gates → merge discipline; separation of environments; test data rules | PROCESS.md + every issue's trail |
| 5.24-5.28 Incident management | Bug template with severity by user impact, root cause on close, regression test rule | Bug issues (structured, queryable) |

Seed the full 93-control mapping when certification becomes a real goal —
existing GRC skill collections (see § Sources) carry complete control
lists worth consulting at that point; the table above keeps the map honest
meanwhile (unmapped = a known gap, listed at the bottom of CONTROLS.md).

## Tooling adoptions (per project)

- **`security-guidance`** — Anthropic official plugin
  (`/plugin install security-guidance@claude-plugins-official`): adopt by
  default. Assistive, not a SAST replacement.
- **Stack-specific pentest/audit skills** (e.g. a Supabase RLS/IDOR
  audit collection for Supabase projects): give the Security Engineer
  executable ammunition — ALWAYS review third-party skill content before
  installing (house rule; they are instructions for your agents).
- Built-in `/security-review` when the session offers it.

## Sources (reviewed 2026-07; mined with attribution, not copied)

- Anthropic `security-guidance` plugin and `claude-code-security-review`.
- Trail of Bits `skills` (CC BY-SA 4.0) — `differential-review` and
  `insecure-defaults` informed the change-checklist and core items.
- PostHog `security-audit` skill — the "confirm exploitability before
  reporting" discipline.
- GRC skill collections (Scytale, community ISO/SOC2 packs) — control
  enumerations for seeding CONTROLS.md when certifying.
- `yoanbernabeu/supabase-pentest-skills` (MIT) — candidate stack-specific
  adoption for Supabase projects.
