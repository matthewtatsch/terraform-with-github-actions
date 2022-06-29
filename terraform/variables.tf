variable "project_name" {
  type    = string
  default = "m11hsbx"
}

variable "abbreviations" {
  type = map(string)
  default = {
    "resource_group" = "rg"
  }
}

variable "tags" {
  type = map(string)
  default = {
    "environment" = "non-production"
  }
}

variable "azure_region" {
  type = map(string)
  default = {
    "primary"   = "Central US"
    "secondary" = "East US"
  }
}

variable "tfbackend" {
  description = "Terraform remote state storage account details"
  type        = map(string)
  default = {
    "resource_group_name"  = "m11hghtftestrg"
    "storage_account_name" = "m11hghtftest"
    "container_name"       = "m11hghtftesttfstate"
    "key"                  = "m11hghtftesttfstate.tfstate"
  }
}