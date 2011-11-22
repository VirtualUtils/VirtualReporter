# ---- VMs vCPU ----
function ShowvCPU () {

  if ($ShowvCPU) {

    Write-CustomOut "..Checking for VMs with over $vCPU vCPUs"

    $OverCPU = @($VM | Where {$_.NumCPU -gt $vCPU} | Select Name, PowerState, NumCPU)

    If (($OverCPU | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vCPUReport += Get-CustomHeader "VMs with over $vCPU vCPUs : $($OverCPU.count)" "The following VMs have over $vCPU CPU(s) and may impact performance due to CPU scheduling"
      $vCPUReport += Get-HTMLTable $OverCPU
      $vCPUReport += Get-CustomHeaderClose
    }
  }
  
  return $vCPUReport
}