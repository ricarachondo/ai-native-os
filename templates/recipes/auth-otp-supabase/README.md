# Recipe: Email OTP auth — Supabase + Next.js (App Router) + @supabase/ssr

> **Recipes are a distinct kit class**: plug-and-play IMPLEMENTATION
> knowledge, stack-tagged (this one: Supabase Auth + Next.js + Resend-class
> SMTP), distilled from a REAL project's build including an adversarial
> security gate — not from documentation reading. Portable across projects
> on the same stack; a different stack skips it. Update rule: any project
> using a recipe that learns something new promotes it back here in the
> same cycle (standard improvement loop).
> **Validation: ✅ first-party** — built, security-gated, and covered by
> ~30 E2E scenarios against the real local stack in the source project.

## The flow (typed 6-digit code, no magic link)

```
[login page: email] → signInWithOtp({email, options:{shouldCreateUser}})
[login page: code]  → verifyOtp({email, token, type: "email"})
                    → window.location.assign(POST_LOGIN_PATH)   ← full navigation, NOT router.push
[middleware]        → updateSession() → getUser() → route decision (onboarding vs app)
[every server action / route handler] → auth.getUser() AGAIN (two-layer defense)
```

**Three Supabase clients, one per context** (the load-bearing structure):

| Client | File | Context | Notes |
|---|---|---|---|
| Browser | `lib/supabase/client.ts` (`createBrowserClient`) | Client components | Requests the OTP, verifies it |
| Server | `lib/supabase/server.ts` (`createServerClient` + `cookies()`) | Server components/actions/handlers | `setAll` wrapped in silent try/catch — a server component cannot write cookies; the MIDDLEWARE is the real refresher |
| Service | `lib/supabase/service.ts` (`SUPABASE_SERVICE_ROLE_KEY`, `persistSession:false`) | Server-only privileged paths | NEVER imported from client code — known gap: this boundary is comment-enforced only; add a lint rule if your tooling allows |

**Middleware pattern** (the official `@supabase/ssr` shape, deviations break
token refresh): create client → `getUser()` with NO logic in between →
propagate cookies onto the `NextResponse`. Route logic: no session +
protected route → `/login` · session + incomplete profile → forced
onboarding · session on `/login` → app. Keep the "which routes need a
session" list in CODE (unit-testable) separate from the Next matcher, and
exclude webhook/cron routes (they carry their own fail-closed auth).

**Why full navigation after `verifyOtp`**: `router.push` would decide the
destination client-side before the middleware ever re-runs with the fresh
cookie — `window.location.assign` forces the server to make the
onboarding-vs-app decision. Deliberate, not legacy.

## Decisions every project makes explicitly (don't inherit them blind)

1. **Typed code vs clickable link**: this recipe is 100% typed code —
   there is NO `?code=` callback route. If you choose links instead, you
   must build that entire callback path; the default Supabase email sends
   a link that would dead-end.
2. **`shouldCreateUser: true` (open signup)** merges signup+login into one
   flow — and creates a THREAT-MODEL consequence: accounts are free, so
   "requires session" is NOT an anti-enumeration control by itself; any
   authenticated endpoint answering about other people's data needs its
   own rate limit.
3. **Production SMTP deferral is viable** behind a perimeter lock (Basic
   Auth in front of everything including /login) while the only user is
   the owner — but see the free-tier trap below before promising cloud
   login.

## Traps (each one cost something real)

1. **Supabase free tier + custom email template = atomic `config push`
   failure.** The default mailer forbids custom templates; the push fails
   ENTIRELY (400) — so your valid `site_url`, redirect URLs, rate limits
   and `otp_expiry` ALSO don't apply. Check whether the project uses the
   default mailer BEFORE promising "push auth config to cloud" as a step;
   custom templates require your own SMTP (Resend-class) first.
2. **A client-writable `email` column on the profile table is an
   attacker-controlled mail relay.** Found adversarially: table-wide
   `GRANT ... TO authenticated` left `profiles.email` PATCH-able → a user
   could set a VICTIM's email and have your future notifications phish on
   your infrastructure. Fix that verifies by BEHAVIOR: a
   `BEFORE INSERT OR UPDATE` `SECURITY DEFINER` trigger re-syncing
   `profiles.email` from `auth.users.email` always. Column-level `REVOKE`
   is a no-op while the table-wide grant stands.
3. **App-layer-only validation is enumerable/bypassable via PostgREST.**
   Reserved usernames and format rules enforced only in app code were
   reproduced (201) with a direct API insert. Mirror them as DB `CHECK`
   constraints, and add a drift test importing the app's reserved list so
   an app-side change without the migration fails CI by itself. Meta-rule:
   debt DECLARED in writing ("validation lives in the app layer") files an
   issue at that moment — a note in a migration gets rediscovered by an
   attacker, not by the team.
4. **Local-only rate limits get copy-pasted to production.** E2E needs
   raised auth rate limits (email_sent/sign-ups/verifications in the
   hundreds); production must keep Supabase's conservative defaults. Keep
   the raised values marked LOCAL-ONLY in `config.toml` comments, and
   never push that file's rate section to cloud as-is.
5. **The resend-cooldown in the UI is UX, not a control.** Match it to
   Supabase's real server-side limit (60s), make it env-overridable
   (e.g. 5s) so E2E doesn't crawl — and remember the real anti-spam
   control is Supabase's `[auth.rate_limit]`, never the button state.
6. **Concurrent unique-claim (username/handle) resolves at the DB.** A
   unique index on `lower(handle)` + explicit `23505` catch translated to
   a friendly message — two simultaneous claims, exactly one wins. Never
   check-then-insert.

## E2E recipe (no mocks — real local stack)

- **Mailbox capture via Mailpit** (ships with the Supabase local stack,
  `[local_smtp]` enabled): poll `GET /api/v1/search?query=to:"<email>"`
  for the Nth message, extract the code with `\b(\d{6})\b` over
  Text+HTML. Every scenario runs against real Postgres+Auth+Mailpit.
- **Hydration race**: filling inputs pre-hydration desyncs controlled
  React state (a real bug found this way — a check that never fired).
  Expose an imperative `data-hydrated="true"` marker (set via ref, no
  re-render) and make E2E wait for it before typing.
- **Next.js + Playwright trap**: don't select errors by
  `getByRole("alert")` — Next's route announcer also exposes
  `role=alert` (strict-mode violation). Use text queries for inline
  feedback.

## Reproducible config (names only, never values)

`supabase/config.toml` § auth: `otp_length = 6` · `otp_expiry = 3600` ·
`max_frequency = "1s"` · `enable_confirmations = false` (OTP replaces it)
· `enable_anonymous_sign_ins = false` · refresh-token rotation on · custom
template at `supabase/templates/otp.html` showing `{{ .Token }}` big, with
its expiry stated (note: it configures the `magic_link` template slot even
for typed-code flows) · `[local_smtp]` enabled for Mailpit.
Env vars: the standard Supabase trio + a public cooldown override
(`*_OTP_RESEND_COOLDOWN_S`-style). Production adds the SMTP provider's
vars when it lands — plus the launch module's email section
(SPF/DKIM/DMARC, sending subdomain) which this recipe defers to.

## Known gaps in the source implementation (inherit knowingly)

- Service-client import boundary enforced by comment only (no lint rule).
- The session-gated username-availability endpoint still lacks its own
  rate limit (the reusable DB rate-limit function exists but isn't wired
  there) — open issue in the source project; wire it if you inherit the
  open-signup decision.
