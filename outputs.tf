#output "ec2_public_ip" {
#    value = aws_instance.my-instance[*].private_ip
  
#}

#output "ec2_private_ip" {
#    value = aws_instance.my-instance[*].public_ip
  
#}

output "ec2_public_ip" {

   value = [

    for instance in aws_instance.my-instance : instance.public_ip

   ]
     
     

   
}