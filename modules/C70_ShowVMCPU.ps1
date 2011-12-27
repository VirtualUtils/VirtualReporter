# ---- VM CPU Check ----
function ShowVMCPU ([hashtable]$vCheckDataObjects) {

  if ($ShowVMCPU) {
    
    Write-CustomOut "..Checking VM CPU Usage"
    
    $VMCPU = $vCheckDataObjects["VM"] | Select Name, @{N="AverageCPU";E={[Math]::Round(($_ | Get-Stat -ErrorAction SilentlyContinue -Stat cpu.usage.average -Start (($vCheckDataObjects["date"]).AddDays(-$CPUDays)) -Finish ($vCheckDataObjects["date"]) | Measure-Object -Property Value -Average).Average)}}, NumCPU, VMHost | Where {$_.AverageCPU -gt $CPUValue} | Sort AverageCPU -Descending

    if (($VMCPU | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vmCPUReport += Get-CustomHeader "VM(s) CPU above $CPUValue : $($VMCPU.count)" "The following VMs have high CPU usage and may have rogue guest processes or not enough CPU resource assigned"
      $vmCPUReport += Get-HTMLTable $VMCPU
      $vmCPUReport += Get-CustomHeaderClose
    }                 
  }

  return $vmCPUReport
}