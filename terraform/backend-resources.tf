# create bucket for store state file

resource "aws_s3_bucket" "terraform_state" {

  bucket = "neeraj-devops-terraform-state"

  tags = {

    Name = "Terraform State"

    Environment = "Production"
  }
}

# enable versioning 

resource "aws_s3_bucket_versioning" "versioning" {

  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {

    status = "Enabled"
  }
}
# enable encryption

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {

  bucket = aws_s3_bucket.terraform_state.id

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm = "AES256"
    }
  }
}

# create dynamoDB table

resource "aws_dynamodb_table" "terraform_lock" {

  name = "terraform-lock"

  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {

    name = "LockID"

    type = "S"
  }
}
