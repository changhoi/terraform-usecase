data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    profile = "terraform"
    bucket  = "ch-terraform-demo-state"
    key     = "stage/data-stores/mysql/terraform.tfstate"
    region  = "ap-northeast-2"
  }
}
