# Leaver Workflow

## Purpose
Remove active access when an identity no longer requires an active account.

## Workflow
1. Verify the account exists.
2. Block the request if the account is already disabled.
3. Disable the AD account.
4. Enumerate direct group memberships.
5. Remove all memberships except default `Domain Users`.
6. Update the description with offboarding date, department, and title.
7. Log the event and display final state.

## Validated Test
For `daniel.wilson`, the account changed from enabled to disabled and `GG-IT` was removed. The remaining membership was `Domain Users`. A later offboarding request was blocked because the account was already disabled.
