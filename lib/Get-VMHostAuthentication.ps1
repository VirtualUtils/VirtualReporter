function Get-VMHostAuthentication {
<#
.SYNOPSIS
  The function retrieves the authentication services from an ESX(i) host
.DESCRIPTION
  This function retrieves the configured authentication services from one
  or more ESX(i) hosts.
.NOTES
  Author: Luc Dekens
.PARAMETER VMHost
  Specify the ESX(i) host
.EXAMPLE
  PS> Get-VMHost | Get-VMHostAuthentication
.EXAMPLE
  PS> Get-VMHostAuthentication -VMHost (Get-VMHost)
#>
  param(
  [parameter(ValueFromPipeline = $true,Position=1,Mandatory = $true)]
  [VMware.VimAutomation.ViCore.Impl.V1.Inventory.VMHostImpl[]]$VMHost)

  process{
    if(!$VMHost){$VMHost = $_}
    foreach($esx in $VMHost){
      $filter = New-Object VMware.Vim.PropertyFilterSpec -Property @{
        ObjectSet = New-Object VMware.Vim.ObjectSpec -Property @{
          Obj = $esx.ExtensionData.ConfigManager.AuthenticationManager
        }
        PropSet = New-Object VMware.Vim.PropertySpec -Property @{
          Type = "HostAuthenticationManager"
          All = $true
        }
      }
      $collector = Get-View $esx.ExtensionData.Client.ServiceContent.PropertyCollector
      $content = $collector.RetrieveProperties($filter)
      $stores = $content | Select -First 1 | %{$_.PropSet} | where {$_.Name -eq "info"}
      foreach($authConfig in $stores.Val.AuthConfig){
        $row = New-Object PSObject
        $row | Add-Member -MemberType NoteProperty -Name Name -Value $null
        $row | Add-Member -MemberType NoteProperty -Name Type -Value $null
        $row | Add-Member -MemberType NoteProperty -Name Enabled -Value $null
        $row | Add-Member -MemberType NoteProperty -Name Domain -Value $null
        $row | Add-Member -MemberType NoteProperty -Name Membership -Value $null
        $row | Add-Member -MemberType NoteProperty -Name Trust -Value $null
        $row.Name = $esx.Name
        $row.Enabled = $authConfig.Enabled
        switch($authConfig.GetType().Name){
          'HostLocalAuthenticationInfo'{
            $row.Type = 'Local authentication'
          }
          'HostActiveDirectoryInfo'{
            $row.Type = 'Active Directory'
            $row.Domain = $authConfig.JoinedDomain
            $row.Membership = $authConfig.DomainMembershipStatus
            $row.Trust = $authConfig.TrustedDomain
          }
        }
        $row
      }
    }
  }
}