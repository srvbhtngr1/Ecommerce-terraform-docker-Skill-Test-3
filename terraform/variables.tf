variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "dockerhub_username" {
  description = "Docker Hub username that owns the five public images"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Optional existing EC2 key pair name for SSH access (leave empty for none)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH (22). Use your IP, e.g. 203.0.113.10/32"
  type        = string
  default     = "0.0.0.0/0"
}

variable "project_name" {
  description = "Prefix for resource names"
  type        = string
  default     = "ecommerce"
}
