# Capture project details from user
$SUBSCRIPTION_ID = Read-Host "Enter the Azure Subscription ID where you want to create your resources:"
$LOCATION = Read-Host "Enter the Azure region where you want to create your resources:"
$PROJECT_ABBREV = Read-Host "Enter your project short name (max 10 characters, lowercase only):"
$TFSTATE_ABBREV = "tfstate"

$SERVICE_PRINCIPAL_NAME = "${PROJECT_ABBREV}spn"
$RESOURCE_GROUP_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}rg"
$STORAGE_ACCOUNT_NAME = "${PROJECT_ABBREV}${TFSTATE_ABBREV}$(Get-Random -Minimum 100 -Maximum 999)st"
$CONTAINER_NAME = "${TFSTATE_ABBREV}"

# Connect to Azure, ensuring proper context
Connect-AzAccount -Subscription $SUBSCRIPTION_ID | Out-Null
$tenant = (Get-AzContext).Tenant.Id

# Create resource group
New-AzResourceGroup -Name $RESOURCE_GROUP_NAME -Location $LOCATION

# Create Service Principal and grant access to subscription
$sp = New-AzADServicePrincipal -DisplayName $SERVICE_PRINCIPAL_NAME
$spId = $sp.AppId
$spSecret = $sp.PasswordCredentials.SecretText
New-AzRoleAssignment -ApplicationId $sp.AppId -RoleDefinitionName "Contributor" -Scope "/subscriptions/${SUBSCRIPTION_ID}"

# Create storage account and container to store Terraform state
$storageAccount = New-AzStorageAccount -ResourceGroupName $RESOURCE_GROUP_NAME -Name $STORAGE_ACCOUNT_NAME `
                  -SkuName Standard_LRS -Location $LOCATION -AllowBlobPublicAccess $true

New-AzStorageContainer -Name $CONTAINER_NAME -Context $storageAccount.context -Permission blob

# Display key information to easily input into secrets 
$displayMessage = @"
Add the following to your GitHub project as actions secrets:

    Secret Name                Secret Value
    -----------                ------------
    TF_AZ_TENANT_ID            $tenant
    TF_AZ_SUBSCRIPTION_ID      $SUBSCRIPTION_ID
    TF_AZ_CLIENT_ID            $spId
    TF_AZ_CLIENT_SECRET        $spSecret
    
Add the following to the terraform.backend block within your main.tf file:

    resource_group_name  = "$RESOURCE_GROUP_NAME"
    storage_account_name = "$STORAGE_ACCONT_NAME"
    container_name       = "$CONTAINER_NAME"
    key                  = "$CONTAINER_NAME".tfstate"
"@

Write-Host $displayMessage
