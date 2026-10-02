# Lab Setup

Domain: `iam.local`

The lab uses a dedicated `IAMLAB` OU with child OUs for Users, Groups, Computers, Servers, and Service Accounts. Department access is represented by Global Security Groups: `GG-HR`, `GG-Finance`, `GG-IT`, and `GG-Sales`.

The lifecycle scripts use the ActiveDirectory PowerShell module and write events to `C:\IAMLAB\Logs\Provisioning.log`.

## Design Goal
Separate identity objects from access groups and make lifecycle changes repeatable, testable, and auditable. The scripts validate important conditions before performing changes and verify resulting AD state after successful operations.
