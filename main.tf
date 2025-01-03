resource "aws_instance" "phpapp" {
  ami                    = "ami-043d6febda24ff99b"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name               = "testweb"

  user_data              = templatefile("user-data.sh", {
    db_name = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_url = aws_db_instance.phpdb.address
  })
    
  user_data_replace_on_change = true
}


resource "aws_security_group" "instance" {
  name = "phpapp-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
}

output "testip" {
  value       = aws_instance.phpapp.public_ip
  description = "aws instance IP"
}
