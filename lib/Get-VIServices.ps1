function Get-VIServices {

	If ($SetUsername -ne ""){
		$Services = get-wmiobject win32_service -Credential $creds -ComputerName $VISRV | Where {$_.DisplayName -like "VMware*" }
	} Else {
		$Services = get-wmiobject win32_service -ComputerName $VISRV | Where {$_.DisplayName -like "VMware*" }
	}
	
	$myCol = @()
  
	Foreach ($service in $Services){
		$MyDetails = "" | select-Object Name, State, StartMode, Health
		If ($service.StartMode -eq "Auto")
		{
			if ($service.State -eq "Stopped")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "Unexpected State"
			}
		}
		If ($service.StartMode -eq "Auto")
		{
			if ($service.State -eq "Running")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "OK"
			}
		}
		If ($service.StartMode -eq "Disabled")
		{
			If ($service.State -eq "Running")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "Unexpected State"
			}
		}
		If ($service.StartMode -eq "Disabled")
		{
			if ($service.State -eq "Stopped")
			{
				$MyDetails.Name = $service.Displayname
				$MyDetails.State = $service.State
				$MyDetails.StartMode = $service.StartMode
				$MyDetails.Health = "OK"
			}
		}
		$myCol += $MyDetails
	}
	Write-Output $myCol
}