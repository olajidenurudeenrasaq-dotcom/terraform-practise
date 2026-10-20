variable "aws_region" {
  description = "AWS region to deploy the practice instance into"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance size for the practice web server"
  type        = string
  default     = "t3.micro"
}
