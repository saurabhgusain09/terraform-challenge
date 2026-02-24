Day 15 – Cross Region VPC Peering using Terraform
📌 Project Overview

This project demonstrates how to configure Cross-Region VPC Peering in AWS using Terraform.

The objective was to design and provision two independent VPCs in different AWS regions and enable secure private communication between EC2 instances using Infrastructure as Code.

All networking components were provisioned programmatically using Terraform.

🧠 Key Learning Objective

Understand how AWS networking works at a foundational level:

How route tables control traffic flow

How Internet Gateways enable outbound connectivity

How VPC Peering enables private cross-VPC communication

How multi-provider Terraform configuration supports cross-region deployments

🏗 Architecture Overview
Primary Region (e.g., ap-south-1)

VPC

Public Subnet

Internet Gateway

Route Table

Security Group

EC2 Instance

Secondary Region (e.g., ap-southeast-1)

VPC

Public Subnet

Internet Gateway

Route Table

Security Group

EC2 Instance

Connectivity

VPC Peering connection established

Route tables updated for cross-VPC traffic

ICMP enabled between VPC CIDR blocks

SSH allowed for management access

🔁 Traffic Flow Explanation
1️⃣ Intra-VPC Communication

Automatically handled by AWS via local route.

2️⃣ Internet Access
0.0.0.0/0 → Internet Gateway

Allows instances to access the public internet.

3️⃣ Cross-VPC Communication
Primary CIDR → Peering Connection
Secondary CIDR → Peering Connection

Enables private communication without using the internet.

🛠 Technologies Used

Terraform

AWS VPC

AWS EC2

VPC Peering

Internet Gateway

Route Tables

Security Groups

Ubuntu AMI fetched dynamically from official publisher:
Canonical Ltd.

📂 Project Structure
day15/
├── providers.tf
├── variables.tf
├── data.tf
├── main.tf
├── outputs.tf
└── README.md
⚙️ Terraform Concepts Demonstrated
✔ Multi-Provider Configuration

Used provider aliases to deploy infrastructure in two different AWS regions.

✔ Data Source Usage

Fetched latest Ubuntu AMI dynamically using aws_ami data source instead of hardcoding AMI IDs.

✔ Route Table Management

Understood the importance of:

Default route (0.0.0.0/0)

Local route (auto-managed by AWS)

Peering route (manual configuration required)

✔ Security Group Configuration

SSH access

ICMP between VPC CIDRs

Controlled outbound access

✔ VPC Peering Behavior

Bi-directional communication

Non-transitive nature

Route table updates required on both sides

🚀 Deployment Steps
1️⃣ Initialize Terraform
terraform init
2️⃣ Validate Configuration
terraform validate
3️⃣ Plan Infrastructure
terraform plan
4️⃣ Apply Infrastructure
terraform apply
5️⃣ Destroy Infrastructure
terraform destroy
📊 What This Project Proves

This implementation demonstrates:

Strong understanding of AWS networking fundamentals

Ability to troubleshoot route and peering issues

Understanding of region-based resource limitations

Practical use of Terraform for real-world cloud architecture

🎯 Real-World Relevance

Cross-region communication patterns are common in:

Disaster Recovery setups

Multi-region application deployments

Environment isolation (Prod / DR)

Microservice architectures

This project simulates a simplified production networking pattern.

🧩 Improvements for Production

If extended further, this setup could include:

NAT Gateway for private subnets

Remote backend for Terraform state

Reusable Terraform modules

Transit Gateway instead of Peering

Automated testing using CI/CD

📌 Key Takeaways

Never route your own VPC CIDR to Internet Gateway

VPC Peering requires explicit route updates

Instance type availability varies by region

Secrets like .pem files must never be committed

Multi-region deployment requires provider alias usage

👨‍💻 Author

Saurabh Gusain
DevOps & Cloud Engineering Learner
Building strong cloud networking foundations one day at a time.