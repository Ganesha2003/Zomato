provider "aws" {
  region = "ap-south-1"   
}

resource "aws_instance" "test-server" {
  ami                    = "ami-0d176f79571d18a8f"          
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-01339d701b90ce090"]        

  # Automatically configure server at launch
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y docker
    systemctl start docker
    systemctl enable docker
    docker run -d -p 80:80 rmganesha/zomatoapp:1.0
  EOF

  tags = {
    Name = "test-server"
  }

  # Save public IP to inventory file
  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }
}
