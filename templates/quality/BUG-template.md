# Bug template (install as a tracker issue form, e.g. `.github/ISSUE_TEMPLATE/bug.yml`)

```markdown
## Bug: {one-line symptom, user's perspective}

**Severity**: S1 (users blocked / data at risk) · S2 (core flow degraded,
workaround exists) · S3 (non-core broken) · S4 (cosmetic)
**Environment**: {dev / uat / prod} · **Version/commit**: {sha or deploy id}

### Minimal reproduction
1. {numbered steps — the shortest path that shows it}

### Expected vs actual
- Expected: {…}
- Actual: {…}

### Evidence
{screenshot / log excerpt / request id — at least one}

### Pre-filing verification (mandatory)
- [ ] Searched duplicates & prior occurrences — query used: `{…}`, result: {none / links}
- [ ] Regression check: did this work before? {yes → last-good commit/deploy · no → never worked · unknown}
- [ ] Data or code? {corrupt/unexpected data · code defect · unclear}
- [ ] Affected flows listed: {which user flows does this touch beyond the repro}

### Workaround
{temporary mitigation if any — or "none"}

---
### On close (mandatory — a bug does not close without these)
- **Root cause**: {the cause, not the symptom — one honest paragraph}
- **Fix**: {commit/PR}
- **Regression test**: {test file/name that now prevents this}
- **LEARNINGS?**: {yes → entry added (process-level cause) · no}
```

Labels: `bug` + severity (`S1`-`S4`) + area. Severity is by real user
impact — never by how ugly the stack trace looks.
