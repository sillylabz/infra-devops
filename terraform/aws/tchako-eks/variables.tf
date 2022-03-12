variable "project_name" {
  type    = string
  default = "demo"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "owner" {
  type    = string
  default = "demo"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "subnet_cidrs" {
  type = map(any)
  default = {
    public1  = "10.78.23.0/24",
    public2  = "10.78.24.0/24",
    public3  = "10.78.25.0/24",
    private1 = "10.78.26.0/24",
    private2 = "10.78.27.0/24",
    private3 = "10.78.28.0/24"
  }
}

variable "vpc_cidr" {
  type    = string
  default = "10.78.0.0/16"
}









