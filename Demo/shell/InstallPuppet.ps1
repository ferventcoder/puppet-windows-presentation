$env:PATH +=";$env:SystemDrive\Chocolatey\bin"


$resourcesPath = 'c:\vagrant\resources'
$pkgFile = get-childitem $resourcesPath -recurse -include 'puppet.*.nupkg' | select -First 1

if ($pkgFile -ne $null) {
    cinst puppet -source "$resourcesPath"
} else {
    cinst puppet
}

$PuppetInstallPath = "$env:SystemDrive\Program Files (x86)\Puppet Labs\Puppet\bin"
if (!(Test-Path $PuppetInstallPath)) {$PuppetInstallPath = "$env:SystemDrive\Program Files\Puppet Labs\Puppet\bin";}

#get the PATH variable
$envPath = $env:PATH
if (!$envPath.ToLower().Contains($PuppetInstallPath.ToLower())) {
    Write-Host "PATH environment variable does not have `'$PuppetInstallPath`' in it. Adding..."
    $ActualPath = [Environment]::GetEnvironmentVariable('Path', [System.EnvironmentVariableTarget]::Machine)
    $StatementTerminator = ";"
    $HasStatementTerminator = $ActualPath -ne $null -and $ActualPath.EndsWith($StatementTerminator)
    If (!$HasStatementTerminator -and $ActualPath -ne $null) {$PuppetInstallPath = $StatementTerminator + $PuppetInstallPath}

    [Environment]::SetEnvironmentVariable('Path', $ActualPath + $PuppetInstallPath, [System.EnvironmentVariableTarget]::Machine)
}
