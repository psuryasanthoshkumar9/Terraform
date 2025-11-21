#!/bin/bash
# Update packages
sudo yum update -y
# Install Apache
sudo yum install -y httpd
# Enable and start Apache
sudo systemctl enable httpd
sudo systemctl start httpd
# Create a sample HTML page
echo "Hello from Terraform Provisioner!" | sudo tee /var/www/html/index.html
