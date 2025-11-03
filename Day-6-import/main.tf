resource "aws_instance" "ec2-1" {
  ami = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"
  tags = {
    Name = "Development"
  }
}