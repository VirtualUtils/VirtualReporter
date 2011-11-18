function Get-DatastoreSummary {
	param(
		$InputObject = $null
	)
	process {
		if ($InputObject -and $_) {
			throw 'The input object cannot be bound to any parameters for the command either because the command does not take pipeline input or the input and its properties do not match any of the parameters that take pipeline input.'
			return
		}
		$processObject = $(if ($InputObject) {$InputObject} else {$_})
		if ($processObject) {
			$myCol = @()
			foreach ($ds in $_)
			{
				$MyDetails = "" | select-Object Name, CapacityMB, FreeSpaceMB, PercFreeSpace
				$MyDetails.Name = $ds.Name
				#$MyDetails.Type = $ds.Type
				$MyDetails.CapacityMB = $ds.CapacityMB
				$MyDetails.FreeSpaceMB = $ds.FreeSpaceMB
				$MyDetails.PercFreeSpace = [math]::Round(((100 * ($ds.FreeSpaceMB)) / ($ds.CapacityMB)),0)
				$myCol += $MyDetails
			}
			$myCol | Where { $_.PercFreeSpace -lt $DatastoreSpace }
		}
	}
	end {
	}
}