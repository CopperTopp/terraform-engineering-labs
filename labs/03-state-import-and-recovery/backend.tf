terraform {
  backend "s3" {
    bucket = "terraform-engineering-lab03-state-import-and-recovery-mvh"
    key = "lab03/terraform.tfstate"
    region = "us-east-2"
    profile = "iac"
    encrypt = true
    use_lockfile = true
  }
}