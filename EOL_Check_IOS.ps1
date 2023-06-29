# Install the required module if not already installed
if (-not (Get-Module -Name Microsoft.Graph.Intune)) {
    Install-Module -Name Microsoft.Graph.Intune
}

# Authenticate to Microsoft Graph
Connect-MSGraph

# Get all iPads enrolled in Intune
$ipads = Get-IntuneManagedDevice | Where-Object {$_.deviceType -eq "iPad"}

# Get current date
$currentDate = Get-Date

# Iterate through each iPad
foreach ($ipad in $ipads) {
    $enrollmentDate = $ipad.enrolledDateTime.DateTime
    $age = $currentDate.Year - $enrollmentDate.Year

    # Check if the iPad is older than 2 years
    if ($age -ge 2) {
        Write-Host "iPad $($ipad.deviceName) is older than 2 years. Replacement needed."
        # Add code here to initiate the replacement process
    } else {
        Write-Host "iPad $($ipad.deviceName) is within 2 years."
    }
}
