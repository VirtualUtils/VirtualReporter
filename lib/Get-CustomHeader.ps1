function Get-CustomHeader ($Title, $cmnt) {
$Report = @"
	    <h2 class="dsp dsphead1">$($Title)</h2>
"@

If ($Comments) {
	$Report += @"
			<div class="dsp dspcomments">$($cmnt)</div>
"@
}

$Report += @"
        <div class="dspcont">
"@

return $Report
}