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
                   echo "Hello, World" > index.xhtml
                   nohup busybox httpd -f -p 8080 &
                   EOF 
}

resource "aws_security_group" "shield" {
    name = "Terraform_SG"
    ingress {
        from_port = "8080"
        to_port = "8080"
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0"]         
    }
}

