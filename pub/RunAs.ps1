function ~CrCr.RunAs
{	param 
	(	[parameter(Mandatory=1, position=0)][String]$iCredPath
	,	[parameter(Mandatory=1, position=1)][String]$iRunPath
	)

	[Byte[]]$aBuff = [IO.File]::ReadAllBytes($iCredPath);
	[Byte[]]$aBuff = [Security.Cryptography.ProtectedData]::Unprotect($aBuff,$null,[Security.Cryptography.DataProtectionScope]::LocalMachine);
	[Byte[]]$aBuff = [Security.Cryptography.ProtectedData]::Unprotect($aBuff,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser);

	[Security.SecureString]$MyPwd = New-Object Security.SecureString;
	[Text.StringBuilder]$MyUser = New-Object Text.StringBuilder(128);
	[Boolean]$FillPwd = 0;

	[Text.Encoding]::UTF8.GetChars($aBuff) | % {if ($_ -ceq "`n") {$FillPwd=1} else {$_}} | % {if ($FillPwd) {$MyPwd.AppendChar($_)} else {[Void]$MyUser.Append($_)}};
	$aBuff.Clear();

	[System.Management.Automation.PSCredential]$MyCred = New-Object System.Management.Automation.PSCredential($MyUser.ToString(), $MyPwd);

	Start-Process -FilePath $iRunPath -Credential $MyCred;
}