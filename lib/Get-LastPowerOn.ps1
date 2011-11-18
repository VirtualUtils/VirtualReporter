function Get-LastPowerOn {
  param(
  [Parameter(
      Mandatory=$true,
      ValueFromPipeline=$true,
      HelpMessage="VM"
  )]
  [VMware.VimAutomation.Types.VirtualMachine]
  $VM
  )

  Process {
    # Patterns that indicate an attempt to power a VM on. This differ
    # across versions and likely across language. Please add your own
    # if you find one missing.
    $patterns = @(
            "*Power On virtual machine*",   # vCenter 4 English
            "*is starting*",                # ESX 4/3.5 English
            "*is powered on*"				# ESXi4.1U1 host, English, after reset event
    )

    $events = $VM | Get-VIEvent
    $qualifiedEvents = @()
    foreach ($pattern in $patterns) {
            $qualifiedEvents += $events | where { $_.FullFormattedMessage -like $pattern }
    }
    $qualifiedEvents = $qualifiedEvents | Where { $_ -ne $null }
    $sortedEvents = Sort-Object -InputObject $qualifiedEvents -Property CreatedTime -Descending
    $event = $sortedEvents | select -First 1

    if ($event) {
          return $event.createdTime
    }
  }
}