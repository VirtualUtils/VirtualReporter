# Get core VMware objects for the modules
function Get-CoreObjects {

  Write-CustomOut "Collecting VM Objects"
  $VM = Get-VM | Sort Name

  Write-CustomOut "Collecting Datacenter Objects"
  $Datacenter = get-datacenter | sort name

  Write-CustomOut "Collecting VM Host Objects"
  $VMH = Get-VMHost | Sort Name

  Write-CustomOut "Collecting Cluster Objects"
  $Clusters = Get-Cluster | Sort Name

  Write-CustomOut "Collecting Datastore Objects"
  $Datastores = Get-Datastore | Sort Name

  Write-CustomOut "Collecting Detailed VM Objects"
  $FullVM = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}

  Write-CustomOut "Collecting Template Objects"
  $VMTmpl = Get-Template

  Write-CustomOut "Collecting Detailed VI Objects"
  $serviceInstance = get-view ServiceInstance

  Write-CustomOut "Collecting Detailed Alarm Objects"
  $alarmMgr = get-view $serviceInstance.Content.alarmManager

  Write-CustomOut "Collecting Detailed VMHost Objects"
  $HostsViews = Get-View -ViewType hostsystem
}