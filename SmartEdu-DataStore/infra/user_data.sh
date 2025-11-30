#!/bin/bash
set -xe

# Update
yum update -y

# Install docker
amazon-linux-extras install -y docker
systemctl enable docker
systemctl start docker
usermod -a -G docker ec2-user

# Install docker-compose (binary)
curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create dirs
mkdir -p /opt/jenkins_home
mkdir -p /opt/apps
chown -R ec2-user:ec2-user /opt/jenkins_home /opt/apps
chmod -R 777 /opt/apps

# Pull and run SonarQube (docker)
docker run -d --name sonarqube \
  -p 9000:9000 \
  -e SONAR_JDBC_URL=jdbc:postgresql://db:5432/sonar \
  sonarqube:lts || true

# Run Jenkins container (will expose 8080 and 50000)
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v /opt/jenkins_home:/var/jenkins_home \
  -v /opt/apps:/opt/apps \
  jenkins/jenkins:lts || true

# Ensure Java/Maven/Python/streamlit available for shell steps (used by pipelines)
yum install -y java-17-amazon-corretto-devel git python3
# Install maven
curl -sL https://archive.apache.org/dist/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz -o /tmp/maven.tar.gz
tar xzf /tmp/maven.tar.gz -C /opt
ln -s /opt/apache-maven-3.8.8 /opt/maven
echo 'export PATH=$PATH:/opt/maven/bin' >> /etc/profile.d/maven.sh
source /etc/profile.d/maven.sh

# pip and streamlit
python3 -m pip install --upgrade pip
python3 -m pip install streamlit==1.25.0 requests pandas

# Sleep a bit to let containers come up
sleep 20

# Create a simple marker file
echo "Setup complete" > /opt/setup_complete.txt
