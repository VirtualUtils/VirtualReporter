#Cluster config check based on http://www.peetersonline.nl/index.php/vmware/check-vmware-configuration-with-powershell/
Function ShowClusterConfig () {

  if ($ShowClusterConfig) {

		ForEach ($Cluster in $Clusters) {
			Write-CustomOut "..Checking cluster $Cluster"
			$clusterVMHosts = $Cluster | Get-VMHost | Sort Name

			# If cluster has hosts, then process
			if ($clusterVMHosts) {
				$clusterVMHostViews = $clusterVMHosts | Get-View | Sort Name			
			
				if ($checkClusterDataStores) {
					Write-CustomOut "..  Datastore check"
					$myDSCol = @()
					$clustDatastores = Get-Datastore -VMHost $clusterVMHosts
					$DSdiffs = $clusterVMHosts | ForEach {Compare-Object $clustDatastores (Get-Datastore -VMHost $_) -SyncWindow 1000} | ForEach {$_.InputObject} | Sort Name | Select Name -Unique
					
					ForEach ($DSdiff in $DSdiffs) {
						if ($DSdiff.Name -ne $null -and $DSdiff.Name -notmatch "local")	{
							$myDSObj = "" | Select Datastore
							$myDSObj.Datastore = $DSdiff.Name
						
							ForEach ($clusterVMHost in $clusterVMHosts) {
								$myDSObj | Add-Member -MemberType NoteProperty -Name $clusterVMHost.Name -Value (!!(Get-Datastore -Name $myDSObj.Datastore -VMHost $clusterVMHost -ErrorAction SilentlyContinue))
							}
					
							$myDSCol += $myDSObj
						}
					}
					
					if (($myDSCol | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
						$ClusterConfigReport += Get-CustomHeader "Cluster $($Cluster.Name) Datastore Check $($myDSCol.Count)" "Datastores that are not visable by all hosts (excluding those with 'local' in the name)."
						$ClusterConfigReport += Get-HTMLTable $myDSCol
						$ClusterConfigReport += Get-CustomHeaderClose
					}
				}
				
				if ($checkClusterLUNs) {
					Write-CustomOut "..  SCSI LUN check"
					$myLUNCol = @()
					$LUNs = $clusterVMHostViews | ForEach {$_.Config.StorageDevice.ScsiLun | ForEach {$_.Uuid}} | Select -Unique
					$LUNdiffs = @()
				
					forEach ($clusterVMHostView in $clusterVMHostViews) {
						$HostLUNs = $clusterVMHostView.Config.StorageDevice.ScsiLun | ForEach {$_.Uuid} | Select -Unique
						$LUNdiffs += Compare-Object $LUNs $HostLUNs -SyncWindow 1000 | ForEach {$_.InputObject}
						Clear-Variable HostLUNs -ErrorAction SilentlyContinue
					}
				
					ForEach ($LUNdiff in ($LUNdiffs | Select -Unique | Sort)) {
						if ($LUNdiff -ne $null) {
							$myLUNObj = "" | Select LunUuid
							$myLUNObj.LunUuid = $LUNdiff
					
							ForEach ($clusterVMHostView in $clusterVMHostViews){
								$comparedLun = ($clusterVMHostView.Config.StorageDevice.ScsiLun | Where {$_.Uuid -eq $myLUNObj.LunUuid})
							
								if ($comparedLun -ne $null){
									$myLUNObj | Add-Member -MemberType NoteProperty -Name $clusterVMHostView.Name -Value ($comparedLun.Vendor.Trim() + " " + $comparedLun.Model.Trim() + " " + $comparedLun.CanonicalName)
								} Else {
									$myLUNObj | Add-Member -MemberType NoteProperty -Name $clusterVMHostView.Name -Value $False
								}
							}
						}
					
						$myLUNCol += $myLUNObj
					}
				
					If (($myLUNCol | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
						$ClusterConfigReport += Get-CustomHeader "Cluster $($Cluster.Name) LUN Check $($myLUNCol.Count)" "LUNs not presented to all hosts in a cluster (could cause issues with RDM devices)."
						$ClusterConfigReport += Get-HTMLTable $myLUNCol
						$ClusterConfigReport += Get-CustomHeaderClose
					}
				}
				
				if ($checkClusterPortGroups) {
					Write-CustomOut "..  Portgroup check"
				
					$myPGCol = @()
					$PortGroups = Get-VirtualPortGroup -VMHost $clusterVMHosts | ForEach {$_.Name} | Select -Unique
					$PGdiffs = @()
				
					ForEach ($clusterVMHost in $clusterVMHosts) {
						$HostPGs = Get-VirtualPortGroup -VMHost $clusterVMHost | ForEach {$_.Name} | Select -Unique
						$PGdiffs += Compare-Object $PortGroups $HostPGs -SyncWindow 1000 | ForEach {$_.InputObject}
						Clear-Variable HostPGs -ErrorAction SilentlyContinue
					}
				
					ForEach ($PGdiff in ($PGdiffs | Select -Unique | Sort)){
					
						if ($PGdiff -ne $null) {
							$myPGObj = "" | Select PortGroup
							$myPGObj.PortGroup = $PGdiff
					
							ForEach ($clusterVMHost in $clusterVMHosts){
								$myPGObj | Add-Member -MemberType NoteProperty -Name $clusterVMHost.Name -Value (!!(Get-VirtualPortGroup -Name $myPGObj.PortGroup -VMHost $clusterVMHost -ErrorAction SilentlyContinue))
							}
					
							$myPGCol += $myPGObj
						}
					}
				
					if (($myPGCol | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
						$ClusterConfigReport += Get-CustomHeader "Cluster $($Cluster.Name) Portgroup Check $($myPGCol.Count)" "Port Groups not presented to all hosts in a cluster (could cause issues with VMotion)."
						$ClusterConfigReport += Get-HTMLTable $myPGCol
						$ClusterConfigReport += Get-CustomHeaderClose
					}
				}
				
				if ($checkClusterBIOSVersions) {
					Write-CustomOut "..  BIOS check"
					$BIOSDiff = @()
				
					$clusterVMHostViews | %{			
						$row = "" |Select Name, "BIOS Version", "BIOS Date", "Cluster"
						$row.name = $_.name
						$biosTemp = ((($_.Runtime.HealthSystemRuntime.SystemHealthInfo.NumericSensorInfo | Where {$_.Name -like "*BIOS*"}).Name -split "BIOS ")[1] -split " ")
						$row."BIOS Version" = $biosTemp[0]
						$row."BIOS Date" = $biosTemp[1]
						$row.Cluster = $cluster.name
						$BIOSDiff += $row
					}
				
					$numBiosVersions = ($BIOSDiff | select "BIOS Version" -unique | Measure-Object).count
				
					if (($numBiosVersions -gt 1) -OR $ShowAllHeaders) {
						#This next if statement accounts for cases where ShowAllHeaders is True but the BIOS is not mis-matched
			
						if ($numBiosVersions -gt 1) {
							$ClusterConfigReport += Get-CustomHeader "Cluster $($Cluster.Name) BIOS Version Check" "The BIOS Versions of all hosts in this cluster are not at a consistent level."
							$ClusterConfigReport += Get-HTMLTable ($BIOSDiff | sort Name)
							$ClusterConfigReport += Get-CustomHeaderClose
						} else {
							$ClusterConfigReport += Get-CustomHeader "Cluster $($Cluster.Name) BIOS Version Check" "The BIOS Versions of all hosts in this cluster are not at a consistent level."
							$ClusterConfigReport += Get-HTMLTable $null
							$ClusterConfigReport += Get-CustomHeaderClose
						}
					}
				}
			} else {
				Write-CustomOut "..Cluster $Cluster has no hosts...Skipping."
			}
		}
  }
	
  return $ClusterConfigReport
}