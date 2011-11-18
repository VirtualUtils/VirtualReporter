# ---- Hosts VMware Update Manager Baseline non-compliance ---- 
function ShowHostVUMNonCompliance () {

  if ($ShowHostVUMNonCompliance) {

    Write-CustomOut "..Checking Hosts VMware Update Manager Baseline non-compliance"
    
    $vHostVUMNonCompliance = @()

    if ($powerclivumVersion -eq $null) {
      Write-CustomOut "..WARNING: vCenter Update Manager cmdlets not found."
      $myObj = "" | Select Warning
      $myObj.Warning = "vCenter Update Manager cmdlets not found, unable to process this check"
      $vHostVUMNonCompliance += $myObj
    } else {
      $NonCompliance = $VMH | Get-Compliance | Where-Object {$_.Status -ne "Compliant"}

      foreach ($ncHost in $NonCompliance) {
        $myObj = "" | select Host, Baseline, Status
        $myObj.Host = $ncHost.Entity
        $myObj.Baseline = $ncHost.Baseline.Name
        $myObj.Status = $ncHost.Status
        $vHostVUMNonCompliance += $myObj
      }
    }

    If (($vHostVUMNonCompliance | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostVUMNonComplianceReport += Get-CustomHeader "Hosts VMware Update Manager Baseline non-compliance : $($vHostVUMNonCompliance.count)" "The following hosts are not compliant to the attached baselines"
      $hostVUMNonComplianceReport += Get-HTMLTable $vHostVUMNonCompliance
      $hostVUMNonComplianceReport += Get-CustomHeaderClose
    }
  }
  
  return $hostVUMNonComplianceReport
} 