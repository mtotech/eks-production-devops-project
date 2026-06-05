terraform {

  backend "s3" {

    bucket = "neeraj-devops-terraform-state"

    key = "eks-production/terraform.tfstate"

    region = "ap-south-1"

    dynamodb_table = "terraform-lock"

    encrypt = true
  }
}
