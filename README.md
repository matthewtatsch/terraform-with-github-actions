# Overview

Generally following along with [Deploy Terraform using GitHub Actions to Azure](https://thomasthornton.cloud/2021/03/19/deploy-terraform-using-github-actions-into-azure/).

# Prerequisites

- Azure subscription
- GitHub repo

Following along with link referenced in [Overview](#overview).


1. Add .gitignore - started with [GitHub's default .gitignore for Terraform](https://github.com/github/gitignore/blob/main/Terraform.gitignore).
2. Run [PowerShell script in this repo](/scripts/powershell/SetUpTerraformRemoteState.ps1) to set up resource group, storage account, and service principal. 