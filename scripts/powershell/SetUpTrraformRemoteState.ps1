$LOCATION = "centralus"
# $SUBSCRIPTION = "Matthew Tatsch - Internal Sandbox" # can be name or ID

# The combined length of $PROJECT_ABBREV and $TFSTATE_ABBREV must be 21 characters or less
$PROJECT_ABBREV = "m11hghtftest" # lower case only
$TFSTATE_ABBREV = "tfstate" # lower case only

$SERVICE_PRINCIPAL_NAME = "${PROJECT_ABBREV}spn"
$RESOURCE_GROUP_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}rg"
$STORAGE_ACCOUNT_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}$(Get-Random -Maximum 999)st"
$CONTAINER_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}"

# If you want to use Key Vault to store you storage key, uncomment the 
# following, as well as the noted code block at the end of this script:
# $USER_PRINCIPAL_NAME = "matttatsch@microsoft.com"
# $KEYVAULT_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}$(Get-Random -Maximum 999)kv"

###############################################################################

# # Log in, set subscription context, and capture tenant ID
# Connect-AzAccount
# Set-AzContext -Subscription $SUBSCRIPTION
# $tenant = (Get-AzContext).Tenant.Id

# Create resource group
$rg = New-AzResourceGroup -Name $RESOURCE_GROUP_NAME -Location $LOCATION

# Create Service Principal and grant access to resource group
$sp = New-AzADServicePrincipal -DisplayName $SERVICE_PRINCIPAL_NAME
New-AzRoleAssignment -ApplicationId $sp.AppId -RoleDefinitionName "Contributor" -Scope $rg.ResourceId

####################################################################
# All subsequent actions are performed using the service principal #
####################################################################

# # Log in using service principal
# $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $sp.AppId, $sp.PasswordCredentials.SecretText
# Connect-AzAccount -ServicePrincipal -TenantId $tenant -Credential $credential

# Create storage account and container to store Terraform state
$storageAccount = New-AzStorageAccount -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME `
                  -SkuName Standard_LRS -Location $LOCATION -AllowBlobPublicAccess $true

New-AzStorageContainer -Name $CONTAINER_NAME -Context $storageAccount.context -Permission blob

# Create Key Vault and access policies
# $kv = New-AzKeyVault -Name $KEYVAULT_NAME -ResourceGroupName $RESOURCE_GROUP_NAME -Location $LOCATION
# Set-AzKeyVaultAccessPolicy -VaultName $kv.VaultName -UserPrincipalName $sp.AppId -PermissionsToSecrets get,set,delete
# Set-AzKeyVaultAccessPolicy -VaultName $kv.VaultName -UserPrincipalName $USER_PRINCIPAL_NAME -PermissionsToSecrets get,set,delete

# Get storage key and add to Key Vault
# $ACCOUNT_KEY=(Get-AzStorageAccountKey -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME)[0].value
# $env:ARM_ACCESS_KEY=$ACCOUNT_KEY
# Set-AzKeyVaultSecret -VaultName $kv.VaultName -Name "Key-${STORAGE_ACCOUNT_NAME}" -SecretValue $env:ARM_ACCESS_KEY
