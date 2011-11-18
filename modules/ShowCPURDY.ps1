# ---- CPU %Ready Check ----
function ShowCPURDY () {

  if ($ShowCPURDY){
    
    Write-CustomOut "..Checking VM CPU %RDY"
    
    $myCol = @()

    foreach ($v in ($VM | Where {$_.PowerState -eq "PoweredOn"})){
      For ($cpunum = 0; $cpunum -lt $v.NumCpu; $cpunum++){
        $myObj = "" | Select VM, VMHost, CPU, PercReady
        $myObj.VM = $v.Name
        $myObj.VMHost = $v.VMHost
        $myObj.CPU = $cpunum
        $myObj.PercReady = [Math]::Round((($v | Get-Stat -ErrorAction SilentlyContinue -Stat Cpu.Ready.Summation -Realtime | Where {$_.Instance -eq $cpunum} | Measure-Object -Property Value -Average).Average)/200,1)
        $myCol += $myObj
      }                                                                                                                                                                                                                       
    }
    
    $rdycheck = @($myCol | Where {$_.PercReady -gt $PercCPUReady} | Sort PercReady -Descending)
    
    if (($rdycheck | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $cpuRDYReport += Get-CustomHeader "VM CPU % RDY over $PercCPUReady : $($rdycheck.count)" "The following VMs have high CPU RDY times, this can cause performance issues for more information please read <a href='http://communities.vmware.com/docs/DOC-7390' target='_blank'>This article</a>"
      $cpuRDYReport += Get-HTMLTable $rdycheck
      $cpuRDYReport += Get-CustomHeaderClose
    }
  }

  return $cpuRDYReport
}