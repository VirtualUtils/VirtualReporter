function Get-UnShareableDatastore {
	$Report = @()
	Foreach ($datastore in (Get-Datastore)){
		If (($datastore | get-view).summary.multiplehostaccess -eq $false){
			ForEach ($VM in (get-vm -datastore $Datastore )){
				$SAHost = "" | Select VM, Datastore
				$SAHost.VM = $VM.Name 
				$SAHost.Datastore = $Datastore.Name
				$Report += $SAHost
			}
		}
	}
	$Report
}