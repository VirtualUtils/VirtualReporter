# ---- VM Tools Issues ----
function ShowToolsIssues () {

  if ($ShowToolsIssues){
    
    Write-CustomOut "..Checking VM Tools Issues"
    
    $FailTools = $VM |Where {$_.Guest.State -eq "Running" -And ($_.Guest.OSFullName -eq $NULL -or $_.Guest.IPAddress -eq $NULL -or $_.Guest.HostName -eq $NULL -or $_.Guest.Disks -eq $NULL -or $_.Guest.Nics -eq $NULL)} |select -ExpandProperty Guest |select vmname,@{N= "IPAddress";E={$_.IPAddress[0]}},OSFullName,HostName,@{N="NetworkLabel";E={$_.nics[0].NetworkName}} -ErrorAction SilentlyContinue|sort VmName

    if (($FailTools | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $toolsIssuesReport += Get-CustomHeader "VM Tools Issues : $($FailTools.count)" "The following VMs have issues with VMtools, these should be checked and reinstalled if necessary"
      $toolsIssuesReport += Get-HTMLTable $FailTools
      $toolsIssuesReport += Get-CustomHeaderClose
    }
  }

  return $toolsIssuesReport
}