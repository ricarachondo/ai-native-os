# Kit learnings — append-only

Incidents from operating THIS repo and the way-of-working itself, as
opposed to a project's own `docs/LEARNINGS.md` (which holds product and
stack learnings). Distinct from the neighbours: `PRINCIPLES.md` holds the
distilled RULE, the README ledger holds EVIDENCE STATE, this file holds
the INCIDENT — what happened, what it cost, what changed because of it.

Append at the moment of the learning, in any session, sprint or not.
Never edited, never pruned.

---

## The recurring meta-pattern: discipline is not a mechanism

Observed across at least five independent incidents below. Every time a
rule existed only as a sentence someone had to remember, it eventually
broke — and every time it was converted into something that CHECKS
(script, gate, contract, symlink), it stopped breaking. When you catch
yourself writing "always remember to X", the follow-up question is "what
would check X, and what does that check cost?". If nothing cheap exists,
log the counter — the third failure is what earns the mechanism.
Distilled as PRINCIPLES.md #27.

---

## 2026-08 · The anonymization rule was broken three times while it was only a rule

**What happened**: the public kit's non-negotiable "no private project
names" rule was violated in at least three separate places by
well-meaning sessions — a source project's product domain used as the AI
module's running example (4 spots), and a private project named outright
in the validation ledger and the analytics module (5 spots). None was
malicious; each session simply wrote naturally about the project it was
working in.

**What it cost**: the leaks reached the public repo. The user caught them
by reminding the session that the kit must be project-agnostic — the
process did not catch them.

**Root cause**: the rule lived in `README.md § Contributing` as a
sentence. Nothing verified it before a push, and the sessions that wrote
the content were the same ones that would have had to check it.

**What changed**: `scripts/anonymize-check.sh` — generic leak shapes
(personal paths, emails, deployment URLs, credential-shaped strings) plus
a private deny-list read from OUTSIDE the repo (the list itself would be
a leak), documentation placeholders excluded, referenced from Contributing
as a pre-push step.

**What was NOT fixed** (recorded honestly): three commit MESSAGES in the
public history still mention private project names. The user decided to
leave them — rewriting history costs more than three names in commit
bodies are worth, and the new mechanism stops the set from growing.

---

## 2026-08 · A policy ran for five sprints without its own variables being logged

**What happened**: the model-per-task and effort policies ran across five
real sprints while the cost log captured only tokens and duration. When
the user asked to visualize historical model/effort usage to audit
whether the policies worked, the data did not exist — the decision
INPUTS had never been recorded, only the outputs the tooling provided for
free.

**What it cost**: the historical evaluation was impossible; the best
available reconstruction is inference from the policy-in-force dates in
the decision log, marked as inferred, never as measured.

**Root cause**: measurement was shaped by what the tooling handed over,
not by the question the data would later have to answer. And rule
evolution did not trigger measurement evolution.

**What changed**: PRINCIPLES.md #26 (a policy without its variables
logged is unevaluable — every policy declares its evaluation data
contract at creation) and a per-dispatch metrics log with model and
effort columns.

---

## 2026-08 · An eval harness existed, worked, and vanished in a migration

**What happened**: a source project's extraction pipeline had a real eval
harness — per-field exact/partial/wrong scoring over a real input batch,
with a run history. It did not survive the migration to the successor
repo. The quality of the feature that defines the product's core value
went unmeasured, and nobody noticed until an unrelated evaluation went
looking.

**Root cause**: no role owned AI features, and the change checklist asked
about schema, PII and security but never "does this LLM feature still
have its evals?".

**What changed**: the AI-features module, the `ai-engineer` role, the
change-checklist item, and the eval templates — plus the rule that a
prompt without an eval is a change without a test.

---

## 2026-08 · A kit skill was installed as a COPY, creating silent drift

**What happened**: the housekeeping skill was installed into the
user-level skills directory by copying it from the kit — ten minutes
after the birth contract's own "reference, don't copy" rule had been
written for role files. The copy would have rotted the moment the kit
version improved.

**Root cause**: the rule was stated for one artifact class (roles) and
not generalized to another (skills), so it did not fire when the second
class appeared.

**What changed**: the installed skill became a symlink to the kit file,
and the birth contract now covers kit-shipped skills explicitly —
including the requirement that every kit skill declares its own learning
loop, since a static skill rots exactly like a copied rule.

---

## 2026-08 · A role recommendation was wrong because it answered a different question

**What happened**: the session recommended NOT creating an AI role,
evaluating "do occasional LLM features justify a role?". The user
challenged it, revealing the actual question was "does a standing
direction of conversational AI in every project justify one?" — for
which the answer is yes, and the evidence (the lost eval harness) was
already on the table.

**Lesson**: before answering a should-we-build-X question, state the
question being answered and check it against the user's actual frame —
a correct answer to the wrong question is indistinguishable from a wrong
answer until someone challenges it. The user's challenge is the
mechanism today; naming the question explicitly in the recommendation is
the cheap improvement.
