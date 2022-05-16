variable "project" {

}
variable "env" {

}

#VPC
variable "cidr_block" {
  default = "10.0.0.0/16"
}
variable "private_subnet" {
  default = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}
variable "public_subnet" {
  default = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}