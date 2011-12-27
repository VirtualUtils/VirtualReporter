# ---- Datastore Information ----
function ShowData ([hashtable]$vCheckDataObjects) {

  if ($ShowData) {
    Write-CustomOut "..Checking Datastores"

    $OutputDatastores = @($vCheckDataObjects["Datastores"] | Get-DatastoreSummary | Sort PercFreeSpace)

    if (($OutputDatastores | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $showDataReport += Get-CustomHeader "Datastores (Less than $DatastoreSpace% Free) : $($OutputDatastores.count)" "Datastores which run out of space will cause impact on the virtual machines held on these datastores"
      $showDataReport += Get-HTMLTable $OutputDatastores
      $showDataReport += Get-CustomHeaderClose
    }
  }

  return $showDataReport
}