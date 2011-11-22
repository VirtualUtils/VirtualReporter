# ---- ESXi Technical Support Mode ----
function ShowHostsTechSupportEnabled () {
  if ($ShowTech) {
    
    Write-CustomOut "..Checking for ESXi with Technical Support mode enabled"
    
    $ESXiTechMode = $VMH | Where {$_.ConnectionState -eq "Connected" -or $_.ConnectionState -eq "Maintenance"} | Get-View | Where {$_.Summary.Config.Product.Name -match "i"} | Select Name, @{N="TechSuportModeEnabled";E={(Get-VMHost $_.Name | Get-VMHostAdvancedConfiguration -Name VMkernel.Boot.techSupportMode).Values}}
    $ESXTech = @($ESXiTechMode | Where { $_.TechSuportModeEnabled -eq "True" })
    
    if (($ESXTech | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $hostsTechSupportEnabledReport += Get-CustomHeader "ESXi Hosts with Tech Support Mode Enabled : $($ESXTech.count)" "The following ESXi Hosts have Technical support mode enabled, this may not be the best security option, see here for more information: <a href='http://www.yellow-bricks.com/2010/03/01/disable-tech-support-on-esxi/' target='_blank'>Yellow-Bricks Disable Tech Support on ESXi</a>."
      $hostsTechSupportEnabledReport += Get-HTMLTable $ESXTech
      $hostsTechSupportEnabledReport += Get-CustomHeaderClose	
    }
  }

  return $hostsTechSupportEnabledReport
}