# Evidence Guide

This directory is designed to contain the screenshots captured while validating the Active Directory Joiner-Mover-Leaver workflow.

## Evidence Sequence

| # | Screenshot | What it demonstrates |
|---|---|---|
| 01 | `01-ad-ou-structure.png` | IAMLAB Active Directory OU structure used to organize lab identities and resources |
| 02 | `02-security-groups.png` | Department security groups used for access assignment |
| 03 | `03-ad-test-users.png` | Test identities created in the lab |
| 04 | `04-joiner-success.png` | Successful Joiner provisioning and department access assignment |
| 05 | `05-joiner-duplicate-blocked.png` | Duplicate-account protection blocks a repeated provisioning request |
| 06 | `06-mover-before-state.png` | Identity/access state captured before a department transfer |
| 07 | `07-mover-success.png` | Successful Mover execution |
| 08 | `08-mover-after-state.png` | Post-transfer attributes and access verification |
| 09 | `09-mover-failure-logged.png` | Invalid/unmapped department request is logged as a failure |
| 10 | `10-mover-failure-verified.png` | Post-failure verification confirms existing identity/access state was preserved |
| 11 | `11-leaver-before-state.png` | Active identity and access captured before offboarding |
| 12 | `12-leaver-success.png` | Successful account disablement and access removal |
| 13 | `13-leaver-after-state.png` | Post-offboarding verification |
| 14 | `14-leaver-repeat-blocked.png` | Repeated offboarding request is blocked for an already-disabled account |
| 15 | `15-iam-audit-log.png` | Consolidated lifecycle audit trail showing successful, blocked, and failed events |

## Review Path

A reviewer can follow the screenshots numerically to see the control flow:

```text
AD Structure
     ↓
Security Groups
     ↓
Joiner → Duplicate Protection
     ↓
Mover → Post-Change Verification → Failure Handling
     ↓
Leaver → Post-Offboarding Verification → Repeat Protection
     ↓
Audit Trail
```

## Why Negative Tests Are Included

The portfolio intentionally retains blocked and failed test cases. IAM automation is not only about successful provisioning. The evidence also demonstrates that the workflow detects duplicate identities, rejects unsupported department mappings, blocks repeated offboarding, and records those outcomes for review.

> All identities and screenshots in this repository are from a lab environment and are used solely to demonstrate hands-on IAM lifecycle testing.
