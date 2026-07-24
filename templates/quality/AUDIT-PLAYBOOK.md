# Audit playbook — reusable review checklist for any project

A backward-looking review discipline distilled from real audits run
end-to-end. Use it two ways:

1. **Periodic sweep** — when the product is "functionally done" and you want
   to find what feature work never looked at (gaps live in the assumptions
   nobody questioned, not where the work was focused).
2. **Continuous rituals** — some passes run every Sprint Close (security),
   others on a cadence or before a launch gate.

Each audit produces **tracked issues**, and every finding is tagged
**fix-now** (objective correctness — do it) vs **decision** (design / infra
/ cost / product — document and wait for the owner). Never silently fix
outside a finding's scope; never silently defer a fix behind a "decision"
label to avoid work.

---

## Ground rules (learned the hard way)

- **Verify before you assert.** A finding about a component is not real
  until you've read its caller / the data that reaches it. A confident
  "this is always broken" claim that turns out false burns trust — read the
  full path first. (Real case: a "column always shows —" finding evaporated
  once the caller was read; the real bug was a smaller adjacent one.)
- **Separate the three "logs".** Domain event log ≠ application
  observability ≠ notifications. They get conflated; audit them distinctly.
- **A test that fails bimodally is never a timeout problem.** Instrument and
  capture the failing run before touching numbers. (Real case: 3 timeout
  band-aids + 8 red CI runs masked a real product bug.)
- **Objective vs decision is the primary split.** Robustness/correctness/
  a11y-semantics/perf are objective — fix them. Aesthetics/mechanism-choice/
  paid-infra are the owner's call — propose, don't impose.
- **Every finding is an artifact.** It goes to the tracker with enough
  context to act without the audit conversation, tagged by severity and
  fix-now/decision.

---

## Part A — Audit dimensions (the checklist)

Run the ones that apply to the stack. Each line is "look for X".

