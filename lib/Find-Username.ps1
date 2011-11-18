Function Find-Username ($username){
	if ($username -ne $null) 	{
		$root = [ADSI]""
		$filter = ("(&(objectCategory=user)(samAccountName=$Username))")
		$ds = new-object  system.DirectoryServices.DirectorySearcher($root,$filter)
		$ds.PageSize = 1000
		$UN = $ds.FindOne()
		If ($UN -eq $null){
			Return $username
		}
		Else {
			Return $UN
		}
	}
}