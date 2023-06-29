# Install the required module if not already installed
if (-not (Get-Module -Name Microsoft.Graph.Intune)) {
    Install-Module -Name Microsoft.Graph.Intune
}

# Authenticate to Microsoft Graph
Connect-MSGraph

# Get all iOS devices enrolled in Intune
$iosDevices = Get-IntuneManagedDevice | Get-MSGraphAllPages | Where-Object { $_.operatingSystem -EQ "iOS" -and $_.managedDeviceOwnerType -EQ "company" }

# Get current date
$currentDate = Get-Date

# Iterate through each iOS device
foreach ($device in $iosDevices) {
    $enrollmentDate = $device.enrolledDateTime.DateTime
    $age = $currentDate.Year - $enrollmentDate.Year

    # Check if the device is older than 2 years
    if ($age -ge 2) {
        Write-Host "Device $($device.deviceName) is older than 2 years. Replacement needed."
        # Add code here to initiate the replacement process
    } else {
        Write-Host "Device $($device.deviceName) is within 2 years."
    }
}
