# ---- VM Host Uptime Warnings ----
function ShowHostUptime () {

  if ($CheckHostUptime) {

    Write-CustomOut "..Checking for Host Uptime warnings"
    
    $HostUptime = @()
    
    $VMH | Get-View | % {
      $myDetails = "" | select Host, "Uptime (days)", Status
      $uptime = New-TimeSpan $_.Runtime.BootTime $date
      $myDetails.Host = $_.name
      $myDetails."Uptime (days)" = $uptime.days

      if ($uptime.days -lt 3) {
        $myDetails.Status = "Recently Rebooted"
      } elseif ($uptime.days -gt 60) {
        $myDetails.Status = "Uptime over 60 days - verify security patch levels"
      } else {
        $myDetails.Status = "Normal"
      }

      if ($myDetails.Status -ne "Normal") {
        $HostUptime += $myDetails
      }
    }
    
    If (($HostUptime | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostUptimeReport += Get-CustomHeader "Host uptime warnings : $($HostUptime.count)" "The following hosts have uptime over 60 days (and may require security patches) or under 3 days (recently added/rebooted)."
      $hostUptimeReport += Get-HTMLTable $HostUptime
      $hostUptimeReport += Get-CustomHeaderClose
    }
  }
  
  return $hostUptimeReport
}