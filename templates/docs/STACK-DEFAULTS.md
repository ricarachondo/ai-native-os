# Stack defaults for early stage (bootstrap decision support)

> Referenced from BOOTSTRAP's stack question. For projects arriving WITHOUT
> a decided stack: sane defaults with the condition to deviate — principles
> over brands, because principles age well. Adapted with credit from a
> public "15 tech stack decisions" explainer (see kit README § Credits) and
> validated against this system's own source projects (which independently
> made 13/15 of these calls). A project that already decided keeps its
> decisions — this chapter is for the blank-slate case.

| # | Decision | Default | Deviate when |
|---|---|---|---|
| 1 | Architecture | **Monolith first** — one deployable app | Split into services only when it HURTS (team contention, independent scaling needs proven by metrics) |
| 2 | Database | **Relational (Postgres-family)** — strong consistency, row security | Your data is genuinely document/graph shaped AND scale justifies it |
| 3 | Infrastructure | **Managed cloud** — buy undifferentiated ops | Compliance or cost AT REAL SCALE forces self-hosting |
| 4 | Compute | **Serverless/zero-ops** — pay per use | Traffic patterns are sustained and predictable enough that containers win on cost/control — and know the platform limits either way (this kit's processing-reliability section) |
| 5 | Build vs buy | **Buy anything that isn't your core product** (payments, auth, email, observability). Applies at FEATURE level too: before hand-rolling a slider/parser/picker, the SWE walks the reuse ladder (internal → stack → library → custom) — see the SWE role template | Only build what IS your differentiator |
| 6 | API style | **Simple resource-based (REST-ish)** — cacheable, well understood | Real client flexibility needs demand more (many heterogeneous consumers) |
| 7 | Mobile | **Cross-platform, one codebase** | You need native-only capabilities or peak performance AND can afford ~2x the team |
| 8 | Repos | **Monorepo** — one change touches everything atomically | Team size/independence forces a split |
| 9 | Language | **Typed by default** (e.g. TypeScript over JavaScript) — upfront friction beats runtime bugs | Rarely; prototypes you will truly throw away |
| 10 | Cloud provider | **Pick ONE and commit** — deeper platform expertise | Multi-cloud is a scale/compliance problem, not a day-one virtue |
| 11 | CI/CD | See the launch module's conditional CI/CD chapter — this kit's agent flow already provides gate guarantees; minimum automation adopts at the FIRST cue | — |
| 12 | Auth | **Buy it** — security is one of the worst places to learn by doing | Practically never for early stage |
| 13 | Rendering | **Match to how dynamic the content is** — static where static, server-rendered where personalized | Follow the content, not the trend |
| 14 | Async infra | **No message queue until you have async problems** — background jobs ≠ queue infrastructure (see processing-reliability § 8: long work still leaves the request cycle) | Real decoupling needs with measured volume |
| 15 | Observability | **Buy visibility** (managed error tracking/monitoring) | The bill outweighs the engineering cost — a scale problem |

## Constrained dev hardware (portable note)

On small dev machines (8GB-class), local container stacks are **on-demand,
never standing**: started for the phases that need them (build, E2E),
stopped when the cycle closes — a permanently-running container VM
degrades the whole machine and its silent shutdown breaks the QA gate
without looking like a product bug. Prefer container runtimes that release
memory dynamically over fixed-reservation VMs, and trim the local stack to
the services actually used. The structural exit is a cloud test
environment the E2E suite can target (never a de-facto-production one). Full lifecycle policy (active/paused/finished states, what's genuinely irrecoverable vs merely costly, the reproducibility-before-deletion rule): `GUARDRAILS.md` § 2b.

## Web AND mobile excellence (hard principle, applies to EVERY project)

Every project is designed to serve **both web and mobile with excellence**
— this is not a platform choice, it is a quality bar. Declare the PRIMARY
viewport from real usage (a project where 80% of traffic is mobile
browsers is mobile-first, even if built as a web app), design and test
that one first — and NEVER abandon the other: organic arrivals come from
desktop search, shares open on every device. "We'll fix desktop later" is
carry-over born pre-aged. The Designer's audit checklist and the Tester's
cross-browser/final checks enforce both surfaces; grooming declares the
primary viewport per surface when it differs from the project default.
