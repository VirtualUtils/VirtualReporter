# ---- Host hardware issues ----
# bwuch Hardware request feature request from RobVM
# with help from http://spininfo.homelinux.com/news/vSphere_PowerCLI/2009/12/13/Vsphere_Host_Health_status_-_VI_SDK
function ShowHostHdwrIssues () {

  if ($ShowHostHdwrIssues) {
  
    Write-CustomOut "..Checking host hardware issues"
    $MyObj = @()

    foreach ($hdwrCheckHost in $VMH) {
      $esx = Get-VMHost $hdwrCheckHost | Get-View
      $systemHealthInfo = $esx.Runtime.HealthSystemRuntime.SystemHealthInfo

      for($i = 0; $i -lt $systemHealthInfo.NumericSensorInfo.Count; $i++){
        if ($systemHealthInfo.NumericSensorInfo[$i].HealthState.key -ne "green") {
          $Details = "" | Select Host, SensorName, SensorType, SensorStatus
          $Details.Host = $hdwrCheckHost
          $Details.SensorName = $systemHealthInfo.NumericSensorInfo[$i].Name
          $Details.SensorType = $systemHealthInfo.NumericSensorInfo[$i].SensorType
          $Details.SensorStatus = $systemHealthInfo.NumericSensorInfo[$i].HealthState.key
          $myObj += $Details
        }
      }
    }
    
    If (($myObj | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostHdwrIssuesReport += Get-CustomHeader "Hosts with hardware sensor issues : $($myObj.count)" "Non-green status on host hardware sensors may indicate a possible hardware issue and may require investigation."
      $hostHdwrIssuesReport += Get-HTMLTable $myObj
      $hostHdwrIssuesReport += Get-CustomHeaderClose
    }
  }
  
  return $hostHdwrIssuesReport
}