# ---- Num VM Per Datastore Check ----
function ShowNumVMPerDS () {

  if ($ShowNumVMPerDS){
   
    Write-CustomOut "..Checking Number of VMs per Datastore"

    $VMPerDS = @($Datastores | Select Name, @{N="NumVM";E={@($_ | Get-VM).Count}} | Where { $_.NumVM -gt $NumVMsPerDatastore} | Sort Name)

    if (($VMPerDS | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $numVMPerDSReport += Get-CustomHeader "Number of VMs per Datastore over $NumVMsPerDatastore : $($VMPerDS.count)" "The Maximum number of VMs per datastore is 256, the following VMs are above the defined $NumVMsPerDatastore and may cause performance issues"
      $numVMPerDSReport += Get-HTMLTable $VMPerDS
      $numVMPerDSReport += Get-CustomHeaderClose
    }                 
  }
  
  return $numVMPerDSReport
}