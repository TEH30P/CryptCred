function ~CrCr.load
{	param 
	(	[parameter(Mandatory=1, position=0)][String]$iCredPath)
	
	[Byte[]]$aBuff = [IO.File]::ReadAllBytes($iCredPath);
	[Byte[]]$aBuff = [Security.Cryptography.ProtectedData]::Unprotect($aBuff,$null,[Security.Cryptography.DataProtectionScope]::LocalMachine);
	[Byte[]]$aBuff = [Security.Cryptography.ProtectedData]::Unprotect($aBuff,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser);

	,[Text.Encoding]::UTF8.GetString($aBuff).Split("`n") | % {New-Object psobject -Property @{'User'=$_[0]; 'PWD'=$_[1]}};
}