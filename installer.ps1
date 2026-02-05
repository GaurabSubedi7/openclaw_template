# PowerShell script to automate Node.js (v24.13.0), Git, and OpenClaw setup

$downloads = "$env:USERPROFILE\Downloads"
curl.exe https://raw.githubusercontent.com/GaurabSubedi7/openclaw_template/refs/heads/master/BOOTSTRAP.md `
  -o "$downloads\BOOTSTRAP.md"

Write-Host "BOOTSTRAP.md downloaded in Downloads"
# Step 1: Install Node.js (v24.13.0)
Write-Host "Installing Node.js v24.13.0..."
$nodejs_url = "https://nodejs.org/dist/v24.13.0/node-v24.13.0-x64.msi"
$nodejs_installer = "$env:TEMP\nodejs_installer.msi"

Invoke-WebRequest -Uri $nodejs_url -OutFile $nodejs_installer
Start-Process msiexec.exe -ArgumentList "/i", $nodejs_installer, "/quiet", "/norestart" -Wait
Write-Host "Node.js installation complete."

# Step 2: Install Git
Write-Host "Installing Git..."
$git_url = "https://github.com/git-for-windows/git/releases/download/v2.38.0.windows.1/Git-2.38.0-64-bit.exe"
$git_installer = "$env:TEMP\git_installer.exe"

Invoke-WebRequest -Uri $git_url -OutFile $git_installer
Start-Process $git_installer -ArgumentList "/VERYSILENT", "/NORESTART" -Wait
Write-Host "Git installation complete."

# Step 3: Install OpenClaw (run the PowerShell command)
Write-Host "Running OpenClaw setup..."
# Replace the following line with your OpenClaw installation command
# Example:
iwr -useb https://openclaw.ai/install.ps1 | iex

# Assuming you have an installation script or steps for OpenClaw, you can call it here.
# For now, this is a placeholder and should be replaced with your actual OpenClaw setup command.
Write-Host "OpenClaw setup is complete."

# Clean up
Remove-Item -Path $nodejs_installer -Force
Remove-Item -Path $git_installer -Force

Write-Host "Setup completed successfully!"