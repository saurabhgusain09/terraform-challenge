# Terraform – Day 07  
## Terraform Variable Types (Deep Dive & Practical Understanding)

This day focuses on **Terraform’s type system**, which is the backbone of writing **safe, scalable, and production-grade Infrastructure as Code (IaC)**.

Understanding these data types correctly eliminates configuration errors, improves readability, and makes Terraform modules predictable and reusable.

---

## Why Terraform Variable Types Matter

Terraform variables are not just inputs — they are **contracts**.

Proper typing ensures:
- Invalid values are rejected early
- Infrastructure behavior is predictable
- Large projects remain maintainable
- Teams avoid accidental misconfiguration

Terraform supports both **primitive** and **complex** types.

---

## Primitive Types

### 1. `string`
Used for text values.

```hcl
variable "region" {
  type = string
}


Example values:

"ap-south-1"
"us-east-1"


Use when a single textual value is required.

2. number

Used for numeric values.

variable "instance_count" {
  type = number
}


Example values:

1
2
10


Use when arithmetic or numeric comparison is involved.

3. bool

Used for true/false flags.

variable "enable_monitoring" {
  type = bool
}


Example values:

true
false


Use for feature toggles or conditional behavior.

Collection Types
4. list(type)

An ordered collection of values of the same type.

variable "availability_zones" {
  type = list(string)
}


Example:

["ap-south-1a", "ap-south-1b"]


Characteristics:

Order matters

Index-based access allowed

var.availability_zones[0]


Use when order and repetition matter.

5. set(type)

An unordered collection of unique values.

variable "allowed_ports" {
  type = set(number)
}


Example:

[22, 80, 443, 80]


Terraform internally treats this as:

{22, 80, 443}


Characteristics:

No duplicates

No indexing

Order is not guaranteed

Best suited for:

Security group rules

CIDR blocks

Any “allowed values” list

Converting SET to LIST
tolist(var.allowed_ports)


⚠️ Ordering is not guaranteed after conversion.

Extracting One Value from a SET
Option 1: When exactly one value must exist
one(var.allowed_ports)


Fails if size ≠ 1 (safe & strict).

Option 2: Filter then index
locals {
  http_ports = [
    for p in var.allowed_ports : p
    if p == 80
  ]
}

local.http_ports[0]

6. map(type)

A collection of key → value pairs.

variable "instance_types" {
  type = map(string)
}


Example:

{
  web = "t2.micro"
  api = "t3.small"
  db  = "t3.medium"
}


Access:

var.instance_types["web"]


Use when values need names or identifiers.

map with for_each
resource "aws_instance" "servers" {
  for_each = var.instance_types

  instance_type = each.value

  tags = {
    Name = each.key
  }
}


Creates one resource per key.

Safe Lookup in a MAP
lookup(var.instance_types, "cache", "t2.nano")


Prevents runtime errors.

Structural Types
7. tuple([types...])

A fixed-length, ordered structure with predefined types.

variable "rule" {
  type = tuple([number, number, string])
}


Example:

[80, 80, "tcp"]


Access:

var.rule[0]  # from_port
var.rule[1]  # to_port
var.rule[2]  # protocol


Characteristics:

Order matters

Types are positional

Strict structure

Use when:

Position has meaning

Structure must never change

Tuple Inside a List
variable "subnets" {
  type = list(tuple([string, string]))
}


Example:

[
  ["ap-south-1a", "10.0.1.0/24"],
  ["ap-south-1b", "10.0.2.0/24"]
]

8. object({})

A named structure representing a real-world entity.

variable "server" {
  type = object({
    name          = string
    instance_type = string
    volume_size   = number
    monitoring    = bool
  })
}


Example:

{
  name          = "web"
  instance_type = "t2.micro"
  volume_size   = 20
  monitoring    = true
}


Access:

var.server.instance_type

Real-World Patterns with OBJECT
Object Inside a Map (Production Pattern)
variable "servers" {
  type = map(object({
    instance_type = string
    volume_size   = number
  }))
}


Example:

{
  web = {
    instance_type = "t2.micro"
    volume_size   = 20
  }
  db = {
    instance_type = "t3.medium"
    volume_size   = 100
  }
}


Used with:

for_each = var.servers

Variable Validation (Guardrails)
variable "region" {
  type = string

  validation {
    condition     = contains(var.allowed_region, var.region)
    error_message = "Region must be one of the allowed regions."
  }
}


Ensures incorrect values are rejected before infrastructure creation.

Mental Model Summary
Type	Purpose
string	Single text value
number	Numeric value
bool	True/false flag
list	Ordered collection
set	Unique unordered values
map	Named values
tuple	Fixed positional structure
object	Real-world configuration
Interview-Ready Takeaway

Terraform’s type system is designed to:

Prevent invalid infrastructure

Encode intent into code

Make configurations self-documenting

Mastering variable types is a non-negotiable skill for production Terraform.

Day 07 Status

✅ Variable Types
✅ LIST / SET / MAP
✅ TUPLE / OBJECT
✅ Validation & Best Practices

Day 07 completed successfully.
