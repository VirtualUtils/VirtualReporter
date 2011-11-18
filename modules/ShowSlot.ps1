# --- Cluster Slot Sizes ---
function ShowSlot () {

  if ($ShowSlot) {

    if ($vSphere -eq $true) {

      Write-CustomOut "..Checking Cluster Slot Sizes"
      
      $SlotInfo = @()

      foreach ($Cluster in ($Clusters| Get-View)){
        if ($Cluster.Configuration.DasConfig.Enabled -eq $true){
          $SlotDetails = $Cluster.RetrieveDasAdvancedRuntimeInfo()
          $Details = "" | Select Cluster, TotalSlots, UsedSlots, AvailableSlots
          $Details.Cluster = $Cluster.Name
          $Details.TotalSlots =  $SlotDetails.TotalSlots
          $Details.UsedSlots = $SlotDetails.UsedSlots
          $Details.AvailableSlots = $SlotDetails.UnreservedSlots
          $SlotInfo += $Details
        }
      }

      $SlotCHK = @($SlotInfo | Where { $_.AvailableSlots -lt $numslots})

      if (($SlotCHK | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
        $slotReport += Get-CustomHeader "Clusters with less than $numslots Slot Sizes : $($SlotCHK.count)" "Slot sizes in the below cluster are less than is specified, this may cause issues with creating new VMs, for more information click here: <a href='http://www.yellow-bricks.com/vmware-high-availability-deepdiv/' target='_blank'>Yellow-Bricks HA Deep Dive</a>"
        $slotReport += Get-HTMLTable $SlotCHK
        $slotReport += Get-CustomHeaderClose	
      }
    }
  }
  
  return $slotReport
}