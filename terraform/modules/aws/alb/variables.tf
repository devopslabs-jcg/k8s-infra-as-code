variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "acm_certificate_arn" { type = string }

