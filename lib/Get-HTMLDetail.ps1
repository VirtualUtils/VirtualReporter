Function Get-HTMLDetail ($Heading, $Detail){
$Report = @"
  <TABLE>
    <tr>
    <th width='50%'><b>$Heading</b></font></th>
    <td width='50%'>$($Detail)</td>
    </tr>
  </TABLE>
"@

Return $Report
}