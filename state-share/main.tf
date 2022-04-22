provider "aws" {
  profile = "terraform"
  region  = var.region
}

terraform {

  backend "s3" {
    profile = "terraform"
    bucket  = "terraform-state-share-example"
    key     = "global/s3/terraform.tfstate"
    region  = "ap-northeast-2"

    dynamodb_table = "terraform-state-share-locks"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name # Bucket 이름

  lifecycle {
    prevent_destroy = true # 리소스가 삭제되는 것을 방지함(Destroy가 실행 되면 에러 발생 후 종료)
  }

  versioning {
    enabled = true # S3의 버전 관리 기능
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256" # 시크릿 파일 암호화
      }
    }
  }
}


resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.lock_db_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
