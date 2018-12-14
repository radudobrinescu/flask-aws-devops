#!/bin/bash

# Update and install required packages
apt-get update -y
apt-get install -y python build-essential python-dev nginx python-virtualenv

# Get the app files
git clone https://github.com/radudobrinescu/flask-aws-devops.git
mv flask-aws-devops/ /var/www/devops_app
chown -R ubuntu:ubuntu /var/www/devops_app

# Configure nginx
rm /etc/nginx/sites-enabled/default
ln -s /var/www/devops_app/web/devops_app.conf /etc/nginx/conf.d/
/etc/init.d/nginx restart

# Set up a virtual environment for the app and uWSGI
su -c "virtualenv /var/www/devops_app/app/venv" -s /bin/sh ubuntu
su -c ". /var/www/devops_app/app/venv/bin/activate && pip install -r /var/www/devops_app/app/requirements.txt" -s /bin/sh ubuntu
mkdir /var/log/uwsgi && sudo chown ubuntu:ubuntu /var/log/uwsgi

# Define uWSGI as a service
cp /var/www/devops_app/web/uwsgi.service /lib/systemd/system
systemctl enable uwsgi.service
systemctl start uwsgi.service
