# How to deploy Sample app on AWS ECS 

### To start, make sure you have the following dependencies installed and a working development environment:

* Terraform
* AWS CLI 
* AWS credentials to configure AWS CLI (e.g ACCESS & SECRET Keys)
```
 aws configure
```


Note:

- I've used default VPC and subnets as it was unused in my test account, you can choose to create a new VPC and subnet if required


### Create Infrastructe using Terraform

- Clone the repo
```
git clone 
```
* Navigate to project directtory
* Run `terraform init`
* Run `terraform plan`
* Review the plan, make sure it's not making any unwanted chnages due to configuration drift
* Run `terraform apply --auto-approve`

Once done it's return a `subnet`, `security_group_id` and `dns (load balancer url)` which will be used to access the application

```
Outputs:

dns_name = "alb-1645103834.ap-southeast-2.elb.amazonaws.com"
securitygroupid = "sg-0a5da73257b3c7283"
subnetid = "subnet-0ae8536ed992a0436"
ecs_cluster_name = "ecs_cluster"
```

Populate the database (one time activity, so using a shell script to run)

* Run `sh populate_db.sh`
