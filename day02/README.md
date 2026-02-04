# Terraform Day 02 – Providers, Versioning & Declarative vs Imperative

## Overview
Day 02 focuses on understanding **Terraform Providers**, why **provider versioning matters**, and the core difference between **Declarative** and **Imperative** approaches.  
The goal is to understand *why Terraform works the way it does*, not just how to write code.

---

## What is a Provider? (First Principle)

Terraform by itself cannot talk to cloud platforms or external systems.

A **provider** is a **plugin** that acts as a bridge between **Terraform Core** and **real-world APIs** such as AWS, Azure, GCP, Kubernetes, GitHub, etc.

### Key Idea
- Terraform decides **WHAT** infrastructure is needed
- Provider decides **HOW** to create it using API calls

Without a provider, Terraform cannot create or manage any real infrastructure.

---

## Why Providers Exist

Terraform is **cloud-agnostic**, meaning it does not contain built-in logic for AWS, Azure, or any other platform.

Each platform has:
- Different APIs
- Different authentication methods
- Different behaviors

Providers encapsulate this complexity and translate Terraform configuration into real API requests.

---

## Provider Versioning – Why It Matters

Providers are **software**, and software changes over time.

### Problems without version control
- Breaking changes can occur
- Resource behavior may change
- Terraform plans may suddenly fail
- Infrastructure may be recreated unintentionally

### Solution
Lock provider versions to ensure:
- Predictable behavior
- Repeatable infrastructure
- Team and CI/CD consistency
- State file safety

---

## Semantic Versioning (MAJOR.MINOR.PATCH)

Example version: `6.2.1`

- **MAJOR** → Breaking changes possible
- **MINOR** → New features (usually safe)
- **PATCH** → Bug fixes (safe)

---

## The `~>` Version Constraint (Pessimistic Constraint)

The `~>` operator allows **safe upgrades** while blocking **breaking upgrades**.

### Examples

```hcl
version = "~> 6.0"

