Function Set-Cred ($File) {
	$Credential = Get-Credential
	$credential.Password | ConvertFrom-SecureString | Set-Content $File
}
