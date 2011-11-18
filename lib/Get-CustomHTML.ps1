Function Get-CustomHTML ($Header) {
$Report = @"
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html><head><title>$($Header)</title>
		<META http-equiv=Content-Type content='text/html; charset=windows-1252'>

		<style type="text/css">

		TABLE 		{
						TABLE-LAYOUT: fixed; 
						FONT-SIZE: 100%; 
						WIDTH: 100%
					}
		*
					{
						margin:0
					}

		.dspcont 	{
	
						BORDER-RIGHT: #bbbbbb 1px solid;
						BORDER-TOP: #bbbbbb 1px solid;
						PADDING-LEFT: 0px;
						FONT-SIZE: 8pt;
						MARGIN-BOTTOM: -1px;
						PADDING-BOTTOM: 5px;
						MARGIN-LEFT: 0px;
						BORDER-LEFT: #bbbbbb 1px solid;
						WIDTH: 95%;
						COLOR: #000000;
						MARGIN-RIGHT: 0px;
						PADDING-TOP: 4px;
						BORDER-BOTTOM: #bbbbbb 1px solid;
						FONT-FAMILY: Tahoma;
						POSITION: relative;
						BACKGROUND-COLOR: #f9f9f9
					}
					
		.filler 	{
						BORDER-RIGHT: medium none; 
						BORDER-TOP: medium none; 
						DISPLAY: block; 
						BACKGROUND: none transparent scroll repeat 0% 0%; 
						MARGIN-BOTTOM: -1px; 
						FONT: 100%/8px Tahoma; 
						MARGIN-LEFT: 43px; 
						BORDER-LEFT: medium none; 
						COLOR: #ffffff; 
						MARGIN-RIGHT: 0px; 
						PADDING-TOP: 4px; 
						BORDER-BOTTOM: medium none; 
						POSITION: relative
					}

		.pageholder	{
						margin: 0px auto;
					}
					
		.dsp
					{
						BORDER-RIGHT: #bbbbbb 1px solid;
						PADDING-RIGHT: 0px;
						BORDER-TOP: #bbbbbb 1px solid;
						DISPLAY: block;
						PADDING-LEFT: 0px;
						FONT-WEIGHT: bold;
						FONT-SIZE: 8pt;
						MARGIN-BOTTOM: -1px;
						MARGIN-LEFT: 0px;
						BORDER-LEFT: #bbbbbb 1px solid;
						COLOR: #FFFFFF;
						MARGIN-RIGHT: 0px;
						PADDING-TOP: 4px;
						BORDER-BOTTOM: #bbbbbb 1px solid;
						FONT-FAMILY: Tahoma;
						POSITION: relative;
						HEIGHT: 2.25em;
						WIDTH: 95%;
						TEXT-INDENT: 10px;
					}

		.dsphead0	{
						BACKGROUND-COLOR: #$($Colour1);
					}
					
		.dsphead1	{
						
						BACKGROUND-COLOR: #$($Colour2);
					}
					
	.dspcomments 	{
						BACKGROUND-COLOR:#FFFFE1;
						COLOR: #000000;
						FONT-STYLE: ITALIC;
						FONT-WEIGHT: normal;
						FONT-SIZE: 8pt;
					}

	td 				{
						VERTICAL-ALIGN: TOP; 
						FONT-FAMILY: Tahoma
					}
					
	th 				{
						VERTICAL-ALIGN: TOP; 
						COLOR: #$($Colour1); 
						TEXT-ALIGN: left
					}
					
	BODY 			{
						margin-left: 4pt;
						margin-right: 4pt;
						margin-top: 6pt;
					} 
	.MainTitle		{
						font-family:Arial, Helvetica, sans-serif;
						font-size:20px;
						font-weight:bolder;
					}
	.SubTitle		{
						font-family:Arial, Helvetica, sans-serif;
						font-size:14px;
						font-weight:bold;
					}
	.Created		{
						font-family:Arial, Helvetica, sans-serif;
						font-size:10px;
						font-weight:normal;
						margin-top: 20px;
						margin-bottom:5px;
					}
	.links			{	font:Arial, Helvetica, sans-serif;
						font-size:10px;
						FONT-STYLE: ITALIC;
					}
					
		</style>
	</head>
	<body>
<div class="MainTitle">$($Header)</div>
        <hr size="8" color="#$($Colour1)">
        <div class="SubTitle">vCheck v$($version) by Alan Renouf (<a href='http://virtu-al.net' target='_blank'>http://virtu-al.net</a>) generated on $($ENV:Computername)</div>
	    <br/>
		<div class="Created">Report created on $(Get-Date)</div>
"@
Return $Report
}