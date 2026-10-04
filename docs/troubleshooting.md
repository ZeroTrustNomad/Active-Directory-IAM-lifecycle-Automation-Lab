# Troubleshooting

## Department-to-Group Mapping

During Mover testing, the workflow initially generated `GG-Human Resources` from the department attribute. The existing Active Directory entitlement was named `GG-HR`, so the operation failed and the failure was logged. The workflow was corrected with an explicit department-to-group mapping, and the original failed audit event was retained as evidence of testing and control improvement.

## Entra Portal DNS Resolution

During the hybrid build, `SYNC-01` could reach the domain controller but Microsoft Entra portal name resolution failed through the original VMware NAT DNS forwarding path. DNS Server logs on `DC01` recorded rejected responses from the NAT resolver.

The Windows DNS forwarder was changed from the VMware NAT resolver to `8.8.8.8`. After the change, `SYNC-01` successfully resolved Microsoft Entra endpoints and HTTPS connectivity was verified. Domain members continued to use `DC01` as their DNS server.

## Entra Connect OU Discovery

The newly created `Synced Users` OU did not initially appear in the Entra Connect domain/OU filtering page. The Active Directory PowerShell RSAT feature was installed on `SYNC-01`, and the OU was independently verified from the sync server. After restarting the configuration workflow, the OU appeared and was selected as the pilot synchronization scope.

## ADSync PowerShell Module

A manual `Start-ADSyncSyncCycle` attempt was not used for final verification because the ADSync PowerShell module did not load correctly in the server's PowerShell environment. Instead, Synchronization Service Manager was used to run and verify Delta Import, Delta Synchronization, and Export operations.

## Entra Connect Health

Core Microsoft Entra Connect Sync configuration succeeded, but the separate Microsoft Entra Connect Health Agent installation failed. The lab remained on the Microsoft Entra Free-tier scope, and Connect Health was not required to prove the synchronization objectives. The final project therefore documents Connect Health as not implemented rather than presenting it as a completed control.