# Capacity Planner Info
function ShowCapacityInfo() {

  if ($ShowCapacityInfo) {
    Write-CustomOut "..Checking Capacity Info"
    $capacityinfo = @()
    
    foreach ($cluv in (Get-View -ViewType ClusterComputeResource)) {
      if ((Get-Cluster $cluv.name|Get-VM).count -gt 0) {
        $clucapacity = "" |Select ClusterName, "Estimated Num VM Left (CPU)", "Estimated Num VM Left (MEM)"
        
        # CPU
        $DasRealCpuCapacity = $cluv.Summary.EffectiveCpu - (($cluv.Summary.EffectiveCpu*$cluv.Configuration.DasConfig.FailoverLevel)/$cluv.Summary.NumEffectiveHosts)
        $CluCpuUsage = get-stat -entity $cluv.name -stat cpu.usagemhz.average -Start ($Date).adddays(-7) -Finish ($Date)
        $CluCpuUsageAvg = ($CluCpuUsage|Where-object{$_.value -gt ($CluCpuUsage|Measure-Object -average -Property value).average}|Measure-Object -Property value -Average).Average
        $VmCpuAverage = $CluCpuUsageAvg/(Get-Cluster $cluv.name|Get-VM).count
        $CpuVmLeft = [math]::round(($DasRealCpuCapacity-$CluCpuUsageAvg)/$VmCpuAverage,0)
      
        # Memory
        $DasRealMemCapacity = $cluv.Summary.EffectiveMemory - (($cluv.Summary.EffectiveMemory*$cluv.Configuration.DasConfig.FailoverLevel)/$cluv.Summary.NumEffectiveHosts)
        $CluMemUsage = get-stat -entity $cluv.name -stat mem.consumed.average -Start ($Date).adddays(-7) -Finish ($Date)
        $CluMemUsageAvg = ($CluMemUsage|Where-object{$_.value -gt ($CluMemUsage|Measure-Object -average -Property value).average}|Measure-Object -Property value -Average).Average/1024
        $VmMemAverage = $CluMemUsageAvg/(Get-Cluster $cluv.name|Get-VM).count
        $MemVmLeft = [math]::round(($DasRealMemCapacity-$CluMemUsageAvg)/$VmMemAverage,0)
      
        $clucapacity.ClusterName = $cluv.name
        $clucapacity."Estimated Num VM Left (CPU)" = $CpuVmLeft
        $clucapacity."Estimated Num VM Left (MEM)" = $MemVmLeft
      
        $capacityinfo += $clucapacity
      }
    }
    
    If (($capacityinfo | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $capacityInfoReport += Get-CustomHeader "Capacity Planner Info" "The following gives brief capacity information for each cluster based on average CPU/Mem usage and counting for HA failover requirements"
      $capacityInfoReport += Get-HTMLTable $capacityinfo
      $capacityInfoReport += Get-CustomHeaderClose
    }
    
    Write-CustomOut "..Checking Capacity Info (disk)"
    $diskcapacityinfo = @()
    
    # The disk forecast will be per datacenter instead of per cluster since
    # Get-Datastore -Entity only supports VirtualMachine, VMHost, and Datacenter objects.
    # To improve performance in code, we are going to make the following assumptions
    #   Assumption 1.) Disk capacity - Free Space = space used by VMs
    #   Assumption 2.) used space / count of VMs = Avg Space used per VM
    #   Assumption 3.) we will reserve 15% of capacity for overhead  
    foreach ($dc in $Datacenter) {
      Clear-Variable forecast*
      
      Get-Datastore -Entity $dc | Get-View | %{ 
        if ($LimitDiskCapacityForecastToSharedStorageOnly) {
          $_ | where-object {$_.Summary.MultipleHostAccess -eq $true} | %{$forecastDiskCapacity += $_.Summary.Capacity; $forecastDiskFree += $_.Summary.FreeSpace}
        } else {
          $_ | %{$forecastDiskCapacity += $_.Summary.Capacity; $forecastDiskFree += $_.Summary.FreeSpace}
        }
      }
      
      $forecastUsedSpace = (0.85 * $forecastDiskCapacity) - $forecastDiskFree
      
      $existingVmCount = (Get-VM -Location $dc).Count
      if ($existingVmCount -ne 0) {
        $forecastAveragedUsedPerVM = $forecastUsedSpace / $existingVmCount
        if ($forecastAveragedUsedPerVM -ne 0) {
          $forecastVMcount = [math]::round(($forecastDiskFree / $forecastAveragedUsedPerVM),1)
        }
      }
      
      if ($forecastVMcount -ne $null) {
        $dcdiskcapacity = "" |select "DataCenter Name", "Existing VM Count", "Average used per VM (MB)", "Estimated Num VM Left (Disk)"
        $dcdiskcapacity."DataCenter Name" = $dc.Name
        $dcdiskcapacity."Existing VM Count" = $existingVmCount
        $dcdiskcapacity."Average used per VM (MB)" =  "{0:N1}" -f [math]::round(($forecastAveragedUsedPerVM/1024/1024),1)
        $dcdiskcapacity."Estimated Num VM Left (Disk)" = $forecastVMcount
        $diskcapacityinfo += $dcdiskcapacity
      }
    }
    
    If (($diskcapacityinfo | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $capacityInfoReport += Get-CustomHeader "Capacity Planner Info (Storage)" "The following gives brief capacity information for virtual machine storage per datacenter."
      $capacityInfoReport += Get-HTMLTable $diskcapacityinfo
      $capacityInfoReport += Get-CustomHeaderClose
    }
  }
  
  return $capacityInfoReport
}