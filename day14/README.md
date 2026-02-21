# 🚀 Static Website Hosting on AWS using Terraform (S3 + CloudFront + OAC)

This project provisions a secure, production-ready static website hosting setup using:

- **Amazon S3** (Private bucket)
- **CloudFront Distribution**
- **Origin Access Control (OAC)**
- **Terraform Infrastructure as Code**

---

## 🏗 Architecture Overview

User → CloudFront → (Signed Request via OAC) → Private S3 Bucket

### 🔐 Security Model

- S3 bucket is **NOT public**
- Public access block is enabled
- Only CloudFront can access S3 via **OAC**
- Bucket policy allows only specific CloudFront distribution (SourceArn condition)

---

## 📁 Project Structure


day14/
│
├── www/
│ ├── index.html
│ ├── style.css
│ └── script.js
│
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars


---

## ⚙️ Features Implemented

- ✅ Private S3 bucket
- ✅ Public access block enabled
- ✅ Secure bucket policy using OAC
- ✅ CloudFront CDN distribution
- ✅ Geo restriction configured
- ✅ Automatic file upload using `fileset()`
- ✅ Automatic file change detection using `etag`
- ✅ Correct `content_type` handling for HTML, CSS, JS
- ✅ Default root object configured

---

## 🧠 Key Concepts Used

### 1️⃣ Origin Access Control (OAC)

OAC ensures:
- S3 bucket remains private
- Only CloudFront can access objects
- Requests are signed using SigV4

---

### 2️⃣ Bucket Policy (Resource-Based Policy)

Allows only:

```json
Principal: cloudfront.amazonaws.com
Action: s3:GetObject
Condition: AWS:SourceArn = specific CloudFront distribution
3️⃣ fileset() + for_each

Automatically uploads all files inside www/:

for_each = fileset("${path.module}/www", "*")
4️⃣ ETag (filemd5)

Used to detect local file changes:

etag = filemd5("file_path")

Ensures updated files are re-uploaded.

5️⃣ content_type Handling

Prevents browser download issue by setting correct MIME type:

text/html

text/css

application/javascript

image/png

etc.

🚀 Deployment Steps
1️⃣ Initialize Terraform
terraform init
2️⃣ Review Plan
terraform plan
3️⃣ Apply Infrastructure
terraform apply
🌍 Accessing Website

After deployment:

Go to AWS Console → CloudFront

Open Distribution

Copy Domain Name

Open in browser:


https://xxxxxxx.cloudfront.net

🔎 Common Issues & Fixes
❌ 403 Error

Check Geo Restriction

Ensure bucket policy correct

Confirm OAC attached

❌ File Downloading Instead of Rendering

Cause:
Wrong Content-Type

Fix:
Ensure content_type is correctly set in aws_s3_object

❌ Policy Error: Action does not apply to any resource(s)

Cause:
Using s3:ListBucket with object ARN

Fix:

Use s3:GetObject for bucket/*

Use s3:ListBucket only for bucket

📌 Production Best Practices

Use ACM for custom domain

Enable HTTPS redirect

Enable CloudFront invalidations for CI/CD

Enable S3 versioning

Use Terraform modules for reusability

👨‍💻 Author

Saurabh Gusain
DevOps / DevSecOps Enthusiast
Building secure & scalable cloud infrastructure 🚀