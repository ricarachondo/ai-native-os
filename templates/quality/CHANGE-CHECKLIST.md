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

**Environment config**
- [ ] No new env vars/config — OR set in ALL environments: {which, where}

**Docs sync (converged hard rules)**
- [ ] Schema touched → `docs/database/` updated
- [ ] Personal data touched → `docs/security/PII-INVENTORY.md` updated
- [ ] Security practice touched → `docs/security/CONTROLS.md` updated

**Diagnosability**
- [ ] If this change fails in production, the signals to see it exist:
      {log line / error tracking / metric — or why none is needed}
```
