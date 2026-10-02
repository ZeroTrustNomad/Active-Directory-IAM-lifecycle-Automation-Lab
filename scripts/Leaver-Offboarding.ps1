Import-Module ActiveDirectory

# IAMLAB - Leaver / Offboarding Automation
$LogDirectory = "C:\IAMLAB\Logs"
$LogFile = "$LogDirectory\Provisioning.log"

function Write-IAMLog {
    param ([string]$Status,[string]$Username,[string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$Timestamp | $Status | $Username | $Message" | Out-File -FilePath $LogFile -Append
}

$Username = Read-Host "Username to offboard"
$User = Get-ADUser $Username -Properties Department,Title,Enabled -ErrorAction SilentlyContinue

if (-not $User) {
    Write-Host ""; Write-Host "ERROR: User $Username does not exist."
    Write-IAMLog -Status "FAILED" -Username $Username -Message "Leaver failed - user not found"
    exit
}

if (-not $User.Enabled) {
    Write-Host ""; Write-Host "ERROR: Account $Username is already disabled."
    Write-IAMLog -Status "BLOCKED" -Username $Username -Message "Leaver blocked - account already disabled"
    exit
}

$Department = $User.Department
$Title = $User.Title
$OffboardDate = Get-Date -Format "yyyy-MM-dd"

try {
    Disable-ADAccount -Identity $Username -ErrorAction Stop
    Write-Host "Account disabled: $Username"
    $Groups = Get-ADPrincipalGroupMembership $Username | Where-Object { $_.Name -ne "Domain Users" }

    foreach ($Group in $Groups) {
        Remove-ADGroupMember -Identity $Group -Members $Username -Confirm:$false -ErrorAction Stop
        Write-Host "Removed access: $($Group.Name)"
    }

    Set-ADUser -Identity $Username -Description "OFFBOARDED $OffboardDate - $Department - $Title" -ErrorAction Stop
    Write-IAMLog -Status "SUCCESS" -Username $Username -Message "Leaver completed; account disabled; non-default access removed"

    Write-Host ""; Write-Host "--- IAM LEAVER COMPLETE ---"; Write-Host ""
    Get-ADUser $Username -Properties Enabled,Department,Title,Description | Select-Object Name,SamAccountName,Enabled,Department,Title,Description
    Write-Host ""; Write-Host "Remaining Groups:"
    Get-ADPrincipalGroupMembership $Username | Select-Object Name,GroupScope,GroupCategory
}
catch {
    Write-Host ""; Write-Host "LEAVER FAILED:"; Write-Host $_.Exception.Message
    Write-IAMLog -Status "FAILED" -Username $Username -Message $_.Exception.Message
}
