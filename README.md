Python, Flask application that implements two simple REST methods (GET, PUT) on top of AWS infrastructure.

![](ArchitectureDiagram.png "ArchitectureDiagram")

## Prerequisites
You will need to below resources configured:

#### AWS Account:
The resources can be created with a non-administrative user. However, there are some requirements for this user:
1. A role with the following permissions:
  AmazonEC2FullAccess, AmazonDynamoDBFullAccess

2. In order to pass this role to EC2 instances, your AWS user will need the PassRole permissions. See this link for details:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2.html

3. You can use the same role as in step 1, or another one with just AmazonDynamoDBFullAccess policy. Make sure to set the Instance Profile ARNs of the role in the ansible variables file. This role will be passed to EC2 instances in order to authenticate against DynamoDB.

#### Ansible control machine
Packages installed: ansible, boto, python-virtualen (if you rather use a virtual env)
AWS credentials must be added to ~/.aws/credentials

In order to test the application, create a DynamoDB table and add some data by the following commands:
```
aws dynamodb create-table --cli-input-json file://create-table.json
aws dynamodb batch-write-item --request-items file://batch-write.json
```
## Provision the AWS infrastructure with Ansible
You will need to run the Ansible scripts on a control machine (laptop or VM)

Change any variable in ansible/group-vars/variables.yml
There is no AMI mapping per regions, so the playbook will only work in eu-central-1

To provision the infrastructure:
```
ansible-playbook -v aws_deploy_playbook.yml
```
The last output will give you the DNS Name of the Load Balancer on which the application can be tested.

## Testing the application

Performing a GET to retrieve the date of birth of a user:
```
curl -X GET http://devops-challenge-lb-<some_name>.amazonaws.com/hello/John
{
  "message": "Hello, John! Your birthday is in 59 days."
}
```
Changing the date of birth by submitting it in a json payload:
```
curl -X PUT http://devops-challenge-lb-<some_name>.amazonaws.com/hello/John  -H 'content-type: application/json' -d '{"dateOfBirth": "15-12-1976"}'
```
Checking that the data has indeed changed. This can also be checked in the DynamoDB in the AWS console.
```
curl -X GET http://devops-challenge-lb-<some_name>.amazonaws.com/hello/John
{
  "message": "Hello, John! Happy birthday!"
}
```

## Destroy the AWS infrastructure
```
ansible-playbook -v aws_destroy_playbook.yml -e state=absent
```
