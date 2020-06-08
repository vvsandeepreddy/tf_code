variable "bucket_name" {
  description = "unique name of S3 bucket, must be unique"
  type        = string
}

variable "tags" {
  description  = "bucket tags to be set at root config"
  type         = map(string)
  default      = {}
}
