# ---- VM Guest OS Pivot Table ----
function ShowGuestOSPivot () {

  if ($ShowGuestOSPivot) {
  
    Write-CustomOut "..Creating Guest OS Pivot table"

    $VMOSversions = @{ }
    $VM | Get-View | % {
    
    # Prefer to use GuestFullName but try AltGuestName first
      if ($_.Config.AlternateGuestName) { $VMOSversion = $_.Config.AlternateGuestName }
      if ($_.Guest.GuestFullName) { $VMOSversion = $_.Guest.GuestFullName }

      # Seeing if any of these options worked
      if (!($VMOSversion)) { 
        # No 'version' so checking for tools
        if (!($_.Guest.ToolsStatus.Value__ )) { 
          $VMOSversion = "Unknown - no VMTools" 
        } else { 
        # Still no 'version', must be old tools
          $toolsversion = $_.Config.Tools.ToolsVersion
          $VMOSversion = "Unknown - tools version $toolsversion"
        }
      }			
      $VMOSversions.$VMOSversion++
    }
    
    $myCol = @()
    
    foreach ( $gosname in $VMOSversions.Keys | sort) {
      $MyDetails = "" | select OS, Count
      $MyDetails.OS = $gosname
      $MyDetails.Count = $VMOSversions.$gosname
      $myCol += $MyDetails
    }
    
    $vVMOSversions = $myCol | sort Count -desc
    
    If (($vVMOSversions | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $guestOSPivotReport += Get-CustomHeader "VMs by Operating System : $($vVMOSversions.count)" "The following Operating Systems are in use in this vCenter."
      $guestOSPivotReport += Get-HTMLTable $vVMOSversions
      $guestOSPivotReport += Get-CustomHeaderClose
    }
  }
  
  return $guestOSPivotReport
}