### A1. Security (run EVERY Sprint Close)
- [ ] Authz/access-control boundary holds where the client omits a filter
      (e.g. row-level policies filter ROWS, not "what WHERE the client
      used" — a "public read by token" table policy is enumerable).
- [ ] Privilege-escalation paths: can a lower role reach a higher-role write
      via a direct API call that bypasses the intended flow?
- [ ] Injection: SQL, command, template, and **spreadsheet-formula injection
      in any CSV/export** (values starting with `= + - @`).
- [ ] Secrets: none in client code, logs, URLs, or committed files.
- [ ] Sensitive-data exposure: does any endpoint/view leak another tenant's
      data when the scoping arg is missing?
- [ ] Immutability/audit rules enforced at the data layer (trigger/
      constraint), not just the app layer.

### A2. Test coverage
- [ ] Every access-control policy has a dedicated test (allowed AND denied,
      paired with a not-related actor).
- [ ] Every invariant / immutability rule has a DB-level test (not only a
      validation-layer test).
- [ ] Every business rule the docs claim as "enforced" actually has a
      failing-first test proving it.
- [ ] CI is green on the final commit before an issue is called closed
      (local pass ≠ CI pass).

### A3. Technical robustness
- [ ] **Silent failures**: every network/IO call has error handling for the
      *reject* case, not only the *!ok* case (a rejected fetch with no catch
      hangs the UI forever). Centralize in one wrapper.
- [ ] Swallowed errors (`catch {}` / `.catch(()=>{})`) that hide causes.
- [ ] Bimodal/flaky tests investigated for root cause, not retried.
- [ ] Irreversible actions confirm before, and never silently no-op.

### A4. Performance
- [ ] Query waterfalls: independent queries awaited in series that should be
      one parallel batch (latency = sum vs max). Worst on mobile-first
      views.
- [ ] N+1 in loops; over-fetching (`select *` where a few columns suffice).
- [ ] Missing indexes on filtered/joined columns.

### A5. Accessibility
- [ ] Real heading elements (not styled divs); sane heading order.
- [ ] Tables have header cells with scope.
- [ ] Color contrast meets AA; meaning never conveyed by color alone.
- [ ] Icon-only controls have accessible names; inputs have labels.
- [ ] Tap targets ~44px on mobile.
- [ ] All motion respects `prefers-reduced-motion`.

### A6. UX/UI friction — per persona × workflow
- [ ] Walk each persona's full journey end-to-end; mark dead-ends, confusing
      transitions, and steps with no next-action.
- [ ] Redirects land users on routes their role actually owns.
- [ ] Read-only roles have their limits made explicit (avoid wrong
      expectations).

### A7. States & feedback
- [ ] Loading: every async surface shows progress (submit, navigation,
      field loads). Route-level loading states exist.
- [ ] Error: route-level error boundaries with human copy + retry (not the
      framework's raw error).
- [ ] Success: in-place actions confirm success explicitly (not only via
      navigation). Decide one channel (toast vs inline) and use it
      consistently.
- [ ] Empty: empty-states offer their next action as a CTA, not passive
      text.

### A8. Onboarding / first-run
- [ ] A first-time user is shown the intended flow and what controls do.
- [ ] Empty-states double as onboarding (CTA to the first action).
- [ ] Rule for future work: every new feature ships its empty-state-CTA and,
      if its flow isn't obvious, its onboarding entry.

### A9. Animations & microinteractions
- [ ] Motion used as feedback (enter/exit, height transitions, saved-check),
      not decoration.
- [ ] Brand-character motion aligns with the design system (decision).
- [ ] Domain rules on motion respected (e.g. no alarming/celebratory motion
      on money screens if the product forbids it).

### A10. Mobile interaction patterns
- [ ] Overlays reachable by thumb: prefer bottom sheets over centered
      dialogs / dropdowns on small screens.
- [ ] Rule for future work: new overlays are designed as mobile bottom
      sheets first, not desktop dialogs adapted down.

### A11. Logs, events & observability
- [ ] Domain event log is complete: every domain mutation records an event,
      naming is consistent, and there's a single catalog of event types
      (not strings scattered per call-site + a drifting label map).
- [ ] Application observability exists: a structured logger; errors log
      their cause with context (user/route/request-id), not swallowed.
- [ ] (Decision) error-tracking service before production.

### A12. Notifications mapping
- [ ] Map every domain event → recipient(s) → channel → signal strength.
      Note direction (who notifies whom) and noise (which events deserve a
      push vs a digest vs nothing).
- [ ] If a notification module is warranted, build it as a **projection of
      the existing event log**, not a parallel event system. Prefer a
      data-layer fan-out (trigger) so no code path can forget to emit.
- [ ] Per-user × per-event × per-channel preferences; sensible quiet
      defaults.

---

## Part B — Backward review (regression pass over past findings)

The point of an audit is undermined if fixed things silently break again.
On each sweep:

- [ ] List previously-closed audit findings (query the tracker by label).
- [ ] For each, confirm the fix is still in place AND still covered by a
      test. A fix without a regression test is a finding waiting to recur.
- [ ] Check the recurrence counters (see the process's trigger mechanism):
      a finding fixed with a light touch that returns N times is a signal to
      change the process, not to re-apply the same patch.
- [ ] Confirm the "rules for future work" from prior audits (empty-state-CTA,
      mobile-first overlays, event-log-on-every-mutation) are actually being
      followed by work shipped since.

---

## Part C — Output contract

Every audit sweep produces:

1. **A dated audit doc** in the project's `docs/audit/` — findings by
   dimension, each tagged ✅ fixed-now / 📋 tracked / 🔵 decision, with a
   priority table.
2. **Tracker issues** for everything not fixed on the spot, labeled by
   severity and fix-now vs decision, self-contained enough to act on later.
3. **A short owner notification**: what was fixed, what's tracked, and the
   specific decisions being asked of the owner — never bundled as "please
   review everything."

## Cadence

| Audit | When |
|-------|------|
| Security (A1) | Every Sprint Close (ritual) |
| Test coverage (A2) | Every Sprint Close, and after any schema/policy change |
| Robustness, Perf, States (A3/A4/A7) | Periodic sweep + when touching the area |
| A11y, UX, Onboarding, Animation, Mobile (A5/A6/A8/A9/A10) | Periodic UX sweep; each new surface at build time |
| Logs/events/observability, Notifications (A11/A12) | Once as a foundation audit; then whenever a new domain event is added |
| Backward review (Part B) | Every periodic sweep |
