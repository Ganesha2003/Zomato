resource "aws_instance" "test-server" {
    ami                    = "ami-0d176f79571d18a8f"
    instance_type          = "t3.small"
    key_name               = "bookmyshow"
    vpc_security_group_ids = ["sg-01339d701b90ce090"]

    connection {
        type        = "ssh"
        user        = "ec2-user"
        // FIX 1: Removed the space: "./bookmyshow .pem" -> "./bookmyshow.pem"
        private_key = file("./bookmyshow.pem")
        host        = self.public_ip
    }

    provisioner "remote-exec" {
        inline = ["echo 'wait to start the instance' "]
    }

    tags = {
        Name = "test-server"
    }

    provisioner "local-exec" {
        command = "echo ${aws_instance.test-server.public_ip} > inventory"
    }

    provisioner "local-exec" {
        // FIX 2: Added -i inventory and --private-key bookmyshow.pem for Ansible authentication
        command = "ansible-playbook -i inventory --private-key bookmyshow.pem /var/lib/jenkins/workspace/zomatoapp/terraformfiles/ansiblebook.yml"
    }
}
