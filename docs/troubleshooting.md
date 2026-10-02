# Troubleshooting and Defensive Testing

Negative tests were intentionally included to validate safe lifecycle behavior.

## Duplicate Joiner
An existing `daniel.wilson` identity caused provisioning to stop. The event was recorded as `BLOCKED`.

## Unmapped Mover Department
A mover request for `Legal` returned `ERROR: No access group is mapped to department 'Legal'.` The event was logged as `FAILED`. Verification confirmed Daniel remained IT / IAM Engineer with `GG-IT`.

## Repeated Leaver
After successful offboarding, another leaver request returned an already-disabled error and was recorded as `BLOCKED`.

These tests document duplicate-request prevention, validation of unsupported access mappings, repeat-operation protection, and auditable failure handling.
