$Azure = Get-AutomationConnection -Name 'Team'
$Cert = Get-AutomationCertificate -Name $Azure.AutomationCertificateName
$ID = $Azure.SubscriptionID
$admin = Get-AutomationPSCredential -Name 'VM Admin'

Set-AzureSubscription -SubscriptionName 'migreene' -SubscriptionId $ID -Certificate $Cert
Select-AzureSubscription -SubscriptionId $ID

$VMs = get-azurevm | ? name -like *prjx*

$return = @()

$Status = foreach ($VM in $VMs) {
	$node = $vm | select @{Name='VirtualMachine';Expression={$_.name}}, @{Name='VirtualMachineStatus';Expression={$_.status}}
	.\InstallWinRMCertAzureVM.ps1 -SubscriptionName 'migreene' -servicename $vm.servicename -vm $vm.name
	$ServiceCheck = invoke-command -computername "$($vm.name).cloudapp.net" -ScriptBlock {get-service termservice} -Credential $admin -usessl
	$node | Add-Member -MemberType NoteProperty -Name 'ApplicationService' -Value $ServiceCheck.displayname
	$node | Add-Member -MemberType NoteProperty -Name 'ApplicationServiceState' -Value $ServiceCheck.status 
	$return += $node
}

Write-Host $return