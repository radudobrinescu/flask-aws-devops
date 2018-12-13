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
sudo su -c 'cd /var/www/devops_app/app' - ubuntu
sudo su -c 'virtualenv venv' - ubuntu
sudo su -c 'source venv/bin/activate' - ubuntu
sudo su -c 'pip install -r /var/www/devops_app/app/requirements.txt' - ubuntu
sudo mkdir /var/log/uwsgi
sudo chown ubuntu:ubuntu /var/log/uwsgi
sudo mv /var/www/devops_app/web/uwsgi.conf /etc/init
sudo mkdir /etc/uwsgi && sudo mkdir /etc/uwsgi/vassals
sudo ln -s /var/www/devops_app/web/devops_uwsgi.ini /etc/uwsgi/vassals
sudo chown -R ubuntu:ubuntu /var/log/uwsgi/
sudo start uwsgi
#uwsgi --ini /var/www/devops_app/web/devops_uwsgi.ini
