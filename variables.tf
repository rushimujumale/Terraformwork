variable "aws_region" {
  description = "AWS region to deploy resources."
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name for the hosted zone."
  type        = string
}

variable "comment" {
  description = "Comment for the hosted zone (optional)."
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "ID of the VPC to associate with the hosted zone (for private zones)."
  type        = string
  default     = ""
}

variable "is_private" {
  description = "Set to true for a private hosted zone, false for public."
  type        = bool
  default     = false
}
