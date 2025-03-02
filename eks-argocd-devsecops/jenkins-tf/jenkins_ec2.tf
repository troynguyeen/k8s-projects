resource "aws_instance" "demo-ec2" {
  ami           = "ami-0f55eed8bfa7100f6"
  instance_type = "t3.micro"
  user_data     = templatefile("./install_tools.sh", {})

  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.demo-sg.id]

  tags = {
    Name = "demo-ec2-tf"
  }
}

resource "aws_security_group" "demo-sg" {
  name = "demo-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "demo-sg-tf"
  }
}