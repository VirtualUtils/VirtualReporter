# Cluster CPU allocation ratios
function ShowCPUClusterRatio() {

  if ($ShowCPUClusterRatio) {
  
    Write-CustomOut "..Checking Cluster CPU ratio"
    $FullClusterDetail = @()
    
    Foreach ($Cluster in $Clusters) {
      $guestcnt,$clustervcpu,$hostCount,$clustercores = 0,0,0,0
      
      Foreach ($ESXHost in ($Cluster |Get-VMHost |Sort Name)) {
        $hostview = $ESXHost | get-view
        $guestvcpu = 0
        
        foreach ($clustCpuVM in ($ESXHost |Get-VM)) {
          $guestcnt += 1
          $guestvcpu += ($clustCpuVM).NumCpu
        }
        
        $hdwrCores = $hostview.Hardware.CpuInfo.NumCpuCores
        $hostCount += 1
        $clustercores += $hdwrCores
        $clustervcpu += $guestvcpu
      }
      
      $ClusterDetails = "" | Select Name, Hosts, Cores, Guests, vCPU_Count,vCPU_per_VM, vCPU_per_Core
      $ClusterDetails.name = $Cluster
      $ClusterDetails.hosts = $hostCount
      $ClusterDetails.cores = $clustercores
      $ClusterDetails.guests = $guestcnt
      $ClusterDetails.vCPU_Count = $clustervcpu
      $ClusterDetails.vCPU_per_VM = ([math]::round(($clustervcpu/$guestcnt), 2))
      $ClusterDetails.vCPU_per_Core = ([math]::round(($clustervcpu/$clustercores), 2))
      $FullClusterDetail += $ClusterDetails
    }
    
    If (($FullClusterDetail | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $CPUClusterRatioReport += Get-CustomHeader "Cluster CPU Allocation ratio" "The following gives brief cluster level view of vCPU and physical core allocation ratios."
      $CPUClusterRatioReport += Get-HTMLTable $FullClusterDetail
      $CPUClusterRatioReport += Get-CustomHeaderClose
    }
  }
  
  return $CPUClusterRatioReport
}