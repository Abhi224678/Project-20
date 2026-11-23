#!/bin/bash
apt-get update -y
apt-get install -y nginx curl
systemctl enable nginx
systemctl start nginx

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

INSTANCE_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

cat > /var/www/html/index.html <<HTML
<h1>Project 20 - Load Balanced Application</h1>
<p>Served by EC2 Instance: $INSTANCE_ID</p>
HTML
