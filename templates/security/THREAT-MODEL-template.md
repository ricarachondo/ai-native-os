# Threat model — {{PROJECT}}

> ONE page. Born from the bootstrap security grill-me (question 9). Each
> never-list sentence becomes a hard rule in `docs/PROCESS.md` on day one.
> Reviewed whenever a never-list rule is touched or a new actor/surface
> appears — in the same issue cycle. Doubles as the risk-register-lite.

## Sensitive data the project holds

- **PII**: {{fields — emails, names, locations…}}
- **Business-sensitive**: {{pricing, private analytics, drafts…}}
- **Platform secrets**: {{service roles, third-party tokens}}

## Actors

| Actor | Legitimate access |
|---|---|
| {{End user}} | {{only THEIR data — enforcement mechanism, e.g. RLS owner}} |
| {{Anonymous visitor}} | {{public surfaces + allowed writes, rate-limited}} |
| {{System processes}} | {{crons/webhooks, service role, server-side only}} |
| Malicious external | None of the above — see never list |

## Never list (hard rules — 3-5 plain sentences)

1. {{An external must never be able to …}}
2. {{…}}
3. {{…}}

## Frozen authz extension (project-specific checklist)

> Answers to the generative questions (multi-tenancy? inherited
> permissions? capability tokens and blast radius? state machines that
> flip visibility? admin surfaces?) — frozen here once, then verified as
> mechanically as the rigid core in the Security Engineer role.

- {{e.g. "capability token X only opens surface Y, leaks nothing else"}}

## Mitigations / architecture decisions already made

- {{decision → threat it mitigates, with doc reference}}

## Accepted, visible risks

- {{e.g. local dotfiles carry secrets that cannot move to the keychain}}

## Pending

- `PII-INVENTORY.md` — created with the first issue persisting personal data.
- `CONTROLS.md` — created when there is practice to map to evidence.
