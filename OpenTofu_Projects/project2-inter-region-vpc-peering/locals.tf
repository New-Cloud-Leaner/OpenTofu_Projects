locals {
  project = var.project_name
  # Common tags to be assigned to all resources
  common_tags = {
    Project     = local.project
    ManagedBy   = "OpenTofu"
    Environment = var.environment
  }
}