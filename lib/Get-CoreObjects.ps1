# Get core VMware objects for the modules
function Get-CoreObjects () {

  $vCheckDataObjects = @{}
  
  $vCheckDataObjects.Add("date", $(Get-Date))
  
  Write-CustomOut "Collecting VM Objects"
  $vCheckDataObjects.Add("VM", $(Get-VM | Sort Name))

  Write-CustomOut "Collecting Datacenter Objects"
  $vCheckDataObjects.Add("Datacenter", $(Get-Datacenter | Sort Name))

  Write-CustomOut "Collecting VM Host Objects"
  $vCheckDataObjects.Add("VMH", $(Get-VMHost | Sort Name))

  Write-CustomOut "Collecting Cluster Objects"
  $vCheckDataObjects.Add("Clusters", $(Get-Cluster | Sort Name))
	$vCheckDataObjects.Add("ClusterViews", $(Get-View -ViewType ClusterComputeResource | Sort Name))

  Write-CustomOut "Collecting Datastore Objects"
  $vCheckDataObjects.Add("Datastores", $(Get-Datastore | Sort Name))

  Write-CustomOut "Collecting Detailed VM Objects"
  $vCheckDataObjects.Add("FullVM", $(Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}))

  Write-CustomOut "Collecting Template Objects"
  $vCheckDataObjects.Add("VMTmpl", $(Get-Template))

  Write-CustomOut "Collecting Detailed VI Objects"
  $vCheckDataObjects.Add("serviceInstance", $(get-view ServiceInstance))

  Write-CustomOut "Collecting Detailed Alarm Objects"
  $vCheckDataObjects.Add("alarmMgr", $(get-view $vCheckDataObjects["serviceInstance"].Content.alarmManager))

  Write-CustomOut "Collecting Detailed VMHost Objects"
  $vCheckDataObjects.Add("HostsViews", $(Get-View -ViewType hostsystem))
  
  return $vCheckDataObjects
}