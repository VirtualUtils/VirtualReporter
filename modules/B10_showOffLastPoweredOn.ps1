# ---- Powered Off VMs with last powered on task date ----
function showOffLastPoweredOn () {

  if ($showOffLastPoweredOn) {

    Write-CustomOut "..Checking powered off VMs for last Powered On task date"
    
    $guestDownTime = @()

    $vm | where {$_.PowerState -eq "PoweredOff"} | %{
      $Details = "" | select VM, PowerState, LastPowerOn, DiskGB
      $Details.VM = $_.name
      $Details.PowerState = $_.PowerState
      $Details.LastPowerOn = Get-LastPowerOn $_
      $Details.DiskGB = [math]::round($_.UsedSpaceGB, 2)
      $guestDownTime += $Details
    }

    if (($guestDownTime |Measure-Object).count -gt 0 -OR $ShowAllHeaders) {
      $offLastPoweredOnReport += get-customheader "Powered off VMs : $($guestDownTime.count)" "The following VMs are currently powered off and could possibily be relocated to slower storage or deleted if no longer required.  The date/time of the most recent power on task is included for reference."
      $offLastPoweredOnReport += get-htmltable ($guestDownTime | sort LastPowerOn)
      $offLastPoweredOnReport += Get-CustomHeaderClose
    }
  }
  
  return $offLastPoweredOnReport
}