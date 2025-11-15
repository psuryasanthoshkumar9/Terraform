resource "aws_instance" "QA" {
  ami ="ami-0bdd88bd06d16ba03"
  instance_type = "t2.micro"
  tags = {
    name = "QA"
  }
}

resource "aws_s3_bucket" "name" {
  bucket = "pingala2"
}

# Target resource user can apply specific resource level only below command is the reference.
# terraform apply -target=aws_s3_bucket.name
