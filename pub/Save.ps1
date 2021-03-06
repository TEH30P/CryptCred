#--------------------------#
function m~SecStr.Decrypt
{	param
	(	[Parameter(Mandatory=1)][Security.SecureString][ValidateNotNull()]$ioString
	,	[Parameter(Mandatory=0)][switch]$fDestroySrc)

	try 
	{	if ($ioString.Length -eq 0)
		{	if ($fDestroySrc) {$ioString.Dispose();}
			return '';
		}
		
		[IntPtr]$BSTRPtr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($ioString);
		[String]$Ret = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTRPtr);
		
		$Ret;
	} 
	catch
	{	throw}
	finally 
	{	if ($BSTRPtr -ne $null)
		{	[Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTRPtr);}
	
		if ($fDestroySrc) 
		{$ioString.Dispose();}
	}
}
#--------------------------#
############################

function ~CrCr.Save
{	param 
	(	[parameter(Mandatory=1, position=0)][String]$iCredPath
	,	[parameter(Mandatory=1, position=1, ParameterSetName='ClearText')][String]$iLogin
	,	[parameter(Mandatory=1, position=2, ParameterSetName='ClearText')][String]$iPassword
	,	[parameter(Mandatory=0, position=1, ParameterSetName='Secured')][ValidateNotNull()][Management.Automation.PSCredential]$iCred = (Get-Credential -Message '[CryptCred]: Input your credential')
	,	[parameter(Mandatory=0, ParameterSetName='Secured')][switch]$fSecured = $true
	)
	
	if ($PsCmdlet.ParameterSetName -eq 'Secured')
	{	[Byte[]]$aBuff = [Text.Encoding]::UTF8.GetBytes([String]::Join("`n", @($iCred.UserName, (m~SecStr.Decrypt $iCred.Password))))}
	else
	{	[Byte[]]$aBuff = [Text.Encoding]::UTF8.GetBytes([String]::Join("`n", @($iLogin, $iPassword)))}

	[Byte[]]$aBuffCrypt = [Security.Cryptography.ProtectedData]::Protect($aBuff,$null,[Security.Cryptography.DataProtectionScope]::CurrentUser);
	[Byte[]]$aBuffCrypt = [Security.Cryptography.ProtectedData]::Protect($aBuffCrypt,$null,[Security.Cryptography.DataProtectionScope]::LocalMachine);

	[IO.File]::WriteAllBytes($iCredPath, $aBuffCrypt);
}