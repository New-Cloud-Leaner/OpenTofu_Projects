# Configure the AWS Provider
# Two AWS providers: one per region (clean cross-region pattern).
provider "aws" {
  region = var.us_region
  alias = "us"
}

provider "aws" {
  region = var.ap_region
  alias = "ap"
}