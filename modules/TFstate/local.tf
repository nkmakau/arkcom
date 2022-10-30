locals {
  environment     = terraform.workspace
  Terraform       = "true"
  sharedResource  = "Yes"
  BusinessOwner   = "Enterprise Integrations"
  Owner           = "jnwarui"
  ManagedBy       = "DevSecOps"
  Project         = "Saf-flogo"
  OrgBackupPolicy = "None"
  CRQ             = "CRQ000007670352"

  # Common Tags Will Be Applied To Every Resource
  common_tags = {
    Environment     = local.environment
    Project         = local.Project
    Terraform       = local.Terraform
    SharedResource  = local.sharedResource
    BusinessOwner   = local.BusinessOwner
    ManagedBy       = local.ManagedBy
    OrgBackupPolicy = local.OrgBackupPolicy
    CRQ             = local.CRQ
    Owner           = local.Owner
  }
}