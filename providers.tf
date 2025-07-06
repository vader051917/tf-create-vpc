terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"

    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "prod_user"
}

terraform {
  backend "s3" {
    bucket       = "cicd-tf-gh-bucket"
    key          = "state_files/state_files.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    profile = "prod_user"
  }
}

