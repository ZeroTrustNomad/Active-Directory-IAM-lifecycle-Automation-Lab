# Mover Workflow

## Purpose
Change a user's business attributes and department access when responsibilities change.

| Department | Security group |
|---|---|
| Human Resources | `GG-HR` |
| Finance | `GG-Finance` |
| IT | `GG-IT` |
| Sales | `GG-Sales` |

## Workflow
1. Verify the user exists and read current department/title.
2. Validate the requested department has an approved mapping.
3. Verify the destination group exists.
4. Remove previous department access when present.
5. Update department and title.
6. Assign the new department group.
7. Log and verify the resulting state.

## Validated Tests
`daniel.wilson` moved from Finance / Junior Financial Analyst to IT / IAM Engineer. `GG-Finance` was removed and `GG-IT` assigned.

A request to `Legal` was rejected because no approved access group was mapped. Post-failure verification showed the account remained IT / IAM Engineer / `GG-IT`, demonstrating that this validation failure did not alter the existing identity/access state.
