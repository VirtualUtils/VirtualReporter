# ---- Host ConfigIssue ----
function ShowHostCIAlarm () {

  if ($ShowHostCIAlarm){

    Write-CustomOut "..Checking Host Configuration Issues"
    
    $hostcialarms = @()

    foreach ($HostsView in $HostsViews) {
      if ($HostsView.ConfigIssue) {           
        $HostConfigIssues = $HostsView.ConfigIssue

        foreach ($HostConfigIssue in $HostConfigIssues) {
          $Details = "" | Select-Object Name, Reason, Message
          $Details.name = $HostsView.name
          $Details.Reason = $HostConfigIssue.Reason
          $Details.Message = $HostConfigIssue.FullFormattedMessage
          $hostcialarms += $Details
        }
      }
    }

    if (($hostcialarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostcialarms = $hostcialarms | sort name
      $hostCIAlarmReport += Get-CustomHeader "Host(s) Config Issue(s) : $($hostcialarms.count)" "The following configuration issues have been registered against Hosts in vCenter"
      $hostCIAlarmReport += Get-HTMLTable $hostcialarms
      $hostCIAlarmReport += Get-CustomHeaderClose
    }
  }

  return $hostCIAlarmReport
}