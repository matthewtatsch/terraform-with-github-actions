variable "project_name" {
  type    = string
  default = "m11hsbx2"
}

variable "abbreviations" {
  type = map(string)
  default = {
    "resource_group" = "rg"
  }
}

variable "default_tags" {
  type = map(string)
  default = {
    "environment" = "non-production"
    "created-by"  = "terraform"
  }
}

variable "azure_region" {
  type = map(string)
  default = {
    "primary"   = "Central US"
    "secondary" = "East US"
  }
}