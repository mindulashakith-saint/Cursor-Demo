# /review — Salesforce code review

Review the current diff, or the files I name. Read-only: recommend, don't edit.
Group findings by severity — Critical (block merge) / High / Medium / Nit — each
with `file:line`, the risk, and the fix.

## Correctness & limits

- No SOQL/SOSL/DML in loops; handles 200+ records per transaction.
- No CPU, heap, or query-row risk on large volumes; Batch/Queueable where needed.
- Queries selective — indexed filters on large objects, only the needed fields.

## Security

- CRUD/FLS enforced on every read and write.
- `with sharing` unless documented; no unjustified `without sharing`.
- Bind variables, not string-concatenated SOQL (injection).
- No PII, secrets, tokens, or sensitive fields in logs or responses.
- No hardcoded IDs, org URLs, endpoints, or credentials.

## Tests

- Changed logic has a matching test with outcome assertions.
- Bulk (200-record) case covered; `@testSetup`; no `SeeAllData=true`.
- LWC changes have Jest specs (`npm run test:unit`).

## LWC / Aura

- SLDS and accessibility respected; loading and error states handled.
- User-facing strings in Custom Labels, not literals.

## Hygiene

- Field/method API names match the metadata (`Status__c`, not `Apttus_Config2__Status__c`).
- `npm run prettier:verify` and `npm run lint` are clean.
- Only intended files touched; changes are minimal.

End with a verdict — **Ready to merge** / **Changes requested** — and a draft commit
message `TSIP-XXXXX: <summary>`.
