# Terraform Project Structure – Best Practices

This repository demonstrates a **production-ready Terraform project structure**, designed for **scalability, clarity, collaboration, and safety**.
The goal is to keep infrastructure **modular, reusable, predictable, and easy to manage** across environments.

---

## 📁 Recommended Terraform Directory Structure

```
terraform-infra/
│
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   │
│   └── s3/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   │
│   ├── staging/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   │
│   └── prod/
│       ├── main.tf
│       ├── terraform.tfvars
│       └── backend.tf
│
├── provider.tf
├── versions.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── .gitignore
└── README.md
```

---

## 🧠 Core Design Principles

### 1️⃣ Separate **Modules** from **Environments**

* **Modules** = reusable infrastructure logic
* **Environments** = configuration + values

> Same code, different values → predictable infrastructure

---

## 📦 Modules (Reusable Building Blocks)

Each module:

* Does **one job**
* Has **clear inputs (variables)**
* Exposes **outputs**

Example:

```
modules/vpc/
├── main.tf        # Resources
├── variables.tf   # Inputs
├── outputs.tf     # Exposed values
```

✅ No hard-coded values
✅ No environment-specific logic

---

## 🌍 Environments (dev / staging / prod)

Each environment:

* Uses the **same modules**
* Has **different tfvars**
* Has **its own state backend**

Example:

```
environments/dev/
├── main.tf
├── terraform.tfvars
├── backend.tf
```

---

## 🔐 Remote Backend & State Isolation

Best practice:

* One backend **per environment**
* Remote state (S3 + DynamoDB)

Benefits:

* Prevents state conflicts
* Enables team collaboration
* Enables state locking

---

## 🧩 File Responsibilities (Clear Separation)

### `versions.tf`

* Terraform version
* Provider version constraints

### `provider.tf`

* Cloud provider configuration
* Region, profile, etc.

### `variables.tf`

* All input variables
* No values here

### `terraform.tfvars`

* Actual values
* Environment specific

### `locals.tf`

* Derived values
* Naming logic
* Reusable expressions

---

## 🧱 Example Environment `main.tf`

```hcl
module "vpc" {
  source = "../../modules/vpc"

  cidr_block = var.vpc_cidr
  env         = var.environment
}
```

---

## 🧪 Variable Management Strategy

Priority order:

1. CLI flags
2. `.tfvars` file
3. Environment variables
4. Default values

👉 Keeps configuration flexible & safe

---

## 🛡️ Security Best Practices

* ❌ Never commit:

  * `terraform.tfstate`
  * `terraform.tfstate.backup`
  * `.terraform/`
* ✅ Always use `.gitignore`
* ✅ Use IAM roles instead of hardcoded credentials

---

## 🚀 Workflow (Professional Terraform Flow)

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Destroy safely:

```bash
terraform destroy
```

---

## 📌 Why This Structure Works in Real Projects

✔ Easy to scale
✔ Clean Git history
✔ Team friendly
✔ CI/CD compatible
✔ Interview-ready explanation

---

## 🧠 Final Thought

> Terraform is not about writing resources.
> Terraform is about **designing infrastructure systems**.

This structure enforces **thinking before coding**, which is the core mindset of a DevOps / Cloud Engineer.

---

### ⭐ If you understand this structure, you already think like a production engineer.
