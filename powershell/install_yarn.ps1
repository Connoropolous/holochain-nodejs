$ErrorActionPreference = 'Stop'; # stop on all errors
$packageName = 'yarn'
$packageArgs = @{
  packageName = $packageName
  softwareName = 'Yarn*'
  fileType = 'msi'
  silentArgs = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log`""
  validExitCodes = @(0, 3010, 1641)
  checksumType = 'sha256'
 
  url = 'https://yarnpkg.com/downloads/1.12.3/yarn-1.12.3.msi'
  checksum = '0657A3883B9338B22C61ABC6A97279F0DAC4C0B2B97DE9E59C9D0FA919CCBF00'
}
 
Install-ChocolateyPackage @packageArgs
 
# Update Yarn's package.json file so it can tell that it was installed via Chocolatey.
if (Test-Path "${env:ProgramFiles(x86)}\Yarn\package.json") {
  $path = "${env:ProgramFiles(x86)}\Yarn\package.json"
} else {
  $path = "$env:ProgramFiles\Yarn\package.json"
}
$script = @"
  (Get-Content -Path '$path') ``
    -replace 'installationMethod":.+', 'installationMethod": "choco",' ``
    | Set-Content '$path'
"@
Start-ChocolateyProcessAsAdmin -Statements $script