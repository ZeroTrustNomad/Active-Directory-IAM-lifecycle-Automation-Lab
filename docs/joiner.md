# Joiner Workflow

## Purpose
Automate creation of a new Active Directory identity and assign department-based access.

## Workflow
1. Collect first name, last name, department, and job title.
2. Generate `firstname.lastname` and the `iam.local` UPN.
3. Check for an existing account before requesting the temporary password.
4. Block the request if the username exists.
5. Create the AD user in `OU=Users,OU=IAMLAB,DC=iam,DC=local`.
6. Set department, title, company, and description.
7. Assign department security-group access.
8. Write an audit event and display the resulting identity and memberships.

## Validated Test
`daniel.wilson` was created in Finance as Junior Financial Analyst and assigned `GG-Finance`. A second run for the same identity was blocked with no changes made.

Audit states used: `SUCCESS`, `BLOCKED`, and `FAILED`.
