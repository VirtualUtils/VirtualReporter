# ---- VMs Removed ----
function ShowRemoved ([hashtable]$vCheckDataObjects) {

  if ($ShowRemoved) {

    Write-CustomOut "..Checking for removed VMs"
    
    $VIEvent = Get-VIEvent -maxsamples 10000 -Start ($vCheckDataObjects["date"]).AddDays(-$VMsNewRemovedAge)
    $OutputRemovedVMs = @($VIEvent | where {$_.Gettype().Name -eq "VmRemovedEvent"}| Select createdTime, @{N="User";E={(Find-Username (($_.userName.split("\"))[1])).Properties.displayname}}, fullFormattedMessage)

    if (($OutputRemovedVMs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $removedReport += Get-CustomHeader "VMs Removed (Last $VMsNewRemovedAge Day(s)) : $($OutputRemovedVMs.count)" "The following VMs have been removed/deleted over the last $($VMsNewRemovedAge) days"
      $removedReport += Get-HTMLTable $OutputRemovedVMs
      $removedReport += Get-CustomHeaderClose
    }
  }
  
  return $removedReport
}