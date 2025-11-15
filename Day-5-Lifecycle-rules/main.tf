resource "aws_instance" "QA" {
  ami ="ami-0bdd88bd06d16ba03"
  instance_type = "t2.micro"
  tags = {
    name = "QA"
  }
#lifecycle {
#    create_before_destroy = true
#}

#lifecycle {
#    ignore_chaanges = [tags]
#}

#lifecycle {
#    prevent_destroy = true
#}
}