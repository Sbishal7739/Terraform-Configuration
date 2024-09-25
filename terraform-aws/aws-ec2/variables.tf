variable "region" {
  description = "amazon region"
  type = string
  default = "us-east-1"
}

variable "ami" {
  type = string
  description = "amazom machine image id"
  default = "ami-0ebfd941bbafe70c6"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
