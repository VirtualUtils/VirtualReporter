# ---- NTP Check ----
function ShowNTPCheck () {
  
  if ($ShowNTP) {
  
    Write-CustomOut "..Checking NTP Name and Service"
    
    $NTPCheck = @($VMH | Where {$_.ConnectionState -ne "Disconnected"} | Select Name, @{N="NTPServer";E={$_ | Get-VMHostNtpServer}}, @{N="ServiceRunning";E={(Get-VmHostService -VMHost $_ | Where-Object {$_.key -eq "ntpd"}).Running}} | Where {$_.ServiceRunning -eq $false -or $_.NTPServer -notmatch $ntpserver})

    If (($NTPCheck | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $ntpCheckReport += Get-CustomHeader "NTP Issues : $($NTPCheck.count)" "The following hosts do not have the correct NTP settings of $ntpserver and may cause issues if the time becomes far apart from the vCenter/Domain or other hosts"
      $ntpCheckReport += Get-HTMLTable $NTPCheck
      $ntpCheckReport += Get-CustomHeaderClose
    }
  }
}