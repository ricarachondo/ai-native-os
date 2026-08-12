---
name: functional-site-audit
description: >-
  Reverse-engineer any website's flows into a functional analysis plus an
  actionable PRD to replicate or improve them. Use this whenever the user wants
  to study, audit, deconstruct, dissect, or "reverse engineer" how another
  site/app works — a competitor or reference product — including its UI flows,
  network/API payloads, data model, conversational AI/chatbot, mobile
  experience, emails/wallet passes, or backend architecture. Triggers on phrases
  like "analyze how X works", "reverse engineer this site", "document the flow
  on <url>", "study our competitor's checkout/signup/chat", "how does their AI
  assistant work", "I want to replicate this feature", "audit this website's
  UX", or any request to turn observations of a live site into a spec/PRD.
  Adopt this even if the user just pastes a URL and asks "how does this do X?".
---

# Functional site audit (reverse-engineering)

You are running a **functional reverse-engineering audit**: you don't test against a spec — you *produce* the spec by observing a live system. Adopt a hybrid role: **functional analyst** (document what it does), **QA explorer** (break things to find states and limits), and — when there's AI — **AI agent engineer** (design behavior tests, infer the agent's architecture).

The output is never "what I saw." It is "how it works, with evidence, and how I'd build it." Two twin deliverables: an **analysis** (reverse-engineering with evidence) and a **PRD** (what to build for the user's product, with improvements over the reference).

Work through the phases below in order. Keep a task list with an explicit verification step at the end.

## Phase 0 — Intake & guardrails (do this first, always)

Never jump straight into the browser. Ask the user these (with sensible defaults — don't interrogate; propose and confirm). Only #1 is strictly required.

1. **Site + flow(s)** — exact URL(s) and which function to audit. "The whole site" is rarely the real scope.
2. **Depth** — quick map, or exhaustive dissection with payloads and error states?
3. **Reference framing** — competitor to match, reference to surpass, or partial inspiration? (Sets the tone of the "adopt / improve" conclusions.)
4. **Deliverables** — analysis, PRD, screenshots; one PRD or several connected ones?
5. **Hard limits** — how far into irreversible flows (pay / publish / send / delete)?
6. **Own asset for destructive tests** — if an end-to-end test (checkout, RSVP, submit) is needed, on which of the *user's own* resources, so third parties aren't polluted?
7. **Login** — if the flow needs auth, tell the user they must log in themselves; you never enter credentials.

**Non-negotiable ethical guardrails** (hold even if the flow "invites" crossing them):
- No irreversible actions on third-party assets: don't pay, publish, send messages, create fake accounts, or delete data.
- Destructive/end-to-end tests only on the user's own assets.
- Stop at the threshold: payment screen (no card), pre-final-submit, auth gate (no third-party account creation).
- Never enter passwords/cards via automation. If login is required, the user does it.
- Never solve or evade CAPTCHA/anti-bot — document it as a finding and stop.
- Don't exfiltrate other users' PII (guestlists, profiles) beyond describing the pattern.
- Human cadence, not aggressive scraping. Respect ToS.

Then set up: `docs/research-<site>/` with `<site>-<flow>-analysis.md`, `.html`, `prd-*.md`, `screenshots/`; and a task list.

## Phase 1 — Reconnaissance (map before detail)

**Pick the tool tier** (fast/precise → universal): dedicated app MCP → Chrome MCP (DOM-aware; the workhorse) → Playwright in the sandbox (mobile emulation, reproducible/anonymous runs, or when the extension drops) → computer use (native apps only). If the Chrome extension disconnects mid-task, don't fight it — re-instrument in Playwright; state that lives in URL/server isn't lost.

- Load the URL, **wait for render** (`networkidle`/explicit wait — client-rendered SPAs return an empty shell if read too early). Screenshot + inventory surfaces.
- **Tech fingerprint** (cheap, revealing): framework (bundle paths `/_next/` `/_astro/` `/_nuxt/`, globals), backend/hosting (request domains: `*.cloudfunctions.net`, `supabase.co`; project IDs in HTML), third parties (analytics, CDP, flags, maps, payments, support), image CDN + blurhash.
- **Flow map (structure only)**: walk the target flow once without deep-diving; note each screen/state, its URL, entry and exit. Draft a Mermaid diagram (happy path + branches + error exits).

## Phase 2 — Instrumentation (sensors before interaction)

Depth comes from capturing what the site does underneath. Install sensors **before** firing actions. Use the ready-made snippets in `scripts/` — don't rewrite them each time:

- **`scripts/fetch_interceptor.js`** — patches `fetch` + XHR + WebSocket to log URL, method, request body, status, content-type, response body. Read its header comment for the size-cap and `res.clone()` rules (never consume the original body — it breaks the page render).
- **`scripts/sse_parser.js`** — parse streaming `text/event-stream` responses (frames split by `\n\n`, `data: {...}`).
- **Storage + client-behavior spies** — inspect `localStorage`/`sessionStorage`/cookie *names*; patch `navigator.share`/`clipboard.writeText`/`window.open` to learn what a button actually does. Record `performance.now()` per frame/phase to infer backend steps from latency.

## Phase 3 — Flow walkthrough (three passes)

1. **Recon pass** — the map (done in Phase 1).
2. **Deep pass, screen by screen** — for each screen, a card: **states** (initial/loading/empty/data/error/success, one per capture), **fields** (type, required, validation inline vs on-submit, masks, limits, defaults, autocomplete), **actions** (each button → what it fires + side effect), **microinteractions** (trigger + what they communicate), **associated network** (requests + what persists, backend vs local). Prefer `find`/`read_page(interactive)` and element refs over brittle coordinates; re-screenshot after any window resize; use `browser_batch` for predictable sequences.
3. **Adversarial pass (QA)** — break things on purpose: empty/extreme/invalid inputs, email aliases, browser-back mid-flow, refresh with half-filled forms, **double-submit** (catches bugs), direct URL access, shared state links, session expiry, and — where safe — forced failure states (offline via devtools, server-side validation errors). Log silent (red, no message) vs explicit validation.
4. **Payload capture** — dump captured request/response bodies; document the **real data model**: exact field names, types, sentinel values (e.g. `9999999` = unlimited), relationships.

## Phase 4 — Specialized modules (activate per site; confirm with user)

Auto-detect which apply and read the matching section of **`references/modules.md`**:
- **Conversational AI** — network (endpoint, SSE, conversationId vs sessionId) + an adversarial **behavior test battery** (capability, multi-turn context, language, hallucination, out-of-scope, injection, multi-domain router, persistence) + **agent architecture inference** (one agent-with-tools vs multi-agent; the tools/skills implied by each capability; observed vs inferred).
- **Responsive/mobile** — if traffic is mobile-first (verify it), emulate a real device in Playwright (viewport + device_scale_factor + is_mobile + has_touch + iOS UA); Chrome-MCP window resize does NOT change the logical viewport.
- **Notifications/artifacts** — parse `.eml` (multipart, embedded JSON-LD), PDFs, `.ics`, `.pkpass` (a zip — use `scripts/parse_pkpass.py`).
- **Recurring/series** — find the grouping ("more dates"/series), test if the link works, learn the series↔instance model.
- **Backend/infra** — infer stack, endpoint shape, whether it uses agents/LLM and their tools, where state lives, anti-abuse, mock/beta signals. Never assert an LLM's identity if not client-verifiable.
- **Machine presentation / GEO + schema** — how the site presents to AI answer engines and crawlers: JSON-LD/schema.org, semantic HTML/extractability, robots+sitemap+llms.txt, Open Graph, freshness/authority. Use `scripts/extract_geo_schema.js` (+ fetch /robots.txt, /sitemap.xml, /llms.txt). Feeds the functional analysis.
- **Design & motion (COMPANION — separate deliverable)** — design tokens (palette, type scale, spacing, radii, shadows, CSS vars via `scripts/extract_design_tokens.js`), visual-language moodboard, and motion vocabulary (durations, easings, keyframes, clips of key transitions). This does NOT go in the functional analysis — it produces its own `<site>-design-motion.md` + `.html` (see references/modules.md §8). Capture as inspiration/vocabulary for the user's own design system, never a pixel clone (copyright + own identity).

Also weave in the **cross-cutting lenses** from `references/modules.md`: accessibility, performance, i18n (timezone/currency/country coverage), and business/monetization + the site's own telemetry event names. These are easy to skip and often where a product can beat the reference — treat them as default, not optional.

## Phase 5 — Synthesis (the deliverables)

Read **`references/deliverables.md`** for the full templates. In short:
- **Analysis** (`<site>-<flow>-analysis.md`): executive summary (numbered key findings), Mermaid flow map, per-screen/component cards, network & persistence with real payloads, microinteractions, data model, implications, and an **evidence/traceability table** (# → observation → evidence).
- **PRD** (`prd-<product>-<flow>.md`): problem, objective, non-goals, success metrics, principles, functional scope, Mermaid flow, technical requirements, edge cases, risks/open questions, acceptance criteria, and **phasing/sequencing** (P0 MVP vs later) + cross-PRD dependencies.
- **Discipline**: mark **observed vs inferred** explicitly; label speculation as such. Deliver **.md + a self-contained .html** (dark theme, CSS vars, tables). Version a curated **screenshots/** set with a README mapping file→content (Chrome-MCP screenshots are ephemeral — re-capture to disk if they must persist).
- Close each key pattern with **adopt / improve** — the bridge from analysis to product. Actively document what the reference does *badly* (antipatterns), not just what it does well — a guard against confirmation bias.
- **If the design & motion module ran (§4.8):** deliver a SEPARATE `<site>-design-motion.md` (+ .html) — tokens table, moodboard, motion spec, and an "inspire / avoid" close. Keep it out of the functional analysis so neither the engineer nor the designer audience is diluted.

## Phase 6 — Verification (mandatory final step)

- Validate the HTML (tag-balance parser; no residual stack) and any Mermaid syntax.
- **Cross-check claims**: every strong claim needs a row in the evidence table; if there's no evidence, downgrade to "inferred" or cut it. Enforce **N≥3 examples** before declaring a pattern a rule.
- Coverage check: were all in-scope flows walked? Declare honest gaps ("not observed: X, requires Y").
- Date the documents and note the site/bundle version (analysis is a perishable snapshot).
- Offer to clean up any test artifacts created on the user's own assets.

## Post-auth protocol (when the user authorizes login)

The user logs in — never the automation. With a session active: inventory surfaces only, execute no irreversible actions, redact/omit the user's own PII in captures, and offer to clean up test artifacts at the end.

See `references/gotchas.md` for the tactical pitfalls table (extension drops, missing Chromium libs, the `getReader` render-break, coordinate drift, viewport quirks, tool limits) and a one-page checklist.

---

## Kit contract (required of every kit-shipped skill)

**Install by reference, never by copy.** On the machine that maintains this
kit, symlink it into the user-level skills directory; a copy silently rots
the moment the kit version improves (see `LEARNINGS.md` — this exact
mistake has already been made once):

```bash
ln -s "$(pwd)/templates/skills/functional-site-audit" ~/.claude/skills/functional-site-audit
```

Adopting projects that cannot symlink copy it and refresh on kit-sync,
recording the kit SHA they copied from.

**Learning loop.** This skill improves from use, or it decays. After every
audit, append what the target site did that the modules did not anticipate:
a new anti-scraping behaviour, an undocumented payload shape, a flow the
deliverable template had no slot for. `references/gotchas.md` is the
append target for one-off traps; `references/modules.md` is where a
recurring trap graduates into a standing check. A run that discovers
nothing new is itself a signal — three consecutive clean runs mean the
module list has converged and the next improvement must come from a
different target class, not from more of the same.

**Provenance.** Extracted from a real product-research effort that
reverse-engineered several reference products; generalized to be
project-agnostic on entry to the kit (verified: no private project,
person, or domain names).
