# 🚀 Day 09 – Terraform Lifecycle & Conditions (Production Deep Dive)

## 📌 Introduction

In real-world cloud infrastructure, simply creating resources is not enough.  
We must control:

- How resources are replaced
- How accidental deletion is prevented
- How configuration drift is handled
- How infrastructure validity is enforced

Terraform provides powerful mechanisms through:

- Lifecycle Rules
- Preconditions
- Postconditions

This document explores these concepts from a production engineering perspective.

---

# 🧠 Core Principle

Terraform operates on:

> Desired State (Code) vs Current State (Cloud) → Plan → Apply

By default, Terraform strictly enforces the desired state.  
However, production environments require controlled behavior.

Lifecycle and Conditions allow us to modify and validate this behavior.

---

# 🔥 Lifecycle Block

Lifecycle is a meta-argument used inside a resource block to control how Terraform manages that resource during changes.

### Basic Structure

```hcl
resource "aws_instance" "example" {

  # arguments

  lifecycle {
    # behavior modifiers
  }
}
```

---

# 1️⃣ create_before_destroy

## Problem

When a resource requires replacement, Terraform by default:

1. Destroys old resource
2. Creates new resource

This may cause downtime.

## Solution

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxx"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

## Behavior

Terraform will:

1. Create new instance
2. Destroy old instance

### Use Cases

- Production EC2 instances
- Load balancers
- High availability services

---

# 2️⃣ prevent_destroy

## Problem

Accidental deletion of critical resources can cause severe outages.

## Solution

```hcl
resource "aws_db_instance" "prod_db" {

  lifecycle {
    prevent_destroy = true
  }
}
```

## Behavior

If destruction is attempted:

Terraform throws an error and blocks execution.

### Use Cases

- Production databases
- Backend state buckets
- Long-term storage
- Critical networking components

---

# 3️⃣ ignore_changes

## Problem

Some attributes change automatically or externally:

- AWS-managed tags
- Auto Scaling desired capacity
- Manual console updates

Terraform detects these as drift and tries to revert them.

## Solution

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxx"
  instance_type = "t2.micro"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
```

## Behavior

Terraform will ignore changes to specified attributes.

### Use Cases

- Dynamic scaling environments
- Auto-injected tags
- External automation tools

---

# 4️⃣ replace_triggered_by (Advanced)

## Purpose

Force a resource to be replaced when another resource changes.

```hcl
resource "aws_instance" "web" {

  lifecycle {
    replace_triggered_by = [
      aws_security_group.web_sg
    ]
  }
}
```

If the security group changes → instance will be recreated.

### Use Cases

- Security architecture updates
- Network dependency changes
- Strict infrastructure consistency requirements

---

# 🛡 Preconditions & Postconditions

Terraform allows runtime validation of infrastructure behavior.

---

## 🔵 Precondition

Checked before resource creation.

```hcl
resource "aws_instance" "web" {
  instance_type = var.instance_type

  lifecycle {
    precondition {
      condition     = var.instance_type == "t2.micro"
      error_message = "Only t2.micro instances allowed."
    }
  }
}
```

### Purpose

- Validate input values
- Enforce organizational policies
- Prevent misconfiguration

---

## 🟢 Postcondition

Checked after resource creation.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxx"
  instance_type = "t2.micro"

  lifecycle {
    postcondition {
      condition     = self.instance_state == "running"
      error_message = "Instance must be in running state."
    }
  }
}
```

### Purpose

- Validate resource health
- Enforce compliance
- Confirm expected state

---

# 🔍 Common Type Error (List vs String)

Terraform is strongly typed.

Example variable:

```hcl
variable "allow_cidr" {
  type = list(string)
  default = [
    "10.0.0.0/8",
    "192.168.0.0/16",
    "172.16.0.0/12"
  ]
}
```

Incorrect usage:

```hcl
cidr_blocks = var.allow_cidr[0]
```

Error:
List of string required, but string provided.

Correct usage:

```hcl
cidr_blocks = var.allow_cidr
```

Or:

```hcl
cidr_blocks = [var.allow_cidr[0]]
```

---

# 📊 Comparison Overview

| Feature | Stage | Purpose |
|----------|--------|----------|
| create_before_destroy | Replacement | Avoid downtime |
| prevent_destroy | Destroy phase | Block accidental deletion |
| ignore_changes | Update phase | Allow controlled drift |
| replace_triggered_by | Dependency change | Force recreation |
| precondition | Before creation | Validate inputs |
| postcondition | After creation | Validate result |

---

# 🏗 Production Engineering Perspective

Without lifecycle control:

Terraform is powerful but risky.

With lifecycle and conditions:

Terraform becomes:

- Safer
- Predictable
- Compliance-aware
- Production-ready

Infrastructure as Code is not just about automation.  
It is about control, safety, and reliability.

---

# 🎯 Key Takeaway

Lifecycle rules and conditions transform Terraform from a provisioning tool into a controlled infrastructure governance system.

---

# 📚 Further Reading


# Terraform Lifecycle Controls & Runtime Validation  


---

## 1. Purpose

This document defines how Terraform Lifecycle Rules and Runtime Conditions are used to enforce infrastructure safety, availability, and compliance within cloud environments.

In production systems, infrastructure changes must be:

- Predictable
- Controlled
- Auditable
- Non-disruptive
- Policy-compliant

