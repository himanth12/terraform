variable "ec2_instance_type" {
  
   default = "t3.micro"
   type = string
}

variable "ec2_root_storage_size" {
    default = 8
    type=number
  
}

variable "ec2_ami_id" {
    default = "ami-0b6d9d3d33ba97d99"
    type = string
  
}

variable "env" {

    default = "prod"
    type = string
  
}