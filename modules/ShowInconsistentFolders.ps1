# ---- VMs in inconsistent folders ----
function ShowInconsistentFolders () {

  if ($Showfolders){

    Write-CustomOut "..Checking VMs in Inconsistent folders"
    
    $VMFolder = @()

    foreach ($CHKVM in $FullVM){
      $Details = "" |Select-Object VM,Path
      $Folder = ((($CHKVM.Summary.Config.VmPathName).Split(']')[1]).Split('/'))[0].TrimStart(' ')
      $Path = ($CHKVM.Summary.Config.VmPathName).Split('/')[0]

      if ($CHKVM.Name-ne $Folder){
        $Details.VM= $CHKVM.Name
        $Details.Path= $Path
        $VMFolder += $Details
      }
    }

    if (($VMFolder | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $inconsistentFoldersReport += Get-CustomHeader "VMs in Inconsistent folders : $($VMFolder.count)" "The Following VM's are not stored in folders consistent to their names, this may cause issues when trying to locate them from the datastore manually"
      $inconsistentFoldersReport += Get-HTMLTable $VMFolder
      $inconsistentFoldersReport += Get-CustomHeaderClose
    }
  }
  
  return $inconsistentFoldersReport
}