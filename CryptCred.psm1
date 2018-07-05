[String]$gSrciptDir = [IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path);
[String]$gScriptFile = [IO.Path]::GetFileName($MyInvocation.MyCommand.Path);
$gPSModule = $ExecutionContext.SessionState.Module;

Add-Type -AssemblyName 'System.Security' | Out-Null;

[String]$FileName = "$gSrciptDir\pub"

foreach ($FileName in [IO.Directory]::GetFiles($FileName))
{	if ($FileName.EndsWith('.ps1')) {. $FileName}}

New-Alias -Name Get-CrCred          -Value ~CrCr.Load  -Force;
New-Alias -Name Set-CrCred          -Value ~CrCr.Save  -Force;
New-Alias -Name Start-ProcessAsCrCred -Value ~CrCr.RunAs -Force;

Export-ModuleMember -Function '~CrCr.Save', '~CrCr.Load', '~CrCr.RunAs' -Alias 'Get-CrCred', 'Set-CrCred', 'Start-ProcessAsCrCred';
