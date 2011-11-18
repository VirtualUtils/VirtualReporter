function Check-SSLCertificate () {
  #Found starting point here:
  #http://myitpath.blogspot.com/2010/03/checking-ssl-cert-values-with.html
  $myhostname = $args[0]
  $port = $args[1]
  
  $myObj = "" | select HostName, IssuedBy, Expires, Status
  
  try {
      $conn = new-object system.net.sockets.tcpclient($myhostname,$port)
  } catch {
      $myObj.Hostname = $myhostname
      $myObj.IssuedBy = "Unable to reach host on port $port"
      $myObj.Expires = "Unknown"
      $myObj.Status = "Error"
      return $myObj
  }
  if ($conn -ne $null) {
    $stream = new-object system.net.security.sslstream($conn.getstream())
    #send hostname on cert to try SSL negotiation
    try {
      $stream.authenticateasclient($myhostname) 2> $errorString
    } catch {
      $myObj.Hostname = $myhostname
      $myObj.IssuedBy = "SSL Failure - Unable to AuthenticateAsClient"
      $myObj.Expires = "Unknown"
      $myObj.Status = "Error"
      return $myObj
    }
    if ($?) {
      #if connection succeeds, get cert information
      $cert = $stream.get_remotecertificate()
            
      if ($stream.isauthenticated) {
        #stream is authenticated, so print out success and expiration information read from cert
        $validto = $cert.getexpirationdatestring()
        $issuer =  $cert.get_issuer()
        $expirationDays = (New-TimeSpan $date $validto).days
        
        $myObj.HostName = $myhostname
        $myObj.IssuedBy = $issuer.Replace(" DC=","").Replace("CN=","").Replace(",",".")
        $myObj.Expires = $validto
        if ($expirationDays -lt 45) {
          $myObj.Status = "Warning"
        } else {
          $myObj.Status = "Normal"
        }
        return $myObj
      }
    }
  }
}