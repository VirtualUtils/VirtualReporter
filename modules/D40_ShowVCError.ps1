# ---- Virtual Center Event Logs - Error ----
function ShowVCError () {

  if ($ShowVCError) {
  
    Write-CustomOut "..Checking VC Error Event Logs"
    
    $ConvDate = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime([DateTime]::Now.AddDays(-$VCEvntlgAge))

    if ($SetUsername -ne ""){
      $ErrLogs = @(Get-WmiObject -Credential $creds -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Error' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
    } Else {
      $ErrLogs = @(Get-WmiObject -computer $VIServer -query ("Select * from Win32_NTLogEvent Where Type='Error' and TimeWritten >='" + $ConvDate + "'") | Where {$_.Message -like "*VMware*"} | Select @{N="TimeGenerated";E={$_.ConvertToDateTime($_.TimeGenerated)}}, Message)
    }
    
    if (($ErrLogs | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vcErrorReport += Get-CustomHeader "$VIServer Event Logs ($VCEvntlgAge day(s)): Error : $($ErrLogs.count)" "The following errors were found in the vCenter Event Logs, you may wish to check these further"
      $vcErrorReport += Get-HTMLTable ($ErrLogs)
      $vcErrorReport += Get-CustomHeaderClose
    }
  }
  
  return $vcErrorReport
}