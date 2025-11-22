provider "aws" {
  region = "ap-south-1"   
}

resource "aws_instance" "web" {
  ami           = "ami-0d176f79571d18a8f" 
  instance_type = "t3.small"              

  # No key_name, no SSH connection
  # Use user_data for bootstrapping instead
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello from Terraform without SSH" > /home/ec2-user/startup.log
  EOF
}
