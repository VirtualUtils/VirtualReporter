param( [string] $VISRV)
###############################
# vCheck - Daily Error Report # 
###############################
# Thanks to all who have commented on my blog to help improve this project
# Especially - Thanks to Raphaël SCHITZ (http://www.hypervisor.fr/) for his contributions and time
# And also thanks to the many vExperts who have added suggestions for this report.
#
$Version = "5.40"
#
# Changes:
# Version 5.40- bwuch: Host version greater than/equal 4.1.0 and AD Auth not configured
# Version 5.39- bwuch: bug fixes from 5.38 version
# Version 5.38- bwuch: bug fix with 'connectionstate' warning
# Version 5.37- bwuch: added SYMC to VCB check for Symantec Backup Exec 2010
# Version 5.36- bwuch: changed snapshot function
# Version 5.35- bwuch: Added section with Powered Off VMs showing the last powered on date/event.
# Version 5.34- bwuch: Added the CBT tracking code provided by rhys on vCheck comments
# Version 5.33- bwuch: Modified Cluster config check to vCheck output format http://www.peetersonline.nl/index.php/vmware/check-vmware-configuration-with-powershell/
# Version 5.32- bwuch: Hack to make report look better in Outlook.
# Version 5.31- bwuch: Bug fix for LockdownMode
# Version 5.30- bwuch: Add check for VMtools installer connected
# Version 5.29- bwuch: Add check for VM capacity forecasting
# Version 5.28- bwuch: Change to Get-HTMLTable function for possible performance improvements
# Version 5.27- bwuch: Added host uptime check
# Version 5.26- bwuch: Added host OS pivot table
# Version 5.25- bwuch: Added SSL host and vCenter checks
# Version 5.24- bwuch: Change to output file name format
# Version 5.23- bwuch: Performance fix for mis-named VM check
# Version 5.22- bwuch: More changes to prevent 4.1.1 warnings
# Version 5.21- bwuch: Change code to prevent warnings when running with PowerCLI 4.1.1
# Version 5.20- bwuch: Add PowerCLI Version check and vCenter Update Manager host baseline compliance
# Version 5.19- bwuch: QA/QC bug check fix data issues
# Version 5.18- bwuch: Added Guest OS pivot table
# Version 5.16- bwuch: Added host hardware check
# Version 5.15- bwuch: changed variable name on cluster cpu allocation ratio check
# Version 5.14- bwuch: fixed quotes on VM limit check
# Version 5.13- bwuch: added sort to old VM hardware check
# Version 5.12- bwuch: QA/QC bug check; minor cosmetic fixes
# Version 5.11- bwuch: Added check for cluster CPU allocation ratio (ie vCPU to pCore)
# Version 5.10- bwuch: Added option to include all headers -- even on tests that return no results
# Version 5.09- bwuch: Added several additional checks listed on my blog http://enterpriseadmins.org/blog/?p=196
# Version 5.08- bwuch: Added fix from Leo to check for Free Space instead of capacity
# Version 5.07- bwuch: Added check for VMTools that need updated; provided by kevin, slight update by Traveller
# Version 5.06- bwuch: Added comment on how to specify multiple NTP servers as suggested by Mark
# Version 5.05- bwuch: Added check for unwanted hardware as suggested by Jon
# Version 5.04- bwuch: Added fix for select-object statement provided by Ccalvin
# Version 5.03- bwuch: Add VM resource limit check using code provided by Ed.
# Version 5.02- bwuch: Show VCB garbage bug fix from rvdnieuwendijk
# Version 5.01- bwuch: Show overallocation bug fix from James Davis
# Version 5.0 - Changed the order and a few titles etc, tidy up !
# Version 4.9 - Added Inacessable VMs
# Version 4.8 - Added HA VM restarts and resets
# Version 4.7 - VMTools Issues
# Version 4.6 - Added VCB Garbage
# Version 4.5 - Added Host config issues
# Version 4.4 - Added Disk Overcommit check
# Version 4.3 - Added vSwitch free ports check
# Version 4.2 - Added General Capacity Information based on CPU and MEM ussage per cluster
# Version 4.1 - Added the ability to change the colours of the report.
# Version 4.0 - HTML Tidy up, comments added for each item and the ability to enable/disable comments.
# Version 3.9 - Adjusted log checking to include ESXi Logs
# Version 3.8 - Added ESXi check for unsupported mode enabled
# Version 3.7 - Added ESXi check for Lockdown Mode Enabled
# Version 3.6 - Added VM Memory Swap and Ballooning
# Version 3.5 - Added Host Overcommit check
# Version 3.4 - Added Guest Disk check for space (MB)
# Version 3.3 - Added Size of snapshots
# Version 3.2 - Fixed Slot size information issue
# Version 3.1 - Added VMs with High CPU Usage
# Version 3.0 - Added VMs in mis-matched Folder names
# Version 2.9 - Added counts to each titlebar and output to screen whilst running for interactive mode
# Version 2.8 - Changed VC Services to show only unexpected status
# Version 2.7 - Added VMs with outdated Hardware - vSphere Only
# Version 2.6 - Added Slot size check - vSphere Only
# version 2.5 - Added report on Hosts in a HA cluster where the swapfile location is set, check the hosts
# Version 2.4 - Added VM/Host/Cluster Alerts
# Version 2.3 - Added VMs with over x amount of vCPUs
# Version 2.2 - Added Dead SCSILuns
# Version 2.1 - Now checks for VMs stored on storage available to only one host rather than local storage
# Version 2.0 - CPU Ready
# Version 1.17 - vmkernel host log file check for warnings
# Version 1.16 - NTP Server and service check
# Version 1.15 - DRSMigrations & Local Stored VMs
# Version 1.14 - Active/Inactive VMs
# Version 1.13 - Bug Fixes
# Version 1.12 - Added Hosts in Maintenance Mode and not responding + Bug Fixes
# Version 1.11 - Simplified mail function.
# Version 1.10 - Added How many days old the snapshots are
# Version 1.9 - Added ability to change user account which makes the WMI calls
# Version 1.8 - Added Real name resolution via AD and sorted disk space by PerfFree
# Version 1.7 - Added Event Logs for VMware warnings and errors for past day
# Version 1.6 - Add details to service state to see if it is expected or not
# Version 1.5 - Check for objects to see if they exist before sending the email + add VMs with No VMTools 

