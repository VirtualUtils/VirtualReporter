# Cluster Memory allocation ratios
# Code provided by Ed: http://enterpriseadmins.org/blog/scripting/powercli-vcheck-5-40/#comments
function ShowMemClusterRatio () {

  if ($ShowMemClusterRatio) {

  Write-CustomOut "..Checking Cluster Memory ratio"

  $FullClusterDetail = @()

    foreach ($Cluster in $Clusters){
      $guestcnt,$clustervmemmb,$hostCount,$clustermem = 0,0,0,0
      
      foreach ($ESXHost in ($Cluster |Get-VMHost |Sort Name)){
        $hostview = $ESXHost | get-view
        $guestvmemmb = 0
        foreach ($clustMemVM in ($ESXHost |Get-VM)){
          $guestcnt += 1
          $guestvmemmb += ($clustMemVM).MemoryMB
        }
        $hdwrMem = $ESXhost.MemoryTotalMB
        $hostCount += 1
        $clusterMem += $hdwrMem
        $clustervmemmb += $guestvmemmb
      }
      
      $ClusterDetails = "" | Select Name, Hosts, HostMemMB, Guests, vMb_Count,vMb_per_VM, vMb_per_HostMB
      $ClusterDetails.name = $Cluster
      $ClusterDetails.hosts = $hostCount
      $ClusterDetails.HostMemMB = $clusterMem
      $ClusterDetails.guests = $guestcnt
      $ClusterDetails.vMb_Count = $clustervmemmb
      $ClusterDetails.vMb_per_VM = ([math]::round(($clustervmemmb/$guestcnt), 2))
      $ClusterDetails.vMb_per_HostMB = ([math]::round(($clustervmemmb/$clusterMem), 2))
      $FullClusterDetail += $ClusterDetails
    }
    
    if (($FullClusterDetail | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $memClusterRatioReport += Get-CustomHeader "Cluster Memory Allocation ratio" "The following gives brief cluster level view of vMem and physical mem allocation ratios."
      $memClusterRatioReport += Get-HTMLTable $FullClusterDetail
      $memClusterRatioReport += Get-CustomHeaderClose
    }
  }
  
  return $memClusterRatioReport
}