provider "aws" {
  region = "ap-south-1"   
}

variable "pem_file" {
  description = "Path to the PEM file injected by Jenkins"
  type        = string
}

resource "aws_instance" "web" {
  ami           = "ami-0d176f79571d18a8f" 
  instance_type = "t3.small"              
  key_name      = "bookmyshow .pem"       

  connection {
    type        = "ssh"
    user        = "ec2-user"                
    private_key = file(var.pem_file)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello from Terraform via Jenkins!"
    ]
  }
}
