# Mover Workflow

The Mover workflow updates an existing identity when the employee changes department or role. It removes obsolete department access before assigning the new entitlement.

## Tested Scenario

A lab identity was transferred from Sales to Human Resources. `GG-Sales` was removed and `GG-HR` was assigned.

This demonstrates access reevaluation and least-privilege lifecycle management rather than simply accumulating group memberships.
