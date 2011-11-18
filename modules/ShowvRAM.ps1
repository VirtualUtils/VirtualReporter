function ShowvRAM () {

  if ($ShowvRAM) {

    Write-CustomOut "..Checking vRAM Allocations"

    #Function by @LUCD http://www.lucd.info/2011/07/13/query-vram/
    function Get-vRAMInfo{
      $memoryCapMB = 96 * 1KB
      $vRAMtab = @{
        "esxEssentials"=32;
        "esxEssentialsPlus"=32;
        "esxFull"=32;
        "esxAdvanced"=32;
        "esxEnterprise"=64;
        "esxEnterprisePlus"=96
      }
    
      $licMgr = Get-View LicenseManager
      $licAssignMgr = Get-View $licMgr.LicenseAssignmentManager
    
      $totals = @{}
    
      $VMH | %{
        $lic = $licAssignMgr.QueryAssignedLicenses($_.Extensiondata.MoRef.Value)
        $licType = $lic[0].AssignedLicense.EditionKey
        $totalvRAM = ($vRAMtab[$licType] * $_.Extensiondata.Hardware.CpuInfo.NumCpuPackages)
    
        $VMsPerHost = Get-VM -Location $_
        $vmRAMConfigured = ($VMsPerHost | `
        
        Select -Property @{N="CappedMemoryMB";
          E={if($_.MemoryMB -lt $memoryCapMB){$_.MemoryMB}else{$memoryCapMB}}} | `
          Measure-Object -Property CappedMemoryMB -Sum).Sum/1KB
        
        $vmRAMUsed = ($VMsPerHost | where {$_.PowerState -eq "PoweredOn"} | `
          Select -Property @{N="CappedMemoryMB";
          E={if($_.MemoryMB -lt $memoryCapMB){$_.MemoryMB}else{$memoryCapMB}}} | `
          Measure-Object -Property CappedMemoryMB -Sum).Sum/1KB
    
        if ($totals.ContainsKey($licType)){
          $totals[$licType].vRAMEntitled += $totalvRAM
          $totals[$licType].vRAMConfigured += $vmRAMConfigured
          $totals[$licType].vRAMUsed += $vmRAMUsed
        } else{
          $totals[$licType] = New-Object PSObject -Property @{
            vCenter = $defaultVIServer.Name
            LicenseType = $lic[0].AssignedLicense.Name
            vRAMEntitled = $totalvRAM
            vRAMConfigured = $vmRAMConfigured
            vRAMUsed = $vmRAMUsed
          }
        }
      }
      $totals.GetEnumerator() | %{
        New-Object PSObject -Property @{
          vCenter = $_.Value.vCenter
          LicenseType = $_.Value.LicenseType
          vRAMEntitled = $_.Value.vRAMEntitled
          vRAMConfigured = [Math]::Round($_.Value.vRAMConfigured,1)
          vRAMUsed = [Math]::Round($_.Value.vRAMUsed,1)
        }
      }
    }
    
    $vRAM = Get-vRAMInfo | Select vRAMConfigured, vRAMUsed, vRAMEntitled, LicenseType
    
    if (($vRAM | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $vRAMReport += Get-CustomHeader "vRAM Allocations" "The following section shows your configured, used and entitled vRAM allocations."
      $vRAMReport += Get-HTMLTable $vRAM
      $vRAMReport += Get-CustomHeaderClose
    }
  }
  
  return $vRAMReport
}