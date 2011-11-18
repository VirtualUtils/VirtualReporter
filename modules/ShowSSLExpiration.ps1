# ---- SSL Certificate Checker ----
function ShowSSLExpiration () {

  if ($ShowSSLExpiration) {

    Write-CustomOut "..Checking for SSL Certificate Status"
    
    $MySslObj = @()
    $SslDetails = "" | Select HostName, IssuedBy, Expires, Status
    
    #First we will check the vCenter Server SSL Certificate
    $SslDetails = Check-SSLCertificate $VIServer.name $VIServer.Port
    
    if ($SslDetails.Status -ne "Normal") {
          $mySslObj += $SslDetails 
    }
    
    #Then we will check each host certificate.
    Foreach ($VMHost in $VMH) {
        $hview = $vmHost |get-view
        $SslDetails = "" | Select HostName, IssuedBy, Expires, Status
        $SslDetails = Check-SSLCertificate $VMHost.name $hview.Summary.Config.Port
        if ($SslDetails.Status -ne "Normal") {
          $mySslObj += $SslDetails 
        }
    }

    If (($MySslObj | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $sslExpirationReport += Get-CustomHeader "SSL Status Check : $($MySslObj.count)" "SSL Certificates should be replaced with ones issued from a trusted authority."
      $sslExpirationReport += Get-HTMLTable $MySslObj
      $sslExpirationReport += Get-CustomHeaderClose
    }
  }
  
  return $sslExpirationReport
}