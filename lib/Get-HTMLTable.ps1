Function Get-HTMLTable {
	param([array]$Content)
  
	$HTMLTable = $Content | ConvertTo-Html -Fragment
	$HTMLTable = $HTMLTable -replace '&lt;', "<"
	$HTMLTable = $HTMLTable -replace '&gt;', ">"
  
	Return $HTMLTable
}