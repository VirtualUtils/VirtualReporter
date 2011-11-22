# ---- Dead LunPath ----
function ShowLunPath () {

  if ($ShowLunPath) {
  
    Write-CustomOut "..Checking Hosts Dead Lun Path"
    $deadluns = @()

    foreach ($esxhost in ($VMH | where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"})) {
      $esxluns = Get-ScsiLun -vmhost $esxhost |Get-ScsiLunPath
      
      foreach ($esxlun in $esxluns) {
        if ($esxlun.state -eq "Dead") {
          $myObj = "" |
          Select VMHost, Lunpath, ConnectionState
          $myObj.VMHost = $esxhost
          $myObj.Lunpath = $esxlun.Lunpath
          $myObj.ConnectionState = $esxlun.state
          $deadluns += $myObj
        }    
      }
    }
    
    If (($deadluns | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $lunPathReport += Get-CustomHeader "Dead LunPath : $($deadluns.count)" "Dead LUN Paths may cause issues with storage performance or be an indication of loss of redundancy"
      $lunPathReport += Get-HTMLTable $deadluns
      $lunPathReport += Get-CustomHeaderClose
    }
  }
  
  return $lunPathReport
}