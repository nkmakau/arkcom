locals {
  environment    = terraform.workspace
  Terraform      = "true"
  sharedResource = "Yes"
  businessOwner  = "Vodasure-FS"
  ManagedBy      = "DevSecOps"
  project        = "Vodasure"
  Data           = "Data"

  # Common Tags Will Be Applied To Every Resource
  common_tags = {
    Environment    = local.environment
    Project        = local.project
    Terraform      = local.Terraform
    SharedResource = local.sharedResource
    BusinessOwner  = local.businessOwner
    ManagedBy      = local.ManagedBy
  }
}