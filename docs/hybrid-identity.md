# Hybrid Identity — Active Directory to Microsoft Entra ID

This case study documents the completed hybrid identity extension of the Active Directory IAM Lifecycle Automation Lab. The objective was to connect a controlled subset of on-premises identities to Microsoft Entra ID, validate Password Hash Synchronization, and prove that an authoritative Active Directory attribute change propagates to the cloud.

## Design

| Component | Implementation |
| --- | --- |
| On-premises domain | `iam.local` |
| Domain controller | `DC01` / `172.16.147.10` |
| Sync server | `SYNC-01` / `172.16.147.15` |
| Cloud directory | Microsoft Entra ID Free |
| Sync technology | Microsoft Entra Connect Sync |
| Authentication method | Password Hash Synchronization |
| Source anchor | `mS-DS-ConsistencyGuid` |
| Pilot scope | `OU=Synced Users,OU=IAMLAB,DC=iam,DC=local` |
| Pilot identities | Michael Davis, Sarah Johnson |

## Control Objectives

The hybrid build was designed around controlled scope, least privilege, authoritative identity data, and verification. A dedicated `Synced Users` OU limits which identities are eligible for synchronization. Entra Connect configuration used the Hybrid Identity Administrator role rather than Global Administrator. Active Directory remains the source for synchronized identity attributes, and each major synchronization stage was verified with technical evidence.

## Evidence Walkthrough

### 01 — Dedicated Sync Server Placement
`SYNC-01` was domain joined and placed in the managed Servers OU.

![01](../screenshots/hybrid-identity/01-sync01-server-ou-placement.png)

### 02 — Cloud UPN Test User
Michael Davis was verified as an enabled IT identity with a cloud-routable UPN before synchronization.

![02](../screenshots/hybrid-identity/02-cloud-upn-test-user-verification.png)

### 03 — Pilot Users Prepared
The active pilot identities were verified with cloud-routable UPNs before Entra Connect configuration.

![03](../screenshots/hybrid-identity/03-active-users-cloud-upn-ready.png)

### 04 — Connectivity Verification
`SYNC-01` successfully reached the domain controller and established TCP 443 connectivity to Microsoft identity endpoints.

![04](../screenshots/hybrid-identity/04-sync01-connectivity-verification.png)

### 05 — Least-Privilege Cloud Administration
A dedicated cloud-only account was assigned the **Hybrid Identity Administrator** role for Entra Connect configuration.

![05](../screenshots/hybrid-identity/05-hybrid-identity-admin-role-assignment.png)

### 06 — AD Forest Connected
The `iam.local` Active Directory forest was added successfully to Entra Connect.

![06](../screenshots/hybrid-identity/06-ad-forest-connected.png)

### 07 — Sign-In Configuration Review
The wizard identified the non-routable `.local` suffix and cloud UPN suffix configuration. This screenshot records the review stage before the final continuation selection.

![07](../screenshots/hybrid-identity/07-entra-signin-configuration.png)

### 08 — Dedicated Synchronization OU
Michael Davis and Sarah Johnson were placed in `IAMLAB\Synced Users`, separating the pilot identities from disabled and unrelated lab users.

![08](../screenshots/hybrid-identity/08-ad-synced-users-ou-scope.png)

### 09 — Domain/OU Filtering
Entra Connect was scoped to the dedicated `Synced Users` OU rather than the entire directory.

![09](../screenshots/hybrid-identity/09-domain-ou-filtering-scoped-sync.png)

### 10 — Password Hash Synchronization
Password Hash Synchronization was selected as the authentication synchronization method.

![10](../screenshots/hybrid-identity/10-password-hash-synchronization-enabled.png)

### 11 — Configuration Review
The wizard summarized synchronization services, source anchor, tenant connector, `iam.local` connector, Password Hash Synchronization, and export deletion threshold before installation.

![11](../screenshots/hybrid-identity/11-entra-connect-ready-to-configure.png)

### 12 — Core Entra Connect Configuration Succeeded
Microsoft Entra Connect Sync configuration completed and initiated synchronization. The screen also records two non-core notices: AD Recycle Bin was recommended but not enabled, and the separate Entra Connect Health Agent installation failed. Neither was treated as proof of core synchronization failure.

![12](../screenshots/hybrid-identity/12-entra-connect-configuration-complete.png)

### 13 — Synchronized User Verification
Michael Davis was verified in Entra ID as an on-premises synchronized identity, with the distinguished name pointing back to the dedicated `Synced Users` OU.

![13](../screenshots/hybrid-identity/13-synchronized-user-verification.png)

### 14 — Synchronization Engine Operations
Synchronization Service Manager recorded successful import, synchronization, and export operations for the on-premises and cloud connectors.

![14](../screenshots/hybrid-identity/14-sync-engine-successful-operations.png)

### 15 — Functional PHS Authentication
After Michael's password was reset in on-premises Active Directory, the synchronized credentials were successfully used for Microsoft cloud authentication.

![15](../screenshots/hybrid-identity/15-password-hash-sync-authentication-success.png)

### 16 — Password Change Synchronization Event
The Directory Synchronization application log recorded a successful password-change result for Michael Davis, providing backend evidence in addition to the functional cloud sign-in test.

![16](../screenshots/hybrid-identity/16-password-change-directory-sync-success.png)

### 17 — Hybrid Mover: On-Premises Change
Sarah Johnson's authoritative Active Directory attributes were changed from Finance / Financial Analyst to IT / IT Support Analyst.

![17](../screenshots/hybrid-identity/17-hybrid-mover-onprem-attribute-change.png)

### 18 — Hybrid Mover: Cloud Attribute Propagation
After Delta Import, Delta Synchronization, and cloud Export completed successfully, Sarah's Entra ID properties reflected IT / IT Support Analyst.

![18](../screenshots/hybrid-identity/18-hybrid-mover-cloud-attribute-sync.png)

## Result

The lab demonstrates a working hybrid identity path from Active Directory to Microsoft Entra ID with deliberately restricted synchronization scope. It verifies synchronized identity creation, Password Hash Synchronization, cloud authentication, password-change synchronization, and Mover attribute propagation without presenting optional or unimplemented controls as completed.

## Scope Notes

Microsoft Entra Connect Health was not completed as part of the final Free-tier lab scope. AD Recycle Bin was also left unchanged because it was optional for the synchronization objective. Future phases may add group synchronization, device identity, SSO/federation, MFA/Conditional Access where licensing permits, and Okta integration after those controls are built and validated.