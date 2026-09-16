\# 🚀 Production-Style 3-Tier Web Application Deployment on AWS



!\[AWS](https://img.shields.io/badge/AWS-Cloud-orange?logo=amazon-aws)

!\[Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-7B42BC?logo=terraform)

!\[Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins)

!\[Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?logo=docker)

!\[Python](https://img.shields.io/badge/Python-Flask-3776AB?logo=python)

!\[Amazon ECR](https://img.shields.io/badge/Amazon-ECR-FF9900?logo=amazon-aws)

!\[Amazon RDS](https://img.shields.io/badge/Amazon-RDS-527FFF?logo=amazon-aws)



\## 📌 Project Overview



This project demonstrates the deployment of a production-style 3-tier web application on AWS using Terraform, Jenkins, Docker, Amazon ECR, EC2, Application Load Balancer, Auto Scaling, RDS PostgreSQL, IAM, and CloudWatch.



The architecture separates the application into three logical layers:



\- \*\*Public Layer\*\* – Application Load Balancer

\- \*\*Application Layer\*\* – Private EC2 instances running Dockerized Flask application

\- \*\*Database Layer\*\* – Private Amazon RDS PostgreSQL



Terraform is used to provision the AWS infrastructure, while Jenkins automates the CI/CD workflow for building and deploying the application.



\---



\# 🏗️ Architecture



```text

&#x20;                        INTERNET

&#x20;                           |

&#x20;                           v

&#x20;               +------------------------+

&#x20;               | Application Load       |

&#x20;               | Balancer               |

&#x20;               | Public Subnets         |

&#x20;               +------------------------+

&#x20;                    /              \\

&#x20;                   /                \\

&#x20;                  v                  v

&#x20;         +---------------+    +---------------+

&#x20;         | Private App  |    | Private App  |

&#x20;         | Subnet AZ-a  |    | Subnet AZ-b  |

&#x20;         |               |    |               |

&#x20;         | EC2 + Docker  |    | EC2 + Docker  |

&#x20;         | Flask App     |    | Flask App     |

&#x20;         +---------------+    +---------------+

&#x20;                   \\                /

&#x20;                    \\              /

&#x20;                     v            v

&#x20;                 +----------------------+

&#x20;                 | Private DB Subnets   |

&#x20;                 |                      |

&#x20;                 | RDS PostgreSQL       |

&#x20;                 +----------------------+



&#x20;                        |

&#x20;                        |

&#x20;                 NAT Gateway

&#x20;                        |

&#x20;                        v

&#x20;                     Internet
AWS Architecture

VPC

VPC CIDR: 10.0.0.0/16

Region: ap-south-1

Public Subnets

10.0.1.0/24 → ap-south-1a

10.0.2.0/24 → ap-south-1b



Used by:



Application Load Balancer

NAT Gateway

Private Application Subnets

10.0.11.0/24 → ap-south-1a

10.0.12.0/24 → ap-south-1b



Used by:



EC2 application servers

Docker containers

Private Database Subnets

10.0.21.0/24 → ap-south-1a

10.0.22.0/24 → ap-south-1b



Used by:



Amazon RDS PostgreSQL

🔄 Application Request Flow

User

&#x20;|

&#x20;| HTTP :80

&#x20;v

Application Load Balancer

&#x20;|

&#x20;| HTTP :80

&#x20;v

Private EC2 Instance

&#x20;|

&#x20;| Docker Container

&#x20;v

Flask Application

&#x20;|

&#x20;v

PostgreSQL RDS



The EC2 application servers are not directly exposed to the internet.



Only the Application Load Balancer accepts public HTTP traffic.



🔐 Security Architecture



Three separate Security Groups are used.



1\. ALB Security Group

Internet

&#x20;  |

&#x20;  | TCP 80

&#x20;  v

ALB



Inbound:



HTTP : 80

Source: 0.0.0.0/0

2\. Application Security Group

ALB

&#x20;|

&#x20;| TCP 80

&#x20;v

EC2



Inbound:



HTTP : 80

Source: ALB Security Group



The application servers do not allow direct HTTP access from the internet.



3\. Database Security Group

EC2 Application Servers

&#x20;         |

&#x20;         | TCP 5432

&#x20;         v

&#x20;    RDS PostgreSQL



Inbound:



PostgreSQL : 5432

Source: Application Security Group



RDS configuration:



Publicly Accessible: false

Security Principles

Application servers are placed in private subnets.

RDS is not publicly accessible.

Database access is restricted to the application security group.

IAM roles are used for AWS service access.

ECR image pulling uses an EC2 IAM role.

Terraform variables containing secrets are excluded from Git.

Public access to the Terraform state bucket is blocked.

🐳 Docker Application



The application is a lightweight Python Flask web application.



Application Endpoints

GET /

GET /health

/



Returns the application server hostname.



Example:



Production 3-Tier Application - Server: <hostname>



The hostname helps demonstrate traffic reaching application instances behind the load balancer.



/health



Returns:



Healthy

🐳 Docker



The application is packaged into a Docker image using:



Python 3.12

Flask

Docker



The Docker image is pushed to Amazon ECR.



ECR Repository:



production-3tier-app



Deployment flow:



Flask Application

&#x20;      |

&#x20;      v

Docker Build

&#x20;      |

&#x20;      v

Docker Image

&#x20;      |

&#x20;      v

Amazon ECR

&#x20;      |

&#x20;      v

Private EC2

&#x20;      |

&#x20;      v

Docker Container

📦 Amazon ECR



Amazon Elastic Container Registry is used to store the Docker image.



EC2 application servers use an IAM role with ECR read-only permissions to pull the application image.



🔁 Jenkins CI/CD Pipeline



The project uses Jenkins to automate application and infrastructure deployment.



Developer

&#x20;   |

&#x20;   v

GitHub

&#x20;   |

&#x20;   | Push

&#x20;   v

Jenkins

&#x20;   |

&#x20;   v

Terraform Init

&#x20;   |

&#x20;   v

Terraform Format Check

&#x20;   |

&#x20;   v

Terraform Validate

&#x20;   |

&#x20;   v

Create ECR Repository

&#x20;   |

&#x20;   v

Docker Build

&#x20;   |

&#x20;   v

ECR Login

&#x20;   |

&#x20;   v

Docker Tag

&#x20;   |

&#x20;   v

Push Image to ECR

&#x20;   |

&#x20;   v

Terraform Plan

&#x20;   |

&#x20;   v

Manual Approval

&#x20;   |

&#x20;   v

Terraform Apply

&#x20;   |

&#x20;   v

AWS Infrastructure

⚙️ Jenkins Pipeline Stages

Stage	Description

Checkout SCM	Retrieves source code from GitHub

Checkout	Checks out project files

Get AWS Account ID	Retrieves AWS account information

Terraform Init	Initializes Terraform

Terraform Format Check	Checks Terraform formatting

Terraform Validate	Validates Terraform configuration

Create ECR Repository	Creates/ensures ECR repository

Docker Build	Builds application Docker image

ECR Login	Authenticates Docker with Amazon ECR

Docker Tag	Tags image for ECR

Push Image to ECR	Pushes image to ECR

Terraform Plan	Shows infrastructure changes

Manual Approval	Requires approval before deployment

Terraform Apply	Provisions AWS infrastructure

Post Actions	Reports pipeline status

🏗️ Terraform Infrastructure



Terraform is used as Infrastructure as Code to provision AWS resources.



VPC

├── Public Subnets

├── Private Application Subnets

├── Private Database Subnets

├── Internet Gateway

├── NAT Gateway

├── Route Tables

├── Security Groups

├── Application Load Balancer

├── Target Group

├── EC2 Launch Template

├── Auto Scaling Group

├── RDS PostgreSQL

├── ECR Repository

├── IAM Roles

├── CloudWatch Log Group

├── CloudWatch Alarm

└── S3 Terraform State Bucket

📈 Auto Scaling



The application tier is deployed using an Auto Scaling Group.



Configuration:



Minimum: 2 instances

Desired: 2 instances

Maximum: 4 instances



Application instances are distributed across:



ap-south-1a

ap-south-1b



The Application Load Balancer distributes incoming traffic across healthy application instances.



📊 Monitoring



Amazon CloudWatch is included for monitoring.



The project provisions:



CloudWatch Log Group

/production-3tier/app



and an EC2 CPU alarm.



CPU alarm configuration:



Metric: CPUUtilization

Threshold: 70%

Evaluation Periods: 2

Period: 300 seconds



The Auto Scaling Group also uses ELB health checks.



🔑 IAM



IAM roles are used to provide AWS permissions without storing long-term AWS credentials on application instances.



The application EC2 role provides:



AmazonEC2ContainerRegistryReadOnly



This allows EC2 instances to authenticate with ECR and pull the application image.



🔐 Secret Management



Database credentials are not committed to GitHub.



The following file is kept local:



terraform.tfvars



It is excluded through .gitignore.



Jenkins stores the database password as a credential:



rds-db-password



The password is passed to Terraform during pipeline execution instead of storing it in source code.



📂 Project Structure

3tier-aws/

│

├── app/

│   ├── app.py

│   ├── requirements.txt

│   └── Dockerfile

│

├── terraform/

│   ├── provider.tf

│   ├── variables.tf

│   ├── outputs.tf

│   ├── vpc.tf

│   ├── subnets.tf

│   ├── routes.tf

│   ├── security-groups.tf

│   ├── alb.tf

│   ├── ec2.tf

│   ├── rds.tf

│   ├── ecr.tf

│   ├── iam.tf

│   ├── cloudwatch.tf

│   ├── backend.tf

│   ├── backend-resources.tf

│   └── terraform.tfvars.example

│

├── Jenkinsfile

├── README.md

└── .gitignore

🛠️ Technologies Used

Category	Technology

Cloud	AWS

Infrastructure as Code	Terraform

CI/CD	Jenkins

Source Control	Git / GitHub

Containerization	Docker

Container Registry	Amazon ECR

Compute	Amazon EC2

Load Balancing	Application Load Balancer

Scaling	Auto Scaling Group

Database	Amazon RDS PostgreSQL

Networking	Amazon VPC

Security	IAM / Security Groups

Monitoring	Amazon CloudWatch

Application	Python / Flask

OS	Amazon Linux

⚙️ Prerequisites



Install and configure:



AWS CLI

Terraform

Docker

Git

Jenkins

GitHub



Verify installations:



aws --version

terraform --version

docker --version

git --version



AWS credentials should have the required permissions for the resources being deployed.



🚀 Manual Terraform Deployment



Navigate to the Terraform directory:



cd terraform



Initialize Terraform:



terraform init



Format Terraform files:



terraform fmt



Validate configuration:



terraform validate



Create deployment plan:



terraform plan



Apply infrastructure:



terraform apply



For automated deployment, use the Jenkins pipeline.



🔄 Jenkins Deployment



Jenkins performs:



GitHub Checkout

&#x20;      ↓

Terraform Validation

&#x20;      ↓

Docker Build

&#x20;      ↓

ECR Push

&#x20;      ↓

Terraform Plan

&#x20;      ↓

Manual Approval

&#x20;      ↓

Terraform Apply



After a successful deployment, Jenkins reports:



Docker image and AWS infrastructure deployed successfully.

✅ Application Verification



After deployment, retrieve the ALB DNS name:



terraform output alb\_dns\_name



Open:



http://<ALB-DNS-NAME>



Expected response:



Production 3-Tier Application - Server: <hostname>



Health check:



http://<ALB-DNS-NAME>/health



Expected response:



Healthy

🧪 Testing Load Balancing



Because the application returns the hostname of the EC2 server, repeated requests can be used to observe traffic distribution.



Example:



curl http://<ALB-DNS-NAME>/



Run multiple times:



curl http://<ALB-DNS-NAME>/

curl http://<ALB-DNS-NAME>/

curl http://<ALB-DNS-NAME>/



The response contains the backend server hostname.



🛠️ Challenges Faced and Solutions

1\. Terraform Database Password Error



Terraform initially requested:



var.db\_password

Enter a value:

Solution



The database password was stored in Jenkins Credentials and passed securely to Terraform during the pipeline.



2\. EC2 vCPU Quota



Terraform initially failed because the AWS account had an EC2 vCPU quota limitation.



The account had:



8 vCPUs



Existing EC2/EKS resources consumed available capacity.



Solution



Unused EKS resources were removed to free EC2 capacity for the application Auto Scaling Group.



3\. ECR Repository Not Empty



During cleanup, Terraform reported:



RepositoryNotEmptyException

Solution



Docker images were removed from ECR before destroying the repository.



4\. Missing AWS Account ID Data Source



Terraform referenced:



data.aws\_caller\_identity.current.account\_id

Solution



The following data source was added:



data "aws\_caller\_identity" "current" {}



This allows Terraform to dynamically retrieve the AWS account ID.



🧹 Cleanup



To destroy Terraform-managed resources:



cd terraform

terraform destroy



Before cleanup, ensure ECR images are removed if required.



After destruction, verify the AWS Console for remaining billable resources.



🎯 Key Learning Outcomes



This project provided hands-on experience with:



AWS VPC architecture

Public and private subnet design

Route tables

Internet Gateway

NAT Gateway

Security Groups

Application Load Balancer

EC2

Auto Scaling

Amazon ECR

Docker

Amazon RDS PostgreSQL

IAM

CloudWatch

Terraform

Jenkins CI/CD

GitHub integration

Secret management

AWS troubleshooting

🚀 Future Improvements



The following enhancements can further improve the project:



Remote Terraform state using S3

State locking

Versioned Docker image tags using Git commit SHA

HTTPS using ACM and ALB

Application-to-RDS database integration

/db-health endpoint

CloudWatch application log shipping

CPU/request-based Auto Scaling policies

AWS Secrets Manager

Least-privilege IAM policies

Terraform modules

Separate development and production environments

Automated application testing in Jenkins

Rolling or blue/green deployment strategy

💼 Resume Highlights

Project



Production-Style 3-Tier Web Application Deployment on AWS



Resume Description



Designed and deployed a production-style 3-tier web application architecture on AWS using Terraform, with a public Application Load Balancer, private EC2 application servers, Auto Scaling, and private PostgreSQL RDS. Containerized a Flask application using Docker, published images to Amazon ECR, and automated infrastructure provisioning through Jenkins CI/CD with Terraform validation, planning, manual approval, and deployment stages.



Key Points

Designed a secure AWS VPC with public and private subnet segmentation across two Availability Zones.

Deployed Dockerized Flask application on private EC2 instances behind an Application Load Balancer.

Implemented Auto Scaling Group with 2–4 application instances.

Automated Docker image build and Amazon ECR deployment through Jenkins.

Automated AWS infrastructure provisioning using Terraform.

Implemented Security Groups restricting communication between ALB, application, and database tiers.

Configured IAM-based ECR access for application instances.

Added CloudWatch monitoring and CPU alarm configuration.

Troubleshot AWS quota, Terraform state, credentials, and ECR deployment issues.

🎤 Interview Explanation

30-Second Answer



I developed a production-style 3-tier web application deployment on AWS using Terraform, Jenkins, Docker and ECR. I created a VPC with public and private subnets across two Availability Zones. The Application Load Balancer is placed in the public layer, while Dockerized Flask applications run on private EC2 instances managed by an Auto Scaling Group. PostgreSQL RDS is deployed in private database subnets. Jenkins automates the workflow from GitHub checkout, Terraform validation and Docker image creation to ECR push, Terraform plan, manual approval and infrastructure deployment.



Request Flow

User

&#x20;↓

Application Load Balancer

&#x20;↓

Private EC2

&#x20;↓

Docker Flask Application

&#x20;↓

RDS PostgreSQL

Deployment Flow

Developer

&#x20;↓

GitHub

&#x20;↓

Jenkins

&#x20;↓

Docker Build

&#x20;↓

Amazon ECR

&#x20;↓

Terraform Plan

&#x20;↓

Manual Approval

&#x20;↓

Terraform Apply

&#x20;↓

AWS Infrastructure

📌 Project Highlights

✓ Multi-tier AWS architecture

✓ Public and private subnet segmentation

✓ Application Load Balancer

✓ EC2 Auto Scaling

✓ Docker containerization

✓ Amazon ECR

✓ RDS PostgreSQL

✓ Terraform Infrastructure as Code

✓ Jenkins CI/CD

✓ IAM-based access

✓ CloudWatch monitoring

✓ Secure database networking

✓ GitHub integration

✓ Real-world troubleshooting

👨‍💻 Author



Venkata Sai Kiran Nadupuru



GitHub:



https://github.com/venkatasaikirannadupuru



📄 License



This project is licensed under the MIT License.

