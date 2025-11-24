data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "ec2-instance" {
  ami           = data.aws_ami.amzn-linux-2023-ami.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_1.id

    user_data = <<-EOF
        #!/bin/bash
        yum update -y
        amazon-linux-extras install nginx1 -y
        systemctl enable nginx
        systemctl start nginx

        echo "<h1>Hello from alyssum Terraform on Amazon Linux 2!</h1>" > /usr/share/nginx/html/index.html
    EOF

  tags = {
    Name = "alyssum-ec2-instance"
  }
}