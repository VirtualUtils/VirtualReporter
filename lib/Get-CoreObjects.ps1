# Get core VMware objects for the modules
function Get-CoreObjects {

  Write-CustomOut "Collecting VM Objects"
  Set-Variable -Name VM -Value $(Get-VM | Sort Name) -Scope Global

  Write-CustomOut "Collecting Datacenter Objects"
  Set-Variable -Name Datacenter -Value $(Get-Datacenter | Sort Name) -Scope Global

  Write-CustomOut "Collecting VM Host Objects"
  Set-Variable -Name VMH -Value $(Get-VMHost | Sort Name) -Scope Global

  Write-CustomOut "Collecting Cluster Objects"
  Set-Variable -Name Clusters -Value $(Get-Cluster | Sort Name) -Scope Global

  Write-CustomOut "Collecting Datastore Objects"
  Set-Variable -Name Datastores -Value $(Get-Datastore | Sort Name) -Scope Global

  Write-CustomOut "Collecting Detailed VM Objects"
  Set-Variable -Name FullVM -Value $(Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}) -Scope Global

  Write-CustomOut "Collecting Template Objects"
  Set-Variable -Name VMTmpl -Value $(Get-Template) -Scope Global

  Write-CustomOut "Collecting Detailed VI Objects"
  Set-Variable -Name serviceInstance -Value $(get-view ServiceInstance) -Scope Global

  Write-CustomOut "Collecting Detailed Alarm Objects"
  Set-Variable -Name alarmMgr -Value $(get-view $serviceInstance.Content.alarmManager) -Scope Global

  Write-CustomOut "Collecting Detailed VMHost Objects"
  Set-Variable -Name HostsViews -Value $(Get-View -ViewType hostsystem) -Scope Global
}