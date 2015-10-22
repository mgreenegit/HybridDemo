$Azure = Get-AutomationConnection -Name "Azure"
$Cert = Get-AutomationCertificate -Name $Azure.AutomationCertificateName

Set-AzureSubscription -Certificate $Cert -SubscriptionId $Azure.SubscriptionID
Select-AzureSubscription -SubscriptionId $Azure.SubscriptionID

#Select-AzureSubscription -default -SubscriptionId $Azure.SubscriptionID

<#
get-azurevm | ? name -like *prjx*
get-azurermpublicipaddress | ? name -like *prjx*
#invoke-command -computername 192.168.0.112,40.122.169.77 -ScriptBlock {get-service termservice} -Credential 
#>