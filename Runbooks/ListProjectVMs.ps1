$Azure = Get-AutomationConnection -Name "azure"
$Cert = Get-AutomationCertificate -Name $Azure.AutomationCertificateName

Select-AzureSubscription -default -SubscriptionId $Azure.SubscriptionID

get-azurevm | ? name -like *prjx*
get-azurermpublicipaddress | ? name -like *prjx*
#invoke-command -computername 192.168.0.112,40.122.169.77 -ScriptBlock {get-service termservice} -Credential 