# ---- Hosts in Maintenance Mode ----
function ShowMaint ([hashtable]$vCheckDataObjects) {

  if ($ShowMaint) {
	
    
		Write-CustomOut "..Checking Hosts in Maintenance Mode"
    $MaintHosts = @($vCheckDataObjects["VMH"] | where {$_.ConnectionState -match "Maintenance"} | Select Name, ConnectionState)
    
    if (($MaintHosts | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $maintReport += Get-CustomHeader "Hosts in Maintenance Mode : $($MaintHosts.count)" "Hosts held in Maintenance mode will not be running any virtual machine worloads, check the below Hosts are in an expected state"
      $maintReport += Get-HTMLTable $MaintHosts
      $maintReport += Get-CustomHeaderClose
    }
  }
	
  return $maintReport
}