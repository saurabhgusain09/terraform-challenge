# Terraform Arguments & Meta-Arguments (Day 08)

## Introduction

Terraform configurations are built using **arguments** and **meta-arguments**.  
Understanding the difference between these two is essential for writing scalable, safe, and production-ready Infrastructure as Code.

This document explains both concepts from first principles with clear examples.

---

## What is an Argument?

### Definition

An **argument** is a value provided to a resource, block, or function that defines **what the resource should look like or how it should be configured**.

In simple terms:
- Arguments describe **WHAT to create**

---

### Example

```hcl
resource "aws_instance" "example" {
  ami           = "ami-0abc123"
  instance_type = "t2.micro"
}


Types of Meta-Arguments in Terraform

Terraform commonly supports the following meta-arguments:

count

for_each

depends_on

lifecycle

provider

1. count
Purpose

Creates multiple identical copies of a resource.

Key Idea

Numeric-based repetition.

Example
resource "aws_instance" "server" {
  count         = 3
  ami           = "ami-0abc123"
  instance_type = "t2.micro"
}


Terraform creates:

aws_instance.server[0]

aws_instance.server[1]

aws_instance.server[2]

Use Case

Fixed number of identical resources

2. for_each
Purpose

Creates one resource per item in a collection (list, set, or map).

Key Idea

Data-driven resource creation.

Example
resource "aws_instance" "env" {
  for_each = toset(["dev", "qa", "prod"])

  ami = "ami-0abc123"

  tags = {
    Name = each.key
  }
}

Why for_each is Preferred

Stable resource identity

Safer updates

Production friendly

count vs for_each
Feature	count	for_each
Based on	Number	Collection
Indexing	Numeric	Key-based
Stability	Low	High
Production Use	Limited	Recommended
3. depends_on
Purpose

Defines explicit dependencies between resources.

Key Idea

Controls creation order.

Example
resource "aws_instance" "app" {
  ami = "ami-0abc123"

  depends_on = [
    aws_security_group.app_sg
  ]
}


Terraform ensures the security group is created first.

4. lifecycle
Purpose

Controls resource create, update, and destroy behavior.

4.1 prevent_destroy
lifecycle {
  prevent_destroy = true
}


Prevents accidental deletion of critical resources.

4.2 create_before_destroy
lifecycle {
  create_before_destroy = true
}


Creates new resource before destroying the old one to avoid downtime.

4.3 ignore_changes
lifecycle {
  ignore_changes = [tags]
}


Ignores manual or external changes.

5. provider
Purpose

Specifies which provider configuration a resource should use.

Key Idea

Multi-region or multi-account control.

Example
resource "aws_instance" "mumbai" {
  provider = aws.mumbai
  ami      = "ami-xyz"
}

Arguments vs Meta-Arguments
Aspect	Arguments	Meta-Arguments
Define	Resource configuration	Terraform behavior
Managed by	Cloud Provider	Terraform
Examples	ami, tags	count, lifecycle