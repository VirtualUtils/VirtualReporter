# ---- Virtual Center Event Logs - Warning ----
function ShowVCWarnings () {

  if ($ShowVCWarnings){
  
    Write-CustomOut "..Checking VC Warning Event Logs"
   
    $ConvDate = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime([DateTime]::Now.AddDays(-$VCEvntlgAge))

    if ($SetUsername -ne ""){
      $WarnLogs = @(Get-WmiObject -Credential $creds -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Warning' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
    } Else {
      $WarnLogs = @(Get-WmiObject -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Warning' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message )
    }

    if (($WarnLogs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vcWarningsReport += Get-CustomHeader "$VIServer Event Logs ($VCEvntlgAge day(s)): Warning : $($WarnLogs.count)" "The following warnings were found in the vCenter Event Logs, you may wish to check these further"
      $vcWarningsReport += Get-HTMLTable ($WarnLogs)
      $vcWarningsReport += Get-CustomHeaderClose
    }
  }
  
  return $vcWarningsReport
}