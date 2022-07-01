# TODO BEFORE PUBLISHING

- Remove specific values in `terraform.backend` block in the [`main.tf`](./terraform/main.tf) file
- Remove this section

# Overview

Generally following along with [Deploy Terraform using GitHub Actions to Azure](https://thomasthornton.cloud/2021/03/19/deploy-terraform-using-github-actions-into-azure/).

# Prerequisites

- Azure subscription
- GitHub repo

Following along with link referenced in [Overview](#overview).


1. Run the [PowerShell script in this repo](/scripts/powershell/SetUpTerraformRemoteBackend.ps1) to set up the resource group and storage account where Terraform's remote state will be managed, as well as create the service principal that Terraform will use to apply all infrastructure changes.
    
    _**IMPORTANT:** Be sure to capture the client secret from the output of the PowerShell script, as you will need it in the next step._
1. Populate the following details in `terraform.backend` block in the [`main.tf`](./terraform/main.tf) file in the repository (the PowerShell script will provide you with the details):
    ```
    backend "azurerm" {
        resource_group_name  = "<RESOURGE_GROUP_NAME>"
        storage_account_name = "<STORAGE_ACCONT_NAME>"
        container_name       = "<CONTAINER_NAME"
        key                  = "<CONTAINER_NAME>.tfstate"
    }
    ```
1.
1.