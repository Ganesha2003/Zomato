resource "aws_instance" "test-server" {
  ami                    = "ami-0d176f79571d18a8f"          
  instance_type          = "t3.small"
  vpc_security_group_ids = ["sg-01339d701b90ce090"]         

  
  tags = {
    Name = "test-server"
  }

  
  provisioner "local-exec" {
    command = "echo ${aws_instance.test-server.public_ip} > inventory"
  }

  
  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/zomatoapp/terraformfiles/ansiblebook.yml"
  }
}
