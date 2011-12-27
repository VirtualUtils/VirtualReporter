# ---- Dead LunPath ----
function ShowLunPathReport ([hashtable]$vCheckDataObjects) {

  if ($ShowLunPath) {
  
    Write-CustomOut "..Checking Hosts Dead Lun Path"
    $deadluns = @()

    foreach ($esxhost in ($vCheckDataObjects["VMH"] | where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"})) {
      $esxluns = Get-ScsiLun -vmhost $esxhost |Get-ScsiLunPath
      
      foreach ($esxlun in $esxluns) {
        if ($esxlun.state -eq "Dead") {
          $myObj = "" |
          Select VMHost, Name, ConnectionState
          $myObj.VMHost = $esxhost
          $myObj.Name = $esxlun.Name
          $myObj.ConnectionState = $esxlun.state
          $deadluns += $myObj
        }    
      }
    }
    
    if (($deadluns | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $lunPathReport += Get-CustomHeader "Dead LunPath : $($deadluns.count)" "Dead LUN Paths may cause issues with storage performance or be an indication of loss of redundancy"
      $lunPathReport += Get-HTMLTable $deadluns
      $lunPathReport += Get-CustomHeaderClose
    }
  }

  return $lunPathReport
}