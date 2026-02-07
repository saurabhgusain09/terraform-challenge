# Terraform Day 05 — Variables, Locals, Outputs & Variable Precedence (Complete README)

This README documents the complete Day-05 learning of Terraform using **first-principle thinking**.  
The focus is to understand how data flows inside Terraform — from input to final output — in a clean, reusable, and production-ready way.

---

## Terraform Big Picture (First Principle)

Terraform behaves like a function:

Inputs → Processing → Outputs

| Layer | Concept | Purpose |
|-----|--------|--------|
| Input | Variables | Accept values from outside |
| Processing | Locals | Compute / derive values |
| Action | Resources | Create infrastructure |
| Result | Outputs | Expose final values |

Understanding this flow is critical for real-world DevOps and cloud automation.

---

## 1. Input Variables — How Data Enters Terraform

### What is an Input Variable?

An input variable allows Terraform to accept values from **outside the configuration**, instead of hard-coding them.

**Core idea:**  
Infrastructure logic should remain constant, values should change.

### Example

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
Usage:

provider "aws" {
  region = var.region
}
Key Points
Variables represent inputs

Accessed using var.<name>

Can be overridden

Enable environment flexibility (dev / stage / prod)

2. Locals — Internal Processing Layer
What are Locals?
Local values store calculated or derived values inside Terraform.

Locals:

Do NOT take user input

Do NOT create infrastructure

Are pure computations

First-Principle Rule
If a value is derived from other values, it belongs in locals.

Example
variable "env" {
  default = "dev"
}

locals {
  app_name = "myapp"
  prefix   = "${local.app_name}-${var.env}"
}
Usage:

bucket = "${local.prefix}-assets"
Why Locals Exist
Avoid repeating expressions

Improve readability

Centralize logic

Reduce human errors

Mental Model
Variables = raw data
Locals = processed data
Resources = actions

3. Outputs — Exposing Terraform Results
What is an Output Variable?
Output variables expose values after infrastructure is created.

Terraform already knows everything internally — outputs are how users and systems consume results.

Example
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC ID created by Terraform"
}
Use Cases
View values on CLI

Share values between modules

Feed values into CI/CD pipelines

Debug and validate infrastructure

Important Notes
Outputs do NOT create infrastructure

Outputs do NOT modify infrastructure

Outputs are evaluated after terraform apply

4. Variable Precedence — Which Value Wins?
A variable can be set from multiple places.
Terraform uses a strict priority order to decide which value is finally used.

Precedence Order (Highest → Lowest)
CLI -var

CLI -var-file

Auto-loaded .tfvars files

Environment variables (TF_VAR_*)

Default value in variable block

Example
terraform apply -var="env=prod"
This overrides:

tfvars values

environment variables

defaults

Golden Rule
The value closest to execution time has the highest priority.

5. End-to-End Data Flow
User input → variable
Derived logic → locals
Infrastructure → resources
Exposed results → output

This separation makes Terraform:

Reusable

Predictable

Production-ready

6. Real-World Combined Example
variable "env" {
  default = "dev"
}

locals {
  name_prefix = "myapp-${var.env}"
}

resource "aws_s3_bucket" "main" {
  bucket = "${local.name_prefix}-bucket"
}

output "bucket_name" {
  value = aws_s3_bucket.main.bucket
}
Same codebase → multiple environments.

7. Common Mistakes to Avoid
Setting the same variable in many places

Writing complex logic directly inside resources

Ignoring variable precedence during debugging

Treating locals as inputs


