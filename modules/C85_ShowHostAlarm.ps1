# ---- Host Alarm ----
function ShowHostAlarm () {

  if ($ShowHostAlarm) {
    
    Write-CustomOut "..Checking Host Alarms"
    
    $alarms = $alarmMgr.GetAlarm($null)
    $valarms = $alarms | select value, @{N="name";E={(Get-View -Id $_).Info.Name}}
    $hostsalarms = @()

    foreach ($HostsView in $HostsViews) {
    
      if ($HostsView.TriggeredAlarmState) {
      
        $hostsTriggeredAlarms = $HostsView.TriggeredAlarmState

        foreach ($hostsTriggeredAlarm in $hostsTriggeredAlarms) {
          $Details = "" | Select-Object Object, Alarm, Status, Time
          $Details.Object = $HostsView.name
          $Details.Alarm = ($valarms |?{$_.value -eq ($hostsTriggeredAlarm.alarm.value)}).name
          $Details.Status = $hostsTriggeredAlarm.OverallStatus
          $Details.Time = $hostsTriggeredAlarm.time
          $hostsalarms += $Details
        }
      }
    }
    
    if (($hostsalarms | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostsalarms = @($hostsalarms |sort Object)
      
      $hostAlarmReport += Get-CustomHeader "Host(s) Alarm(s) : $($hostalarms.count)" "The following alarms have been registered against hosts in vCenter"
      $hostAlarmReport += Get-HTMLTable $hostsalarms
      $hostAlarmReport += Get-CustomHeaderClose
    }                 
  }
  
  return $hostAlarmReport
}