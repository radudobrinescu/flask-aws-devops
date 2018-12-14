#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y python build-essential python-dev nginx python-virtualenv
sudo git clone https://github.com/radudobrinescu/flask-aws-devops.git
sudo mv flask-aws-devops/ /var/www/devops_app
sudo chown -R ubuntu:ubuntu /var/www/devops_app
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /var/www/devops_app/web/devops_app.conf /etc/nginx/conf.d/
sudo /etc/init.d/nginx restart
#chdir /var/www/devops_app/app
sudo su -c "virtualenv /var/www/devops_app/app/venv" -s /bin/sh ubuntu
sudo su -c ". /var/www/devops_app/app/venv/bin/activate && pip install -r /var/www/devops_app/app/requirements.txt" -s /bin/sh ubuntu
#sudo -H pip install -r /var/www/devops_app/app/requirements.txt
sudo mkdir /var/log/uwsgi && sudo chown ubuntu:ubuntu /var/log/uwsgi
#sudo mkdir /etc/uwsgi && sudo mkdir /etc/uwsgi/vassals
#sudo ln -s /var/www/devops_app/web/devops_uwsgi.ini /etc/uwsgi/vassals
#sudo chown -R ubuntu:ubuntu /var/log/uwsgi/
sudo cp /var/www/devops_app/web/uwsgi.service /lib/systemd/system
sudo systemctl enable uwsgi.service
sudo systemctl start uwsgi.service
#===========================================================================

#apt-get update -y
#apt-get install -y python build-essential python-dev nginx python-virtualenv
#git clone https://github.com/radudobrinescu/flask-aws-devops.git
#mv flask-aws-devops/ devops_app/
#cp -r ~/devops_app /var/www/
#chown -R ubuntu:ubuntu /var/www/devops_app
##cd /var/www/devops_app/app
#su -c 'virtualenv /var/www/devops_app/app/venv' - ubuntu
#source /var/www/devops_app/app/venv/bin/activate
#pip install -r /var/www/devops_app/app/requirements.txt
#mkdir /var/log/uwsgi
#chown ubuntu:ubuntu /var/log/uwsgi
#mkdir /etc/init
#mv /var/www/devops_app/web/uwsgi.conf /etc/init/
#mkdir /etc/uwsgi && sudo mkdir /etc/uwsgi/vassals
#ln -s /var/www/devops_app/web/devops_uwsgi.ini /etc/uwsgi/vassals
#chown -R ubuntu:ubuntu /var/log/uwsgi/
#cp /var/www/devops_app/web/uwsgi.service /lib/systemd/system
#systemctl enable uwsgi.service
#systemctl start uwsgi.service
