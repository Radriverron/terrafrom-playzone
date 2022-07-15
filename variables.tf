# variables

variable "res-name" {
  type    = string
  default = "tf-test"

}

variable "aws-region" {
  type    = string
  default = "eu-west-2"
}

variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"

}

variable "psub-cidr" {
  type        = string
  description = "cidr for public subnet"
  default     = "10.0.1.0/24"

}

variable "company" {
  type    = string
  default = "Terratest"

}

variable "team" {
  type    = string
  default = "terraform-test"

}

variable "my-ip" {
  type    = string
  default = "0.0.0.0/32"

}
