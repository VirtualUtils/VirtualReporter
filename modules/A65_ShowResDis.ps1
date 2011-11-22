# ---- Hosts Not responding or Disconnected ----
function ShowResDis () {
  
  if ($ShowResDis) {
    Write-CustomOut "..Checking Hosts Not responding or Disconnected"
    
    $RespondHosts = @($VMH | where {$_.ConnectionState -ne "Connected" -and $_.ConnectionState -ne "Maintenance"} | get-view | Select name, @{N="Connection State";E={$_.Runtime.ConnectionState}}, @{N="Power State";E={$_.Runtime.PowerState}})
    
    If (($RespondHosts | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $ResDisReport += Get-CustomHeader "Hosts not responding or disconnected : $($RespondHosts.count)" "Hosts which are in a disconnected state will not be running any virtual machine worloads, check the below Hosts are in an expected state"
      $ResDisReport += Get-HTMLTable $RespondHosts
      $ResDisReport += Get-CustomHeaderClose
    }
  }
  
  return $ResDisReport
}