#!/bin/bash
set -e

# ----------------------
# System Update & Essentials
# ----------------------
yum update -y
yum install -y git python3 python3-pip java-17-amazon-corretto wget unzip

# ----------------------
# Jenkins Installation
# ----------------------
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
yum install -y jenkins
systemctl enable --now jenkins

# ----------------------
# Docker Installation
# ----------------------
yum install -y docker
systemctl enable --now docker
usermod -aG docker jenkins

# ----------------------
# SonarQube Installation
# ----------------------
# Java is already installed above
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.3.0.61784.zip -P /opt
unzip /opt/sonarqube-10.3.0.61784.zip -d /opt
mv /opt/sonarqube-10.3.0.61784 /opt/sonarqube
groupadd sonar
useradd -r -g sonar -d /opt/sonarqube sonar
chown -R sonar:sonar /opt/sonarqube
# Start SonarQube
cat >/etc/systemd/system/sonarqube.service <<EOL
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable --now sonarqube

# ----------------------
# Python Virtual Environment
# ----------------------
python3 -m pip install --upgrade pip
pip3 install virtualenv
mkdir -p /opt/student-app/frontend /opt/student-app/backend
cd /opt/student-app
python3 -m venv venv
source venv/bin/activate

# ----------------------
# Install Backend & Frontend Dependencies
# ----------------------
cat >/opt/student-app/frontend/requirements.txt <<EOL
streamlit==1.50.0
pandas==2.3.3
requests==2.32.5
altair==5.5.0
flask==2.3.5
jinja2==3.1.6
gunicorn==20.1.0
numpy==2.0.2
EOL

cat >/opt/student-app/backend/requirements.txt <<EOL
flask==2.3.5
requests==2.32.5
gunicorn==20.1.0
pandas==2.3.3
numpy==2.0.2
EOL

# Install dependencies
pip install -r frontend/requirements.txt
pip install -r backend/requirements.txt

# ----------------------
# Start Frontend & Backend as Services
# ----------------------
# Frontend (Streamlit)
cat >/etc/systemd/system/frontend.service <<EOL
[Unit]
Description=Frontend Streamlit Service
After=network.target

[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/opt/student-app/frontend
Environment="PATH=/opt/student-app/venv/bin"
ExecStart=/opt/student-app/venv/bin/streamlit run frontend_app.py --server.port=8501 --server.address=0.0.0.0
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Backend (Flask/Gunicorn)
cat >/etc/systemd/system/backend.service <<EOL
[Unit]
Description=Backend Flask Service
After=network.target

[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/opt/student-app/backend
Environment="PATH=/opt/student-app/venv/bin"
ExecStart=/opt/student-app/venv/bin/gunicorn -w 4 -b 0.0.0.0:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOL

systemctl daemon-reload
systemctl enable --now frontend
systemctl enable --now backend

echo "All automation finished: Jenkins, SonarQube, Frontend, Backend, Docker"