Terraform lifecycle configuration enables governance over resource behavior during creation, modification, and destruction.

---

## 2. Operational Context

Terraform works on the principle of:

> Desired State (Declared in Code) vs Actual State (Cloud Provider)

Terraform calculates differences and applies changes accordingly.

However, uncontrolled changes may result in:

- Service downtime
- Accidental data loss
- Infrastructure drift
- Security policy violations
- Compliance failures

Lifecycle controls and runtime conditions mitigate these risks.

---

# 3. Lifecycle Controls

Lifecycle is a meta-argument applied at the resource level to influence execution behavior.

Structure:

```hcl
resource "<provider>_<resource>" "<name>" {

  # configuration arguments

  lifecycle {
    # control directives
  }
}
```

---

## 3.1 create_before_destroy

### Objective
Ensure zero or minimal downtime during resource replacement.

### Default Terraform Behavior
When a resource requires replacement:
1. Destroy old resource
2. Create new resource

This may cause temporary unavailability.

### Controlled Behavior

```hcl
resource "aws_instance" "application" {
  ami           = "ami-xxxx"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}
```

### Execution Model
1. Create new resource
2. Rewire dependencies
3. Destroy old resource

### Enterprise Use Cases
- Stateless application servers
- Load balancers
- High-availability services
- Rolling infrastructure updates

---

## 3.2 prevent_destroy

### Objective
Protect critical infrastructure from accidental deletion.

### Risk Scenario
- Accidental `terraform destroy`
- Resource block removal
- Misconfigured automation

### Controlled Behavior

```hcl
resource "aws_db_instance" "production_db" {

  lifecycle {
    prevent_destroy = true
  }
}
```

### Enforcement Mechanism
Terraform will fail during plan/apply if destruction is detected.

### Enterprise Use Cases
- Production databases
- State storage buckets
- Long-term persistent storage
- Core networking components

---

## 3.3 ignore_changes

### Objective
Allow controlled drift for selected attributes.

### Problem Context
Some attributes may change externally:

- Auto Scaling desired capacity
- Cloud-managed tags
- External automation tools
- Manual operational changes

Terraform by default attempts to revert such changes.

### Controlled Behavior

```hcl
resource "aws_instance" "application" {
  ami           = "ami-xxxx"
  instance_type = "t2.micro"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
```

### Effect
Terraform will not trigger updates when specified attributes drift.

### Enterprise Use Cases
- Auto-scaling environments
- Policy-injected metadata
- Monitoring-managed fields

---

## 3.4 replace_triggered_by

### Objective
Force resource replacement based on dependency changes.

```hcl
resource "aws_instance" "application" {

  lifecycle {
    replace_triggered_by = [
      aws_security_group.application_sg
    ]
  }
}
```

### Effect
If the referenced resource changes in a way that impacts integrity, dependent resource will be replaced.

### Enterprise Use Cases
- Security posture changes
- Network boundary updates
- Strict immutability patterns

---

# 4. Runtime Validation Controls

Terraform supports runtime validation using preconditions and postconditions.

These mechanisms provide policy enforcement at execution time.

---

## 4.1 Precondition

### Objective
Validate configuration constraints before resource creation.

```hcl
resource "aws_instance" "application" {
  instance_type = var.instance_type

  lifecycle {
    precondition {
      condition     = var.instance_type == "t2.micro"
      error_message = "Only approved instance types are allowed."
    }
  }
}
```

### Use Cases
- Enforce approved instance types
- Restrict regions
- Validate storage minimums
- Enforce environment tagging rules

---

## 4.2 Postcondition

### Objective
Validate resource state after provisioning.

```hcl
resource "aws_instance" "application" {
  ami           = "ami-xxxx"
  instance_type = "t2.micro"

  lifecycle {
    postcondition {
      condition     = self.instance_state == "running"
      error_message = "Instance failed to reach running state."
    }
  }
}
```

### Use Cases
- Verify encryption enabled
- Ensure public access disabled
- Validate resource health
- Confirm compliance settings

---

# 5. Type Safety & Validation

Terraform is strongly typed.

Example:

```hcl
variable "allow_cidr" {
  type = list(string)
}
```

Incorrect usage:

```hcl
cidr_blocks = var.allow_cidr[0]
```

This returns a string, while `cidr_blocks` requires `list(string)`.

Correct usage:

```hcl
cidr_blocks = var.allow_cidr
```

or

```hcl
cidr_blocks = [var.allow_cidr[0]]
```

Strict type enforcement ensures infrastructure predictability and prevents runtime ambiguity.

---

# 6. Governance Perspective

Lifecycle and validation controls elevate Terraform from:

Basic automation tool  
to  
Infrastructure governance framework.

They provide:

- Deployment safety
- Operational resilience
- Change management enforcement
- Compliance validation
- Risk mitigation

---

# 7. Engineering Principles Enforced

1. Infrastructure must be immutable where required.
2. Critical resources must not be destructible without explicit review.
3. Downtime must be minimized during updates.
4. Drift must be controlled, not blindly reverted.
5. Configuration must be validated before and after deployment.

---

# 8. Strategic Takeaway

Lifecycle rules and runtime conditions transform Terraform into a controlled infrastructure execution engine.

When properly applied, they ensure:

- High availability
- Operational safety
- Regulatory compliance
- Predictable deployments
- Enterprise-grade governance

---