##-------------------------------------------
## Load config file
##-------------------------------------------
. .\config\vReporter_Config.ps1

##-------------------------------------------
## Load Script Libraries
##-------------------------------------------

# Define core and user module library folders
$coreLibHome = ".\lib\"
$modHome = ".\modules\"

# Load core libraries
Get-ChildItem ($coreLibHome + "*.ps1") | ForEach-Object {. (Join-Path $coreLibHome $_.Name)} | Out-Null

# Load report modules
$userMods = Get-ChildItem ($modHome + "*.ps1")
$userMods | ForEach-Object {. (Join-Path $modHome $_.Name)} | Out-Null

# Remove extension from module names, leaving a list of functions to call
$modsToCall = @()

foreach ($module in $userMods) {
  $modsToCall += $module.Name.substring(0, $module.Name.LastIndexOf("."))
}

##-------------------------------------------
# Start of script
##-------------------------------------------

# Turn off Errors
$ErrorActionPreference = "silentlycontinue"

# Check for passed vCenter Server
if ($VISRV -eq "") {
	Write-Host
	Write-Host "Please specify a VI Server name eg...."
	Write-Host "      powershell.exe vCheck.ps1 MyvCenter"
	Write-Host
	Write-Host
	exit
}

# If a username is configured, load the credentials
if ($SetUsername -ne ""){
	if ((Test-Path -Path $CredFile) -eq $false) {
		Set-Cred $CredFile
	}
  
	$creds = Get-Cred $SetUsername $CredFile
}

# PowerCLI Version Checker
if (!(Get-Command Get-PowerCLIVersion -errorAction SilentlyContinue)) {
	Write-Host "PowerCLI does not appear to be installed on this computer.  vCheck will not continue."
	send-SMTPmail -to $EmailTo -from $EmailFrom -subject "ERROR: $VISRV vCheck" -smtpserver $SMTPSRV -body "The Get-PowerCLIVersion Cmdlet was not found, please check your vCheck client machine [$($ENV:Computername)]."
	exit
}

# We need to know the version number even if it doesn't show up on the report
# Combine with above version check?
$powercliVersion = Get-PowerCliVersion

Write-CustomOut "Connecting to VI Server"
$VIServer = Connect-VIServer $VISRV

if ($VIServer.IsConnected -ne $true) {
	# Fix for scheduled tasks not running.
	$USER = $env:username
	$APPPATH = "C:\Documents and Settings\" + $USER + "\Application Data"

	# Set the appdata environment when needed
	if ($env:appdata -eq $null -or $env:appdata -eq 0) {
		$env:appdata = $APPPATH
	}

	$VIServer = Connect-VIServer $VISRV
	
  If ($VIServer.IsConnected -ne $true) {
		Write $VIServer
		send-SMTPmail -to $EmailTo -from $EmailFrom -subject "ERROR: $VISRV vCheck" -smtpserver $SMTPSRV -body "The Connect-VISERVER Cmdlet did not work, please check you VI Server."
		exit
	}
}

# Find out which version of the API we are connecting to
If ((Get-View ServiceInstance).Content.About.Version -ge "4.0.0") {
	$VIVersion = 4
} else {
	$VIVersion = 3
}

Write-CustomOut "Collecting VM Objects"
$VM = Get-VM | Sort Name

Write-CustomOut "Collecting Datacenter Objects"
$Datacenter = get-datacenter | sort name

Write-CustomOut "Collecting VM Host Objects"
$VMH = Get-VMHost | Sort Name

Write-CustomOut "Collecting Cluster Objects"
$Clusters = Get-Cluster | Sort Name

Write-CustomOut "Collecting Datastore Objects"
$Datastores = Get-Datastore | Sort Name

Write-CustomOut "Collecting Detailed VM Objects"
$FullVM = Get-View -ViewType VirtualMachine | Where {-not $_.Config.Template}

Write-CustomOut "Collecting Template Objects"
$VMTmpl = Get-Template

Write-CustomOut "Collecting Detailed VI Objects"
$serviceInstance = get-view ServiceInstance

Write-CustomOut "Collecting Detailed Alarm Objects"
$alarmMgr = get-view $serviceInstance.Content.alarmManager

Write-CustomOut "Collecting Detailed VMHost Objects"
$HostsViews = Get-View -ViewType hostsystem

$Date = Get-Date

# Check for vSphere
If ($serviceInstance.Client.ServiceContent.About.Version -ge 4) {
	$vSphere = $true
}

# Create report
$MyReport = Get-CustomHTML "$VIServer vCheck"
$MyReport += Get-CustomHeader0 ($VIServer.Name)

# Loop over all module names that are in the config folder
foreach ($module in $modsToCall) {
  $MyReport += Invoke-Expression $module
}

$MyReport += Get-CustomHeader0Close
$MyReport += Get-CustomHTMLClose

$VIServer | Disconnect-VIServer -Confirm:$false