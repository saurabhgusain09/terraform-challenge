# Day 03 – Create an AWS S3 Bucket using Terraform ☁️🪣

## 📌 Objective
On Day 02 of my Terraform journey, I created an **AWS S3 bucket using Terraform**.  
The goal was to understand how Terraform interacts with AWS services using providers and how infrastructure is created declaratively.

---

## 🧠 What I Learned Today

### 1️⃣ What is AWS S3?
Amazon S3 (Simple Storage Service) is an object storage service used to store and retrieve any amount of data securely and reliably.

Common use cases:
- Backup & restore
- Static website hosting
- Logs storage
- Media storage

---

### 2️⃣ Why Use Terraform with S3?
Terraform allows us to:
- Define S3 buckets as **code**
- Version control infrastructure
- Recreate resources easily
- Avoid manual AWS Console work

---

## 🧩 Terraform Concepts Used

### 🔹 Provider
The **AWS provider** allows Terraform to communicate with AWS APIs.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

