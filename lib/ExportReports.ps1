function ExportReports {

  #The following couple of lines verify that variables are in required formats
  Write-CustomOut "..Processing report export"
  
  if (-not (Test-Path $exportDirectory)) {
    md $exportDirectory | Out-Null
  }
  
  if ($EmailTo.Contains(",")) {
    $msgTo = $EmailTo.replace(" ","").split(",")
  } else {
    $msgTo = $EmailTo
  }

  #The following lines cause the report to export to a file.  The name changes based on the date/time the vCheck is executed. This is required if you plan to open the file or attach it to an email.  It is not required if you send the report in the body of the message.
  $Filename = $exportDirectory+"\"+$VISrv+"vCheck"+"_"+$date.ToString($dateFormat)+".htm"
  $MyReport | out-file -encoding ASCII -filepath $Filename

  #The following line causes the report to appear on screen (you must export to file in the above section too)
  Invoke-Item $Filename

  #uncomment the following line to send an email with the report included in the body
  #Send-MailMessage -Subject "$VISRV vCheck Report" -SmtpServer $SMTPSRV -From $EmailFrom  -To $msgTo -BodyAsHtml -Body $MyReport.Replace("class=`"dsp ","class=`"")

  #uncomment the following line to send an email with the report included as an attachment
  #Send-MailMessage -Attachments ($Filename) -Subject "$VISRV vCheck Report" -SmtpServer $SMTPSRV -From $EmailFrom -To $msgTo -BodyAsHtml -Body "Thank you for using vCheck $Version on $VISrv" #$MyReport.Replace("class=`"dsp ","class=`"") 

  #uncomment the following three lines to send an email with the report included in the body to an SMTP server that requires authentication
  #$smtpUsername = "mydomain\username"
  #$smtpPassword = "MySmtpPassw0rd" | ConvertTo-SecureString -asPlainText -Force
  #Send-MailMessage -Credential (New-Object System.Management.Automation.PSCredential($smtpUsername,$smtpPassword)) -Subject "$VISRV vCheck Report" -SmtpServer $SMTPSRV -From $EmailFrom  -To $msgTo -BodyAsHtml -Body $MyReport.Replace("class=`"dsp ","class=`"")
}