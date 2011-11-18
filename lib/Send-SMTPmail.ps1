#function Send-SMTPmail($to, $from, $subject, $smtpserver, $body) {
#	$mailer = new-object Net.Mail.SMTPclient($smtpserver)
#	$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)
#	$msg.IsBodyHTML = $true
#	$mailer.send($msg)
#}
function Send-SMTPmail($to, $from, $subject, $smtpserver, $body, $attachment) {
	$mailer = new-object Net.Mail.SMTPclient($smtpserver)
	$msg = new-object Net.Mail.MailMessage($from,$to,$subject,$body)
	$msg.IsBodyHTML = $true
	$attachment = new-object Net.Mail.Attachment($attachment)
	$msg.attachments.add($attachment)
	$mailer.send($msg)
}