Import-Module ActiveDirectory

# ==========================================
# IAMLAB - Mover / Department Transfer
# ==========================================

$LogDirectory = "C:\IAMLAB\Logs"
$LogFile = "$LogDirectory\Provisioning.log"

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

# Collect transfer information
$Username      = Read-Host "Username"
$NewDepartment = Read-Host "New department"
$NewTitle      = Read-Host "New job title"

# Verify user exists
$User = Get-ADUser $Username -Properties Department,Title -ErrorAction SilentlyContinue

if (-not $User) {
    Write-Host ""
    Write-Host "ERROR: User $Username does not exist."

    Write-IAMLog `
        -Status "FAILED" `
        -Username $Username `
        -Message "Mover request failed - user not found"

    exit
}

$OldDepartment = $User.Department
$OldTitle = $User.Title

# Map business department names to AD security groups
$DepartmentGroups = @{
    "Human Resources" = "GG-HR"
    "Finance"         = "GG-Finance"
    "IT"              = "GG-IT"
    "Sales"           = "GG-Sales"
}

# Determine old and new access groups
$OldGroup = $DepartmentGroups[$OldDepartment]
$NewGroup = $DepartmentGroups[$NewDepartment]

# Validate department mapping
if (-not $NewGroup) {
    Write-Host ""
    Write-Host "ERROR: No access group is mapped to department '$NewDepartment'."

    Write-IAMLog `
        -Status "FAILED" `
        -Username $Username `
        -Message "Mover failed - unmapped department: $NewDepartment"

    exit
}

try {

    # Verify destination group exists
    $DestinationGroup = Get-ADGroup $NewGroup -ErrorAction Stop

    # Remove previous department access
    if (Get-ADGroupMember $OldGroup -ErrorAction SilentlyContinue |
        Where-Object {$_.SamAccountName -eq $Username}) {

        Remove-ADGroupMember `
            -Identity $OldGroup `
            -Members $Username `
            -Confirm:$false `
            -ErrorAction Stop

        Write-Host "Removed old access: $OldGroup"
    }

    # Update identity attributes
    Set-ADUser `
        -Identity $Username `
        -Department $NewDepartment `
        -Title $NewTitle `
        -ErrorAction Stop

    # Assign new department access
    Add-ADGroupMember `
        -Identity $NewGroup `
        -Members $Username `
        -ErrorAction Stop

    Write-IAMLog `
        -Status "SUCCESS" `
        -Username $Username `
        -Message "Moved from $OldDepartment ($OldTitle) to $NewDepartment ($NewTitle); removed $OldGroup; assigned $NewGroup"

    Write-Host ""
    Write-Host "--- IAM MOVER COMPLETE ---"
    Write-Host ""

    # Verify new identity state
    Get-ADUser $Username -Properties Department,Title |
        Select-Object Name,SamAccountName,Department,Title

    Write-Host ""
    Write-Host "Current Groups:"

    Get-ADPrincipalGroupMembership $Username |
        Select-Object Name,GroupScope,GroupCategory
}

catch {

    Write-Host ""
    Write-Host "MOVER FAILED:"
    Write-Host $_.Exception.Message

    Write-IAMLog `
        -Status "FAILED" `
        -Username $Username `
        -Message $_.Exception.Message
}