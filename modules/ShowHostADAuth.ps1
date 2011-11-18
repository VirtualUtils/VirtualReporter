# ---- Hosts without AD Auth Enabled ----
function ShowHostADAuth () {

  if ($ShowHostADAuth) {
    
    Write-CustomOut "..Checking Host AD Authentication"			
    
    $myObj = @()
    $VMH | Where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"} | %{

    if ($_.Version -ge "4.1.0") {
        if ((Get-VMHostAuthentication $_ | where {$_.type -eq "Active Directory" }).enabled -eq $false) {
          $myitem = "" | select VMHost, Description
          $myitem.VMHost = $_.Name
          $myitem.Description = "Host supports AD authentication but it is not configured."
          $myObj += $myitem
        }
      } else {
        $myitem = "" | select VMHost, Description
        $myitem.VMHost = $_.Name
        $myitem.Description = "Host version is less than 4.1.0 and does not support AD authentication.  Consider upgrading to 4.1"
        $myObj += $myitem
      }
    }

    If (($myObj | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostADAuthReport += Get-CustomHeader "4.1 hosts without AD Authentication configured : $($myObj.count)" "ESX/ESXi 4.1 and higher support Active Directory Authentication but this host is not configured for that feature."
      $hostADAuthReport += Get-HTMLTable $myObj
      $hostADAuthReport += Get-CustomHeaderClose
    }
  }
  
  return $hostADAuthReport
}