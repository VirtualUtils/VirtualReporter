# ---- VMSwapfileDatastore not set----
function ShowSwapFile () {

  if ($ShowSwapFile) {

    Write-CustomOut "..Checking Host Swapfile datastores"
    $cluswap = @()
    
    foreach ($clusview in $clusviews) {
      if ($clusview.ConfigurationEx.VmSwapPlacement -eq "hostLocal") {
        $CluNodesViews = Get-VMHost -Location $clusview.name |Get-View
    
        foreach ($CluNodesView in $CluNodesViews) {
          if ($CluNodesView.Config.LocalSwapDatastore.Value -eq $null) {
            $Details = "" | Select-Object Cluster, Host, Message
            $Details.cluster = $clusview.name
            $Details.host = $CluNodesView.name
            $Details.Message = "Swapfile location NOT SET"
            $cluswap += $Details
          }
        }
      }
    }

    if (($cluswap | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $cluswap = $cluswap | sort name
      $swapFileReport += Get-CustomHeader "VMSwapfileDatastore(s) not set : $($cluswap.count)" "The following hosts are in a cluster which is set to store the swapfile in the datastore specified by the host but no location has been set on the host"
      $swapFileReport += Get-HTMLTable $cluswap
      $swapFileReport += Get-CustomHeaderClose
    }
  }
  
  return $swapFileReport
}