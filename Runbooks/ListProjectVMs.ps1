$Azure = Get-AutomationConnection -Name 'Team'
$Cert = Get-AutomationCertificate -Name $Azure.AutomationCertificateName
$ID = $Azure.SubscriptionID
$admin = Get-AutomationPSCredential -Name 'VM Admin'

Set-AzureSubscription -SubscriptionName 'migreene' -SubscriptionId $ID -Certificate $Cert
Select-AzureSubscription -SubscriptionId $ID

$VMs = get-azurevm | ? name -like *prjx*

foreach ($VM in $VMs) {
	$vm | select name, servicename, status
	.\InstallWinRMCertAzureVM.ps1 -SubscriptionName 'migreene' -servicename $vm.servicename -vm $vm.name
	$IP = $vm | Get-AzureEndpoint | % VIP
	invoke-command -computername "$($vm.name).cloudapp.net" -ScriptBlock {get-service termservice | select pscomputername, displayname, status} -Credential $admin -usessl
}