# ---- Hosts which are overcomitting ----
function ShowOverCommit () {

  if ($ShowOverCommit) {
  
    Write-CustomOut "..Checking Hosts Overcommit state"
    $MyObj = @()
    
    Foreach ($VMHost in $VMH) {
      $Details = "" | Select Host, TotalMemMB, TotalAssignedMemMB, TotalUsedMB, OverCommitMB
      $Details.Host = $VMHost.Name
      $Details.TotalMemMB = $VMHost.MemoryTotalMB
      
      if ($VMMem) { Clear-Variable VMMem }
      Get-VMHost $VMHost | Get-VM | Foreach {
        [INT]$VMMem += $_.MemoryMB
      }
      
      $Details.TotalAssignedMemMB = $VMMem
      $Details.TotalUsedMB = $VMHost.MemoryUsageMB
      
      If ($Details.TotalAssignedMemMB -gt $VMHost.MemoryTotalMB) {
        $Details.OverCommitMB = ($Details.TotalAssignedMemMB - $VMHost.MemoryTotalMB)
      } Else {
        $Details.OverCommitMB = 0
      }
      
      $MyObj += $Details
    }

    $OverCommit = @($MyObj | Where {$_.OverCommitMB -gt 0})
    
    If (($OverCommit | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $overCommitReport += Get-CustomHeader "Hosts overcommiting memory : $($OverCommit.count)" "Overcommitted hosts may cause issues with performance if memory is not issued when needed, this may cause ballooning and swapping"
      $overCommitReport += Get-HTMLTable $OverCommit
      $overCommitReport += Get-CustomHeaderClose
    }
  }
  
  return $overCommitReport
}