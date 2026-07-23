# Launch-readiness module — plug and play

> Self-contained module: a pre-launch gate ritual + a Platform Engineer role
> that owns backend/infra reliability. Origin: a detailed review (2026-07)
> of ["The 37 Pre-Launch Checks"](https://nicoburkart.notion.site/e6e88fff5ddf48a09248e2c8368445d1)
> by Nico Burkart (adapted with credit — see § Credits in the kit README),
> plus a real incident in one of the user's projects (timeouts and
> processing failures in production-bound work) that the guide does NOT
> cover and this module adds (§ 8).

## What this module adds

1. **A launch-readiness checklist** (7 sections from the guide + 1 of our
   own) with three priorities: 🔴 **blocker** (do not launch without it),
   🟡 **first week**, 🟢 **nice to have**.
2. **A gate ritual**: before ANY public launch (first launch or a major
   surface going public), the orchestrator runs the checklist as a batch —
   each item dispatched to the role that owns it (§ Ownership), results
   collected in `docs/launch/READINESS.md` in the project, blockers must
   pass, first-week items are filed as issues with the `P1` label at that
   moment (per the "file it now" hard rule).
3. **A Platform Engineer role** (`../agents/platform-engineer.md`) that
   owns the items no existing role covered — plus backend reliability as a
   standing concern, not only at launch.

## The checklist (adapted, project-agnostic)

Where the guide names a concrete tool, it is kept as a suggestion (they are
free and good), not a requirement. Wording is generalized: "payment
provider" instead of a brand, "DB row security" for any backend.

### 1 · Security

