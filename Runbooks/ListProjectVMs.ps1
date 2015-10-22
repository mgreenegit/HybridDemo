$Azure = Get-AutomationConnection -Name 'Team'
$Cert = Get-AutomationCertificate -Name $Azure.AutomationCertificateName
$ID = $Azure.SubscriptionID
$admin = Get-AutomationPSCredential -Name 'VM Admin'

Set-AzureSubscription -SubscriptionName 'migreene' -SubscriptionId $ID -Certificate $Cert
Select-AzureSubscription -SubscriptionId $ID

$VMs = get-azurevm | ? name -like *prjx*

$VMPublicDNSNames = @()

foreach ($VM in $VMs) {
	$vm | select name, servicename, status
	.\InstallWinRMCertAzureVM.ps1 -SubscriptionName 'migreene' -servicename $vm.servicename -vm $vm.name
	$IP = $vm | Get-AzureEndpoint | % VIP
	$VMPublicDNSNames += "$($vm.name).cloudapp.net"
}

invoke-command -computername $VMPublicDNSNames -ScriptBlock {get-service termservice} -Credential $admin -usessl  | select pscomputername, displayname, status