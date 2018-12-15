# How to

The below instructions show you how to

## Prerequisites
You will need to below resources configured:

#### AWS Account:
AWS account and credentials for a user with full access to EC2 and DynamoDB:
AmazonEC2FullAccess, AmazonDynamoDBFullAccess

Create a new role with the AmazonDynamoDBFullAccess policy. Make sure to set the name of the role in the ansible variables file later on. 
In order to pass this role to EC2 instances, your AWS user will need the PassRole permissions. See this link for details:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html

#### Ansible control machine
Packages installed: ansible, boto, python-virtualen (if you rather use a virtual env)
AWS credentials must be added to ~/.aws/credentials

In order to test the application, create a DynamoDB table and add some data by the following commands:

aws dynamodb create-table --cli-input-json file://create-table.json
aws dynamodb batch-write-item --request-items file://batch-write.json


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

user-data:
sudo git clone https://github.com/radudobrinescu/flask-aws-devops.git
sudo mv flask-aws-devops/ devops_app/
sudo chmod u+x devops_app/ansible/inventory/init.sh
sudo devops_app/ansible/inventory/init.sh
