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