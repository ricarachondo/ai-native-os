# Change checklist (merge gate)

The SWE fills it at completion; the Tester verifies; the acceptance
review rejects merges with unaddressed items. "n/a" is a valid answer —
the value is that n/a is DECLARED, never assumed.

```markdown
### Change checklist — issue #{n}

**Deprecation**
- [ ] Nothing deprecated — OR:
- [ ] Deprecated: {what} · Consumers found: `{grep/search used}` → {list}
- [ ] Consumers migrated in this cycle, or removal plan recorded: {date/trigger}

**Data migration**
- [ ] No schema/data migration — OR:
- [ ] Rollback path: {how to undo, or "irreversible — user ok obtained"}
- [ ] Backfill plan: {script/steps} · Promotion order: {local → uat → prod}
- [ ] Post-migration verification: {counts/queries run, results}

**Contracts / breaking changes**
- [ ] No consumer-visible contract changed — OR breaking changes listed
      + every consumer updated in this cycle: {list}

**Environment / infra config — VERIFIED, not declared**
- [ ] No new env vars, platform setting or manual infra step — OR, for
      each one: verification RUN against the real environment with the
      output pasted here: {command/check + its actual output}
- [ ] The control verified is the one that covers the surface actually
      used (plan tier, aliases/custom domains, environment scope) — a
      platform protection may not cover what you assume it does
- [ ] Similarly-named secrets are not assumed to be the same mechanism:
      {which secret, which mechanism, which repo/environment}
> Groomed is not applied. This item is answered with evidence or an
> explicit `n/a` — never from intent.

**Docs sync (converged hard rules)**
- [ ] Schema touched → `docs/database/` updated
- [ ] Personal data touched → `docs/security/PII-INVENTORY.md` updated
- [ ] Security practice touched → `docs/security/CONTROLS.md` updated

**New dependencies (reuse ladder)**
- [ ] No new dependency and no wheel reinvented — OR: the reuse ladder was
      walked (internal → stack → library → custom) with the search
      declared: {what was searched, what was found, why chosen/rejected}.
      New library: license + maintenance + size noted; custom build: why
      nothing solid existed.

**New roles / pods / workflows**
- [ ] None created — OR the birth contract is satisfied
      (`templates/agents/README.md`): sections present, transversal rules
      referenced not copied, registered in roles table + validation
      ledger, cues declared

**AI features (prompt / context / model / tools)**
- [ ] No AI surface touched — OR: golden set RUN (link the run record,
      every dimension at or above its floor) · adversarial set RUN ·
      prompt/context version recorded · cost-per-interaction still under
      its ceiling. A prompt change without an eval run is a change
      without a test.

**Diagnosability**
- [ ] If this change fails in production, the signals to see it exist:
      {log line / error tracking / metric — or why none is needed}
```
