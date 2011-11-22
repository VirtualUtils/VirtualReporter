# ---- ESXi Lockdown Mode ----
function ShowHostsLockDown () {
  if ($Lockdown){	
   
    Write-CustomOut "..Checking for ESXi hosts which do not have Lockdown mode enabled"
    
    $ESXiLockDown = $VMH | Where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"} | Get-View | Where {$_.Summary.Config.Product.Name -match "i"} | Select Name, @{N="LockedMode";E={$_.Config.AdminDisabled}}
    $ESXiUnlocked = @($ESXiLockDown | Where { $_.LockedMode -ne "False" })
    
    if (($ESXiUnlocked | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostsLockDownReport += Get-CustomHeader "ESXi Hosts with Lockdown Mode not Enabled : $($ESXiUnlocked.count)" "The following ESXi Hosts do not have lockdown enabled, think about using Lockdown as an extra security feature."
      $hostsLockDownReport += Get-HTMLTable $ESXiUnlocked
      $hostsLockDownReport += Get-CustomHeaderClose	
    }
    
    return $hostsLockDownReport
  }
}