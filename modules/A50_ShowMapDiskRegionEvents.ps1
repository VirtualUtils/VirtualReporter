# ---- Map disk region ----
function ShowMapDiskRegionEvents () {

  if ($ShowMapDiskRegionEvents) {
  
    Write-CustomOut "..Checking for Map disk region event"
    
    $MapDiskRegionEvents = @($VIEvent | Where {$_.FullFormattedMessage -match "Map disk region"} | Foreach {$_.vm}|select name |Sort-Object -unique)
    
    If (($MapDiskRegionEvents | Measure-Object).count -gt 0 -or $ShowAllHeaders) {
      $mapDiskRegionEventsReport += Get-CustomHeader "Map disk region event (Last $VMsNewRemovedAge Day(s)) : $($MapDiskRegionEvents.count)" "These may occur due to VCB issues, check <a href='http://kb.vmware.com/kb/1007331' target='_blank'>this article</a> for more details "
      $mapDiskRegionEventsReport += Get-HTMLTable $MapDiskRegionEvents
      $mapDiskRegionEventsReport += Get-CustomHeaderClose
    }
  }
  
  return $mapDiskRegionEventsReport
}