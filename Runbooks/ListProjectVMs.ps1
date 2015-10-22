Add-AzureAccount -Credential (Get-AutomationPSCredential -Name 'Subscription CoAdmin')
select-azuresubscription -subscriptionid '59f55e3c-d6f0-446b-ad86-20c35ba8abff' -default
get-azurevm | ? name -like *prjx*
get-azurermpublicipaddress | ? name -like *prjx*
#invoke-command -computername 192.168.0.112,40.122.169.77 -ScriptBlock {get-service termservice} -Credential 