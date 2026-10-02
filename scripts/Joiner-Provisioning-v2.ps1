Import-Module ActiveDirectory

# ==========================================
# IAMLAB - Joiner Provisioning Script V2
# ==========================================

# Configuration
$UserOU  = "OU=Users,OU=IAMLAB,DC=iam,DC=local"
$GroupOU = "OU=Groups,OU=IAMLAB,DC=iam,DC=local"

$LogDirectory = "C:\IAMLAB\Logs"
$LogFile = "$LogDirectory\Provisioning.log"

# Create log directory if it does not exist
if (-not (Test-Path $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory | Out-Null
}

# Logging function
function Write-IAMLog {
    param (
        [string]$Status,
        [string]$Username,
        [string]$Message
    )

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    "$Timestamp | $Status | $Username | $Message" |
        Out-File -FilePath $LogFile -Append
}

# Collect employee information
$FirstName  = Read-Host "First name"
$LastName   = Read-Host "Last name"
$Department = Read-Host "Department"
$Title      = Read-Host "Job title"

# Build identity information
$Username = "$($FirstName.ToLower()).$($LastName.ToLower())"
$UPN = "$Username@iam.local"
$GroupName = "GG-$Department"

# Check for duplicate identity BEFORE asking for password
$ExistingUser = Get-ADUser `
    -Filter "SamAccountName -eq '$Username'" `
    -ErrorAction SilentlyContinue

if ($ExistingUser) {

    Write-Host ""
    Write-Host "ERROR: User $Username already exists."
    Write-Host "Provisioning stopped. No changes were made."

    Write-IAMLog `
        -Status "BLOCKED" `
        -Username $Username `
        -Message "Duplicate account detected"

    exit
}

# Securely request temporary password
$Password = Read-Host "Temporary password" -AsSecureString

try {

    # Check whether department security group exists
    $Group = Get-ADGroup `
        -Filter "Name -eq '$GroupName'" `
        -ErrorAction SilentlyContinue

    # Create group if necessary
    if (-not $Group) {

        New-ADGroup `
            -Name $GroupName `
            -SamAccountName $GroupName `
            -GroupCategory Security `
            -GroupScope Global `
            -Path $GroupOU `
            -Description "$Department department access group" `
            -ErrorAction Stop

        Write-Host "Created security group: $GroupName"
    }

    # Create employee identity
    New-ADUser `
        -Name "$FirstName $LastName" `
        -GivenName $FirstName `
        -Surname $LastName `
        -SamAccountName $Username `
        -UserPrincipalName $UPN `
        -Path $UserOU `
        -Department $Department `
        -Title $Title `
        -Company "IAMLAB" `
        -Description "IAM Lab Test User" `
        -AccountPassword $Password `
        -ChangePasswordAtLogon $true `
        -Enabled $true `
        -ErrorAction Stop

    # Assign departmental access
    Add-ADGroupMember `
        -Identity $GroupName `
        -Members $Username `
        -ErrorAction Stop

    # Write successful provisioning event to audit log
    Write-IAMLog `
        -Status "SUCCESS" `
        -Username $Username `
        -Message "Account created and assigned to $GroupName"

    Write-Host ""
    Write-Host "--- IAM PROVISIONING COMPLETE ---"
    Write-Host ""

    # Verify identity
    Get-ADUser $Username -Properties Department,Title |
        Select-Object Name,SamAccountName,Enabled,Department,Title

    Write-Host ""
    Write-Host "Assigned Groups:"

    # Verify entitlements
    Get-ADPrincipalGroupMembership $Username |
        Select-Object Name,GroupScope,GroupCategory
}

catch {

    Write-Host ""
    Write-Host "PROVISIONING FAILED:"
    Write-Host $_.Exception.Message

    Write-IAMLog `
        -Status "FAILED" `
        -Username $Username `
        -Message $_.Exception.Message
}