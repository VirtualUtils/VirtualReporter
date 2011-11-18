# ---- General Summary Info ----
function ShowGenSum() {

  if ($ShowGenSum) {

    Write-CustomOut "..Adding General Summary Info to the report"

    $CommentsSet = $Comments
    $Comments = $false
    $genSumReport += Get-CustomHeader "General Details" ""
    $genSumReport += Get-HTMLDetail "Number of Hosts:" (@($VMH).Count)
    $genSumReport += Get-HTMLDetail "Number of VMs:" (@($VM).Count)
    $genSumReport += Get-HTMLDetail "Number of Templates:" (@($VMTmpl).Count)
    $genSumReport += Get-HTMLDetail "Number of Clusters:" (@($Clusters).Count)
    $genSumReport += Get-HTMLDetail "Number of Datastores:" (@($Datastores).Count)
    $genSumReport += Get-HTMLDetail "Active VMs:" (@($FullVM | Where { $_.Runtime.PowerState -eq "poweredOn" }).Count) 
    $genSumReport += Get-HTMLDetail "In-active VMs:" (@($FullVM | Where { $_.Runtime.PowerState -eq "poweredOff" }).Count)
    $genSumReport += Get-HTMLDetail "DRS Migrations for last $($DRSMigrateAge) Days:" @(Get-VIEvent -maxsamples 10000 -Start ($Date).AddDays(-$DRSMigrateAge ) | where {$_.Gettype().Name -eq "DrsVmMigratedEvent"}).Count
    $Comments = $CommentsSet
    $genSumReport += Get-CustomHeaderClose
  }
  
  return $genSumReport
}