variable "region" {
  description = "example region"
  type        = string
  default     = "ap-northeast-2"
}

variable "bucket_name" {
  description = "terraform backend s3 bucket name"
  type        = string
  default     = "terraform-state-share-example"
}

variable "lock_db_name" {
  description = "terraform backend lock db name"
  type        = string
  default     = "terraform-state-share-locks"
}
