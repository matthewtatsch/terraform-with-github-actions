### Set the following based on your preferences ###

$LOCATION = "centralus"
$PROJECT_ABBREV = "m11hghtftest" # lower case only
$TFSTATE_ABBREV = "tfstate" # lower case only
$SUBSCRIPTION_ID = "fd5a75aa-80d9-46b8-b688-dff5dbc5e13b"

###################################################

$SERVICE_PRINCIPAL_NAME = "${PROJECT_ABBREV}spn"
$RESOURCE_GROUP_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}rg"
$STORAGE_ACCOUNT_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}$(Get-Random -Minimum 100 -Maximum 999)st"
$CONTAINER_NAME = "${TFSTATE_ABBREV}"

# Create resource group
New-AzResourceGroup -Name $RESOURCE_GROUP_NAME -Location $LOCATION

# Create Service Principal and grant access to subscription
$sp = New-AzADServicePrincipal -DisplayName $SERVICE_PRINCIPAL_NAME
New-AzRoleAssignment -ApplicationId $sp.AppId -RoleDefinitionName "Contributor" -Scope "/subscriptions/${SUBSCRIPTION_ID}"

# Show service principal client secret
Write-Host $sp.PasswordCredentials.SecretText

# Create storage account and container to store Terraform state
$storageAccount = New-AzStorageAccount -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME `
                  -SkuName Standard_LRS -Location $LOCATION -AllowBlobPublicAccess $true

New-AzStorageContainer -Name $CONTAINER_NAME -Context $storageAccount.context -Permission blob