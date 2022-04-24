provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-2"
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "ch-mysql-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = "ch-mysql-state"
  force_destroy = true
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

terraform {
  backend "s3" {
    profile = "terraform"
    bucket  = "ch-mysql-state"
    key     = "stage/data-stores/mysql/terraform.tfstate"
    region  = "ap-northeast-2"

    dynamodb_table = "ch-mysql-state-lock"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-demo"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t3.micro"
  db_name             = "example_db"
  username            = "admin"
  password            = "administrator" # 기본은 secret key manager data 사용
  skip_final_snapshot = true
}
