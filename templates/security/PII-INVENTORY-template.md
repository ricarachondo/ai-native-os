# PII inventory — {{PROJECT}}

> Every piece of personal data the project holds. The privacy policy is
> GENERATED from this — never the other way around. Hard rule: any change
> that collects/stores a new personal datum updates this inventory in the
> same issue cycle (the Security Engineer flags it if missing; the Data
> Architect's spec mode declares PII columns up front).

| Field | Where it lives | Why we hold it | Retention | Deletion path | Who can see it |
|---|---|---|---|---|---|
| {{email}} | {{table.column / auth provider}} | {{login, notifications}} | {{while account active}} | {{account deletion cascades / manual}} | {{owner + system}} |

## Derived / third-party data

| Data | Source | Note |
|---|---|---|
| {{e.g. visitor identity from a tracking token}} | {{}} | {{}} |

## Deletion story (the honest paragraph)

{{What actually happens today when a user asks for deletion — automated
cascade, manual runbook, or a known gap listed as such.}}
