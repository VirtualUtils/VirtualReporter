# ---- Floppys Connected ----
function ShowVMsFloppyConnected ([hashtable]$vCheckDataObjects) {

  if ($ShowFloppy){

  Write-CustomOut "..Checking for connected floppy drives"

  $floppy = @($vCheckDataObjects["VM"] | Where { $_ | Get-FloppyDrive | Where { $_.ConnectionState.Connected -eq $true } } | Where { $_.Name -notmatch $CDFloppyConnectedOK } | Select Name, VMHost)
  $floppy = $floppy | Where { $_.Name -notmatch $CDFloppyConnectedOK }

    if (($floppy | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vmsFloppyConnectedReport += Get-CustomHeader "VM:Floppy Drive Connected - VMotion Violation : $($Floppy.count)" "The following VMs have a floppy disk connected, this may cause issues if this machine needs to be migrated to a different host"
      $vmsFloppyConnectedReport += Get-HTMLTable $floppy
      $vmsFloppyConnectedReport += Get-CustomHeaderClose
    }
  }

  return $vmsFloppyConnectedReport
}