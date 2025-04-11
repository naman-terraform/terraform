provider "aws" {
  region  = var.aws_region
  profile = "iscara-prod"

  default_tags {
    tags = merge(
      {
        Environment = var.environment
        Project     = var.project_name
        Terraform   = "true"
        ManagedBy   = "Terraform"
      },
      var.tags
    )
  }
}
