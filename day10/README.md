# 🚀 Terraform Expressions – Complete Deep Guide (Day 10)

---

# 📌 Why Expressions Exist in Terraform?

Terraform is **declarative**.

We do NOT write step-by-step logic.
We declare the desired state.

But real infrastructure is NOT static:

- Dev ≠ Prod
- Cost ≠ Performance
- Security ≠ Convenience

So Terraform needs a way to:
- Decide values
- Repeat structures
- Extract data
- Adapt configuration

That is why **Expressions** exist.

---

# 🧠 Core Engineering Principle

> Infrastructure should be adaptable, but predictable.

Expressions help us:
- Avoid hardcoding
- Avoid duplication
- Keep infra deterministic
- Make config data-driven

---

# 1️⃣ Conditional Expression

---

## 🧠 First Thought

Conditional expression is a **value selector**.

It does NOT control execution.
It only chooses a value.

---

## 📌 Syntax

```hcl
condition ? value_if_true : value_if_false
```

---

## 📌 Example

```hcl
variable "environment" {
  default = "dev"
}

instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"
```

---

## 🧪 Dry Run

### Case 1: environment = "prod"

Condition:
```
"prod" == "prod" → TRUE
```

Result:
```
instance_type = "t3.large"
```

---

### Case 2: environment = "dev"

Condition:
```
"dev" == "prod" → FALSE
```

Result:
```
instance_type = "t2.micro"
```

---

## 🎯 Engineering Purpose

✔ Environment-based config  
✔ Cost control  
✔ Performance tuning  
✔ Feature toggling  

---

## 🚨 Important Rule

Conditional expression:
- Returns ONE value
- Must be deterministic
- Should not contain complex business logic

---

# 2️⃣ Splat Expression

---

## 🧠 First Thought

Splat is for **bulk attribute extraction**.

If multiple similar resources exist,
and you want the same attribute from all,
use splat.

---

## 📌 Example

```hcl
resource "aws_instance" "web" {
  count = 3
}
```

Terraform creates:

```
web[0]
web[1]
web[2]
```

Now extract all public IPs:

```hcl
aws_instance.web[*].public_ip
```

---

## 🧪 Dry Run

Assume:

```
web[0].public_ip = "1.1.1.1"
web[1].public_ip = "2.2.2.2"
web[2].public_ip = "3.3.3.3"
```

Expression:

```hcl
aws_instance.web[*].public_ip
```

Result:

```
[
  "1.1.1.1",
  "2.2.2.2",
  "3.3.3.3"
]
```

---

## 🎯 Engineering Purpose

✔ Avoid manual indexing  
✔ Extract structured data cleanly  
✔ Keep output readable  
✔ Work with count/for_each resources  

---

## 🧠 Modern Alternative

```hcl
[for instance in aws_instance.web : instance.public_ip]
```

This is more explicit and recommended in newer Terraform.

---

# 3️⃣ Dynamic Block

---

## 🧠 First Thought

Dynamic block is for:

> Repeating nested blocks inside a resource.

It does NOT repeat resources.
It repeats internal structure.

---

## 📌 Real Problem

Security group example:

```
ingress { port 22 }
ingress { port 80 }
ingress { port 443 }
```

Structure same.
Only port changes.

Manual repetition = bad design.

---

## 📌 Example

```hcl
variable "environment" {
  default = "dev"
}

variable "ports" {
  type = map(list(number))
  default = {
    dev  = [22, 80]
    prod = [80, 443]
  }
}

resource "aws_security_group" "example" {
  name = "app-sg"

  dynamic "ingress" {
    for_each = var.ports[var.environment]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

---

## 🧪 Dry Run

### Case 1: environment = "dev"

```
var.ports["dev"] → [22, 80]
```

Terraform generates:

```
ingress { port 22 }
ingress { port 80 }
```

---

### Case 2: environment = "prod"

```
var.ports["prod"] → [80, 443]
```

Terraform generates:

```
ingress { port 80 }
ingress { port 443 }
```

---

## 🎯 Engineering Purpose

✔ Data-driven infrastructure  
✔ Avoid duplication  
✔ Separate structure & data  
✔ Scalable configuration  

---

# 🔥 Expression Comparison

| Concept | Purpose | Repeats What? |
|----------|----------|---------------|
| Conditional | Choose value | Nothing (value only) |
| Splat | Extract attribute | Data from list |
| Dynamic | Repeat nested block | Internal block |
| count | Repeat resource | Entire resource |
| for_each | Repeat resource | Entire resource |

---

# 🚨 Anti-Patterns

❌ Writing complex nested conditions  
❌ Using dynamic when only 1 static block needed  
❌ Treating Terraform like a programming language  
❌ Using randomness in expressions  
❌ Hardcoding environment logic everywhere  

---

# 🎯 Golden DevOps Rules

1. Structure should remain stable.
2. Data should drive change.
3. Expressions must be deterministic.
4. Avoid duplication.
5. Keep configuration readable.
6. Infrastructure must not surprise you.

---

# 🏁 Final Summary

Terraform Expressions exist to:

- Decide values (Conditional)
- Extract bulk data (Splat)
- Generate repeated structure (Dynamic)
- Keep infra adaptable
- Keep infra predictable

---

# 💬 Interview One-Liners

**Conditional Expression:**
> A deterministic value selector used to adapt configuration without breaking declarative design.

**Splat Expression:**
> A shorthand to extract the same attribute from all elements of a resource collection.

**Dynamic Block:**
> A data-driven mechanism to generate repeated nested configuration blocks inside a resource.

---

# 🚀 End of Day 10 – Expressions Mastery

If you understand:
- Why they exist
- What problem they solve
- How they behave during plan phase

Then you are thinking like an Infrastructure Engineer, not just a Terraform user.

