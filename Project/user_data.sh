#!/bin/bash
set -e
# update
yum update -y

# install essentials
yum install -y git python3 python3-pip java-17-amazon-corretto wget unzip

# Install Jenkins (official)
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins

# Start Jenkins
systemctl enable --now jenkins

# add jenkins user to docker (if docker installed later)
yum install -y docker
systemctl enable --now docker
usermod -aG docker jenkins

# create project folder for git repo pulls
mkdir -p /opt/student-app
chown -R ec2-user:ec2-user /opt/student-app

# install pip packages that sometimes needed on system level
python3 -m pip install --upgrade pip

# allow SSH passwordless for ec2-user if you want to push stuff (optional)
# finishing
echo "user-data finished"
