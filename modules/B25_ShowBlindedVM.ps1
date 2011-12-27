# invalid or inaccessible VM
function ShowBlindedVM ([hashtable]$vCheckDataObjects) {

  if ($ShowBlindedVM) {

    Write-CustomOut "..Checking invalid or inaccessible VM"

    $BlindedVM = $vCheckDataObjects["FullVM"] |?{$_.Runtime.ConnectionState -eq "invalid" -or $_.Runtime.ConnectionState -eq "inaccessible"}|sort name |select name

    if (($BlindedVM | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $blindedVMReport += Get-CustomHeader "VM invalid or inaccessible : $(($BlindedVM | Measure-Object).count)" "The following VMs are marked as inaccessible or invalid"
      $blindedVMReport += Get-HTMLTable $BlindedVM
      $blindedVMReport += Get-CustomHeaderClose
    }
  }
  
  return $blindedVMReport
}