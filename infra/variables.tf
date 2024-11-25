variable "bucket_name" {
  description = "S3 bucket name for storing images"
  type        = string
  default     = "pgr301-couch-explorers"
}

variable "notification_email" {
  description = "Email for SNS notifications"
  default = "kihv001@student.kristiania.no"
}