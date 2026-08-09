# Golden set template (quality evals for an AI feature)

Defined BEFORE the prompt exists. Lives versioned in the project repo
(`evals/<feature>/golden.json` + a runner script). Format is a suggestion;
the discipline is not.

## The set

```json
{
  "feature": "<feature name>",
  "created": "<date>",
  "dimensions": {
    "<dimension_1>": { "floor": 0.85, "why": "<what breaking this costs the user>" },
    "<dimension_2>": { "floor": 0.70, "why": "..." }
  },
  "cases": [
    {
      "id": "case-001",
      "input": "<the real input — real data, not invented>",
      "expected": { "<dimension_1>": "<expected value>", "<dimension_2>": "..." },
      "notes": "<why this case is in the set: it is typical / it is an edge / it broke once>"
    }
  ]
}
```

**Rules that make it useful:**
- **Real inputs, not invented ones.** A set of made-up cases measures your
  imagination, not the feature.
- **Per-dimension scoring, never one aggregate.** The validated shape:
  `exact` / `partial` / `wrong` / `both-null` per field or criterion — an
  average hides which dimension broke.
- **`both-null` is not a win.** "The model returned nothing and the
  expected was nothing" is correct behavior, but tracked separately, or a
  feature that answers nothing scores perfectly.
- **Cases earn their place.** Typical + edge + every case that ever broke
  (a regression case is a bug's tombstone — see the quality module's
  no-bug-closes-without-a-test rule).
- **Floors are declared up front** with WHY, so lowering one later is a
  visible decision, not a quiet slide.

## The run record

```json
{
  "run": "<id>", "timestamp": "<iso>", "commit": "<sha>",
  "model": "<model id>", "prompt_version": "<hash or tag>",
  "cases_evaluated": 0,
  "scores": { "<dimension>": { "exact": 0, "partial": 0, "wrong": 0, "both_null": 0 } },
  "below_floor": [],
  "notes": "<what changed since the previous run and what it did>"
}
```

Append every run to a history file. **The delta between runs is the
evidence** — "it looks better" is not a result. A run that leaves any
dimension `below_floor` blocks the merge like a red test.

## Minimum runner contract

`npm run evals:<feature>` (or equivalent): loads the set, runs the real
feature path (no mocks of the model), scores per dimension, appends the
run record, exits non-zero if anything is below its floor.
