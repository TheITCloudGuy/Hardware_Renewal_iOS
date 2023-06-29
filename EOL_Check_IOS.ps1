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

# Email parameters
$sender = "noreply@contoso.com"
$recipient = "adminuser@contoso.com"
$subject = "Device Replacement Required"
$body = "The following iOS devices require replacement:`r`n`r`n"

# Iterate through each iOS device
foreach ($device in $iosDevices) {
    $enrollmentDate = [DateTime]$device.enrolledDateTime
    $age = $currentDate.Year - $enrollmentDate.Year
    if ($currentDate.Month -lt $enrollmentDate.Month -or ($currentDate.Month -eq $enrollmentDate.Month -and $currentDate.Day -lt $enrollmentDate.Day)) {
        $age--
    }

    # Check if the device is older than 2 years
    if ($age -ge 2) {
        $deviceName = $device.deviceName
        $enrollmentDateFormatted = $enrollmentDate.ToString("yyyy-MM-dd")

        Write-Host "Device $deviceName is older than 2 years. Replacement needed."

        # Add device details to the email body
        $body += "Device Name: $deviceName`r`nEnrollment Date: $enrollmentDateFormatted`r`nAge: $age year(s)`r`n`r`n"
    } else {
        Write-Host "Device $($device.deviceName) is within 2 years."
    }
}

# Send email notification with all device details using SMTP relay
Send-MailMessage -From $sender -To $recipient -Subject $subject -Body $body -SmtpServer '[SMTP SERVER ADDRESS]' -Port 25

