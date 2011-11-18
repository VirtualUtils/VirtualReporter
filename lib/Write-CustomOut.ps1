
function Write-CustomOut ($Details){
	$LogDate = Get-Date -Format T
	Write-Host "$($LogDate) $Details"
}