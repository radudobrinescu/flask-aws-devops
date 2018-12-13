#!/bin/bash

#sudo git clone https://github.com/radudobrinescu/flask-aws-devops.git
#sudo mv flask-aws-devops/ devops_app/
sudo apt-get update -y
sudo apt-get install -y python build-essential python-dev nginx python-virtualenv
sudo cp -r ~/devops_app /var/www/
sudo chown -R ubuntu:ubuntu /var/www/devops_app
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /var/www/devops_app/web/devops_app.conf /etc/nginx/conf.d/
sudo /etc/init.d/nginx restart
cd /var/www/devops_app/app
virtualenv venv
source venv/bin/activate
pip install -r /var/www/devops_app/app/requirements.txt
sudo mkdir /var/log/uwsgi
sudo chown ubuntu:ubuntu /var/log/uwsgi
uwsgi --ini /var/www/devops_app/web/devops_uwsgi.ini
