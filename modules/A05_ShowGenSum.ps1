# ---- General Summary Info ----
function ShowGenSum([hashtable]$vCheckDataObjects) {

  if ($ShowGenSum) {

    Write-CustomOut "..Adding General Summary Info to the report"

    $CommentsSet = $Comments
    $Comments = $false
    $genSumReport += Get-CustomHeader "General Details" ""
    $genSumReport += Get-HTMLDetail "Number of Hosts:" $vCheckDataObjects["VMH"].Count
    $genSumReport += Get-HTMLDetail "Number of VMs:" $vCheckDataObjects["VM"].Count
    $genSumReport += Get-HTMLDetail "Number of Templates:" $vCheckDataObjects["VMTmpl"].Count
    $genSumReport += Get-HTMLDetail "Number of Clusters:" $vCheckDataObjects["Clusters"].Count
    $genSumReport += Get-HTMLDetail "Number of Datastores:" $vCheckDataObjects["Datastores"].Count
    $genSumReport += Get-HTMLDetail "Active VMs:" ($vCheckDataObjects["FullVM"] |  Where { $_.Runtime.PowerState -eq "poweredOn" }).Count
    $genSumReport += Get-HTMLDetail "In-active VMs:" ($vCheckDataObjects["FullVM"] |  Where { $_.Runtime.PowerState -eq "poweredOff" }).Count
    $genSumReport += Get-HTMLDetail "DRS Migrations for last $($DRSMigrateAge) Days:" @(Get-VIEvent -maxsamples 10000 -Start ($vCheckDataObjects["date"]).AddDays(-$DRSMigrateAge ) | where {$_.Gettype().Name -eq "DrsVmMigratedEvent"}).Count
    $Comments = $CommentsSet
    $genSumReport += Get-CustomHeaderClose
  }
  
  return $genSumReport
}