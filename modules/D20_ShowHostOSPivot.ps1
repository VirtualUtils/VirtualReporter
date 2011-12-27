# ---- VM Host OS Pivot Table ----
function ShowHostOSPivot ([hashtable]$vCheckDataObjects) {

  if ($HostOSPivot) {
  
    Write-CustomOut "..Creating Host OS Pivot table"
    
    $HostOSversions = @{}

    $vCheckDataObjects["VMH"] | Get-View | % {
      $HostOSVersion = $_.Summary.Config.Product.FullName
      $HostOSversions.$HostOSversion++
    }
    
    $myCol = @()
    
    foreach ( $hosname in $HostOSversions.Keys | sort) {
      $MyDetails = "" | select OS, Count
      $MyDetails.OS = $hosname
      $MyDetails.Count = $HostOSversions.$hosname
      $myCol += $MyDetails
    }
    
    $vHostOSversions = $myCol | sort Count -desc

    if (($vHostOSversions | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
			$countHostOSVersions = ($vHostOSversions | Measure-Object).count
			$osPivotReport += Get-CustomHeader "Host Build versions in use : $countHostOSVersions" "The following host builds are in use in this vCenter."
      $osPivotReport += Get-HTMLTable $vHostOSversions
      $osPivotReport += Get-CustomHeaderClose
    }
  }
  
  return $osPivotReport
}