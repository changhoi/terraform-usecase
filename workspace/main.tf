provider "aws" {
  profile = "terraform"
  region  = var.region
}

terraform {

  backend "s3" {
    profile = "terraform"
    bucket  = "terraform-state-share-example"
    key     = "workspace-example/terraform.tfstate"
    region  = "ap-northeast-2"

    dynamodb_table = "terraform-state-share-locks"
    encrypt        = true
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0ed11f3863410c386"
  instance_type = "t3.micro"
}