| Check | Priority | How |
|---|---|---|
| Row-level security / server-side authorization ON for every table with user data | 🔴 | Query as anonymous + as a second user; every unprotected table is a breach on day one. (The guide's real example: 1.5M API keys leaked from one app with RLS off.) |
| Login and paywall enforced on the SERVER | 🔴 | For every premium/authed API route: does it verify the caller server-side, or only hide the button? Frontend checks are UX, not security. |
| `yourapp.com/.env` (and `.env.local`, `.env.production`, `.git/config`) show errors, never contents | 🔴 | 60-second browser check. If anything shows: rotate every key TODAY (bots scan new domains within hours), then fix build/host config. |
| No secret keys in the client bundle | 🔴 | View-source search for `sk-`/`sk_live`; audit every `NEXT_PUBLIC_`/`VITE_`/`PUBLIC_` env var. Public-by-design keys (payment publishable key, DB anon key) are fine; server secrets never. |
| HTTPS forced on all 4 URL variants (http/https × www/bare) | 🟡 | All must land on the same https page; certificate grade A on ssllabs.com/ssltest. Hosts handle the cert, often NOT the www redirect. |
| Rate-limit expensive endpoints (LLM calls, email sends, paid APIs) | 🟡 | Per user AND per IP. An open AI endpoint is someone else spending your API budget overnight. |

### 2 · Email deliverability

| Check | Priority | How |
|---|---|---|
| SPF, DKIM, DMARC configured | 🔴 | All three green at dmarcian.com/domain-checker (or the sending service's domain dashboard). DMARC `p=quarantine` minimum — `p=none` only monitors. |
| Transactional emails EXIST: welcome/confirm, password reset, receipt if charging | 🔴 | The forgotten one is always password reset — and it's the one that locks users out. Check the flow exists, sends, and its links work. |
| Signup email lands in inbox on Gmail AND Outlook | 🔴 | They filter very differently; Outlook-in-spam is invisible churn. Deliverability is infra (records + sending service), almost never the email copy. |
| App emails sent from a subdomain (`mail.`) | 🔴 | Reputation isolation: if automated mail gets flagged, the main domain (and the human's own address) stays clean. Marketing mail gets ITS own subdomain too. |
| Score 9+/10 on mail-tester.com | 🟢 | Free 2-minute second opinion that lists exactly what to fix. |

### 3 · Findability

| Check | Priority | How |
|---|---|---|
| OG preview image + title render when the link is shared | 🔴 | Test in a real messenger + opengraph.xyz. Platforms CACHE previews — a broken one sticks after the fix, so get it right before the first share. |
| Sitemap submitted to Google Search Console | 🟡 | Faster indexing + free dashboard of crawl errors. Sitemap must contain the real domain, not staging. |
| Not accidentally blocking search engines | 🟡 | `site:` search + robots.txt + `noindex` metas + `X-Robots-Tag` headers. Trap: some hosts noindex non-production deployments via an invisible HEADER — verify the domain sits on the production deployment. |
| Every public page has a unique real title + meta description | 🟡 | Not the framework default. Title 50-60 chars, description 140-155. |
| No localhost / staging / preview-URL leftovers in the live site | 🟡 | View-source + sitemap search for `localhost`, preview domains, old dev domains. A canonical tag pointing at staging tells Google to index the wrong site. |
| App on a subdomain, marketing on the main domain | 🟢 | Two deployments joined by a login button: homepage iterates without redeploying the app; splitting LATER breaks bookmarks and OAuth redirects. |
| robots.txt (and optionally llms.txt) present | 🟢 | Allow by default, disallow private routes, point to the sitemap. |

### 4 · Speed

| Check | Priority | How |
|---|---|---|
| PageSpeed Insights mobile score reviewed | 🔴 | <50: fix before launch. 50-89: fix the biggest item, launch anyway. 90+: move on. It's almost always the images. |
| Images compressed (WebP, sized to display size) | 🟡 | squoosh.app or `cwebp` via CLI. Nothing over ~1 MB. |
| No layout shift while loading | 🟡 | Explicit width/height on images, reserved space for late-loading elements. Test on a phone with wifi off. |
| Unused third-party scripts removed | 🟢 | Every widget "just in case" costs load time. One analytics tool, nothing you can't name a reason for. |

### 5 · Analytics & observability

| Check | Priority | How |
|---|---|---|
| Analytics installed AND verified firing on the LIVE domain | 🔴 | Incognito visit → see yourself in the real-time view. Launch traffic happens once; there is no measuring yesterday. |
| Web vitals collected from day one | 🟡 | LCP <2.5s, INP <200ms, CLS <0.1 — from real users' devices, not the lab. |
| Basic bot protection on public forms | 🟡 | Invisible challenge (e.g. Turnstile), validated server-side. Warning from the guide: aggressive bot-blocking modes also block AI crawlers (ChatGPT/Perplexity citations). |
| At least one conversion funnel defined | 🟡 | Land → click signup → account → core feature. Turns "launch went meh" into "84% dropped at the form". |
| Error tracking on (frontend + backend, with source maps) | 🟡 | Throw a test error, see it in the dashboard. Most users never report bugs — they leave. |
| Session recordings, only behind consent, inputs masked | 🟢 | Qualitative complement to the funnel. Never before consent for EU traffic. |

### 6 · Legal

| Check | Priority | How |
|---|---|---|
| ToS + Privacy Policy published and linked in the footer | 🔴 | ToS needs: fulfillment policy, refund policy, limitation of liability, warranty disclaimer. Privacy: what data, why, retention, deletion path (GDPR/CCPA core). Payment processors require these to approve you. |
| Merchant of record decided consciously | 🟡 | Plain payment-gateway integration = YOU report VAT/sales tax in every customer country. MoR services take a higher fee and that problem. Decide on day one — retrofitting is back payments. |
| Cookie/consent banner if tracking uses cookies | 🟡 | Consent BEFORE tracking starts for EU visitors; on reject, cookieless/anonymous mode. |

### 7 · Final manual test

| Check | Priority | How |
|---|---|---|
| Payment webhooks tested in LIVE mode with real money | 🔴 | Test and live are two different configurations (keys, endpoints, prices). Buy your own product, verify the webhook delivered 200 and the app reacted; refund yourself. The root cause of chronically broken webhooks is the payment-state "split brain" — read t3dotgg's stripe-recommendations. |
| Core flow walked on a real phone, incognito, fresh account | 🔴 | Land → sign up → reach the core value → pay if charging. That is how every stranger experiences launch day; you always test logged-in on a laptop. |
| Tested in the second browser (Safari↔Chrome), desktop + mobile | 🔴 | Forms, dates, and payments render differently. Every iPhone is Safari. |
| Every link and button clicked | 🟡 | No dead ends, no `#` placeholders, no 404 in the footer. |
| Forms abused: empty submit, wrong types, double-click | 🟡 | Helpful inline errors; submit disabled while running (double-click = double charge). |
| 404 page friendly and returning a real 404 status | 🟢 | httpstatus.io must say 404, not 200. |

### 8 · Processing reliability (OUR addition — not in the guide)

Born from a real incident (timeouts and processing failures in a project on
this system). The guide covers launch-day readiness; it does NOT cover the
class of failure where the app is up but its WORK dies quietly:

| Check | Priority | How |
|---|---|---|
| Every external call has an explicit timeout and a decided failure behavior | 🔴 | No default-infinity fetches. For each integration: what happens when it hangs — retry, degrade, or surface? "Whatever the library does" is not a decision. |
| Long-running work is not inside a request/response cycle | 🔴 | Anything that can exceed the platform's request budget (serverless limits!) moves to a background job / queue / scheduled function with persisted state. |
| Retries are bounded AND idempotent | 🟡 | A retried job that double-writes is worse than a failed one. Idempotency keys or upserts on every retryable write. |
| Failure visibility: a dead job is SEEN | 🟡 | Dead-letter state + error tracking on background work, not only on user-facing routes. A silent failed queue is data loss on a delay. |
| Known platform limits written down | 🟡 | Request timeout, body size, connection pool, function memory — in `docs/database/architecture.md` § operational constraints or equivalent. You can't design around limits nobody wrote down. |

## Ownership (who runs what)

| Section | Owner |
|---|---|
| 1 · Security | Security role if the project has one; else Platform Engineer |
| 2 · Email, 3 · Findability, 4 · Speed (infra half), 5 · Analytics, 8 · Processing reliability | **Platform Engineer** |
| 4 · Speed (layout-shift/UX half) | Designer or SWE |
| 6 · Legal | Orchestrator prepares, the USER approves (legal text is never shipped without the user's explicit ok) |
| 7 · Final test | Tester (it is their existing independent-verification job, on the live surface) |

The orchestrator dispatches the batch, collects results in
`docs/launch/READINESS.md` (one row per check: status, evidence, date), and
presents blockers-not-passing to the user as a numbered batch. The gate
repeats (delta-only) for every later major public surface.

## The Platform Engineer role — why, and why not "Backend Engineer"

The SWE already writes backend code; a "backend engineer" would duplicate
it (same reason the 5-role design team was rejected). What no role owned is
the **platform around the code**: delivery infrastructure (DNS, email
records, certificates), operational reliability (timeouts, rate limits,
queues, observability), and launch readiness. That is the Platform
Engineer: audit/spec only, never implements product code — findings become
issues the SWE builds. Two modes, mirroring the Designer and Data
Architect: **reliability audit** (standing, § 8 + §§ 1-5 infra) and
**launch gate** (runs its sections of the checklist when the orchestrator
triggers the ritual). Template: `../agents/platform-engineer.md`.

## Honest mapping (what the guide adds vs. what this system already had)

Already institutionalized before this module: RLS-on-day-1 (hard rule),
independent Tester verification, oncall verifying the real deploy, secrets
never in chat/files, feedback-per-action grooming rule. The guide's real
additions: email deliverability as infra (SPF/DKIM/DMARC, subdomain
isolation), findability hygiene (OG cache trap, host noindex-header trap),
analytics-verified-before-launch, merchant-of-record awareness, and the
discipline of a single gate ritual. Section 8 is ours.
