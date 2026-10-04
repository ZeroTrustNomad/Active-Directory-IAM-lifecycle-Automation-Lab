# Lab Setup

This document records the validated Active Directory and hybrid identity lab configuration.

## Current Environment

| Component | Configuration |
| --- | --- |
| Hypervisor | VMware Fusion |
| Network | NAT — `172.16.147.0/24` |
| Gateway | `172.16.147.2` |
| Domain | `iam.local` |
| NetBIOS | `IAMLAB` |
| Domain Controller | `DC01` — `172.16.147.10` |
| Sync Server | `SYNC-01` — `172.16.147.15` |
| Client | `WIN11-01` |
| Directory | Active Directory Domain Services |
| DNS | Windows Server DNS on `DC01` |
| Cloud Directory | Microsoft Entra ID Free |
| Hybrid Sync | Microsoft Entra Connect Sync |
| Authentication Sync | Password Hash Synchronization |
| Automation | PowerShell |

## Active Directory Structure

The `IAMLAB` OU contains dedicated organizational units for users, groups, computers, servers, service accounts, and a controlled `Synced Users` OU. Department access is represented with `GG-HR`, `GG-Finance`, `GG-IT`, and `GG-Sales`.

The `Synced Users` OU is intentionally separate from the general Users OU. Only the selected pilot identities were placed there for the initial hybrid synchronization scope.

## Hybrid Identity Configuration

`SYNC-01` is a dedicated domain-joined Windows Server member server. Microsoft Entra Connect Sync was configured with Password Hash Synchronization and domain/OU filtering restricted to `IAMLAB → Synced Users`. The initial pilot identities were Michael Davis and Sarah Johnson.

A dedicated cloud-only Hybrid Identity Administrator account was used for Entra Connect configuration to avoid using Global Administrator for the synchronization setup.

See [Hybrid Identity](hybrid-identity.md) for the complete evidence walkthrough.