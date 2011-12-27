# ---- Datastore OverAllocation ----
function ShowDataStoreOverAllocation ([hashtable]$vCheckDataObjects) {

  if ($ShowOverAllocation) {
  
    Write-CustomOut "..Checking Datastore OverAllocation"
    
    $dataStoreViews = $vCheckDataObjects["Datastores"] | Get-View
    $voverallocation = @()
    
    foreach ($dataStore in $dataStoreViews) {
      if ($dataStore.Summary.Uncommitted -gt "0") {
        $Details = "" | Select-Object Datastore, Overallocation
        $Details.Datastore = $dataStore.name
        $Details.overallocation = [math]::round(((($dataStore.Summary.Capacity - $dataStore.Summary.FreeSpace) + $dataStore.Summary.Uncommitted)*100)/$dataStore.Summary.Capacity,0)
      
        if ($Details.overallocation -gt $OverAllocation) {
          $voverallocation += $Details
          }
      }
    }
    
    If (($voverallocation | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $dataStoreOverAllocationReport += Get-CustomHeader "Datastore OverAllocation % over $OverAllocation : $($voverallocation.count)" "The following datastores may be overcommitted it is strongly sugested you check these"
      $dataStoreOverAllocationReport += Get-HTMLTable $voverallocation
      $dataStoreOverAllocationReport += Get-CustomHeaderClose
    }			
  }
  
  return $dataStoreOverAllocationReport
}