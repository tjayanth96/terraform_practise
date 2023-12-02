provider "aws" {
    region = "us-east-1"    
}

resource "aws_instance" "machine" {
    ami = "ami-0230bd60aa48260c6"
    instance_type = "t2.micro"
   vpc_security_group_ids = ["${aws_security_group.shield.id}"]
    tags = { Name = "terraform_testing"}
    user_data_replace_on_change = true
    user_data = <<-EOF
                   #!/bin/bash
                   echo "Hello, World" && sudo install httpd && sudo systemctl enable httpd > index.xhtml
                   nohup busybox httpd -f -p 8080 &
                   EOF 
}

resource "aws_security_group" "shield" {
    name = "Terraform_SG"
    ingress {
        from_port = "${var.port}"
        to_port = "${var.port}"
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0"]         
    }
}

variable "object_variable_with_one_key_value_as_error" {
    description = "an example of object variable"
    type = object({
                    name = string
                    age = number
                    tags = list(string)
                    enabled = bool
                 })
   default = {
              name = "value1"
              age = "22"
              tags = ["a", "b", "c"]
              enabled = true
             }
}

variable "port" {
    description = "This is for from and to port"
    type = number
    default = 8080
}

output "ip_address" {
    description = "This is ip address of ec2 machine"
    value = "${aws_instance.machine.public_ip}"
}
