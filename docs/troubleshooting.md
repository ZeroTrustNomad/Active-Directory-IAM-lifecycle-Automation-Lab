# Troubleshooting

## Department-to-Group Mapping

During Mover testing, the workflow initially generated `GG-Human Resources` from the department attribute. The existing Active Directory entitlement was named `GG-HR`, so the operation failed and the failure was logged.

The workflow was corrected by introducing an explicit mapping between business department names and AD security-group names.

A subsequent test successfully removed the previous Sales entitlement and assigned the HR entitlement.

The original failed audit event is intentionally retained as evidence of testing, troubleshooting, and control improvement.
