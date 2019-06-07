# terraform12-aws-application_stack

`terraform12-aws-application_stack` is a Terraform module to build a complete application stack on AWS:  
- Security Groups  
- Elastic Load Balancer (classic)  
- S3 Bucket for ELB Access logs  
- ASG Launch Configuration  
- Application AutoScaling Group  

This is an enterprise-ready, scalable and highly-available architecture to build and deploy Jenkins.

## Features

The module will create the following AWS resources:

   * Security groups  
   * Elastic Load Balancer (classic)
   * S3 Bucket for ELB Acess Logs  
   * AutoScaling Group Launch Configuration  
   * Application AutoScaling Group  

## Important  
_**Do not modify the variables.tf file.  Update the override_variables.tf file to use your own custom variables**_


##  Usage
For complete examples, see [examples](examples).  
```console
foo@bar:$>terraform init      # Initialize the project  
foo@bar:$>terraform plan      # Plan accordingly
foo@bar:$>terraform apply     # Deploy the entire stack
foo@bar:$>terraform destroy   # Destroy the entire stack
```


## Examples
TBD


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account_id | AWS Account ID | string | XZZZZZZZZ | yes |
| app_name | The application name/type | string | - | yes |
| Environment | The stack environment (i.e Dev, Test, Prod) | string | `non-prod` | no |
| fisma_id | Client FISMA ID | string | `-` | no |
| InstanceType | Instance size to use for the ASG | string | `t2.xlarge` | no |
| KeypairName | EKeyPair used for external access (i.e. ssh) | string | - | no |
| kms_key | KMS used for de/encryption | string | - | yes |
| prefix | Prefix applied to all created resources for identification| string | `` | no |
| ProjectName | Name of the project this stack is being used for | string | `tcp` | yes |
| provision_bucket_name | S3 Bucket with provision files/scripts | string | `-` | yes |
| owner_email | Primary contact for question regarding any created resources.  Used as a tag value | string | `-` | no |
| region | AWS Region resources will be deployed to | string | `us-east-1` | yes |
| Team | Team name that is working on this project | string | - | yes |
| subnets | list of subnets to use | list | - | yes |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `jenkins` | no |
| system | Client specific system name | string | - | yes |
| vpc_id | ID of the VPC in which to provision the AWS resources | string | - | yes |
| WholeWorldCIDR | CIDR block to use | string | - | yes |

## Outputs
| Name | Description |
|------|-------------|
| app_asg_arn | Application AutoScaling Group ARN|
| app_asg_id | Application AutoScaling Group ID|
| app_asg_name | Application AutoScaling Group Name|
| app_elb_arn | Application Elastic Load Balancer ARN|
| app_elb_id | Application Elastic Load Balancer ID|
| app_elb_name | Application Elastic Load Balancer Name|
| app_sg_id | Application Security Group ID|
| app_sg_name| Application Security Group Name|
| asg_config_id | AutoScaling Group Launch Configuration ID|
| asg_config_name | AutoScaling Group Launch Configuration Name|
| elb_bucket_name | S3 Bucket Name for ELB Access Log Storage|
| iam_role_name | IAM Role Name|
| iam_role_arn | IAM Role Arn|
| iam_policy_arn| IAM Policy ARN|
| iam_policy_name | IAM Policy Name|
| lb_sg_name| Elastic Load Balancer Security Group Name|
| lb_sg_id| Elastic Load Balancer Security  Group ID|
| profile_name| Instance Profile Name|
| profile_id| Instance Profile ID|
| profile_arn| Instance Profile ARN|  

## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.

## Trademarks

All other trademarks referenced herein are the property of their respective owners.
