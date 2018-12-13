# How to

The below instructions show you how to

## Requirements

AWS account and credentials for a user with full access to at least the following services:
EC2, VPC, DynamoDB

A control machine to run the ansible playbooks from. The below packages are required:
python, python-virtualenv, ansible, boto

## Provision the AWS infrastructure with Ansible

You will need to run the Ansible scripts on a control machine (laptop or VM)

Change any variable in ansible/group-vars/variables.yml
There is no AMI mapping per regions, so the playbook will only work in eu-central-1

To provision the infrastructure:
ansible-playbook -v aws_deploy_playbook.yml


## Test the applicaton


## Update the application deployment with Ansible


## Destroy the AWS infrastructure

ansible-playbook -v aws_destroy_playbook.yml -e state=absent
