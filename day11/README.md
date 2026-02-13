# 📘 Day 11 - Terraform Functions (Complete Notes)

## 📌 Overview

In this module, we covered Terraform Built-in Functions, including:

- String Functions
- Collection Functions
- lookup() Function (Deep Dive)
- Real-world DevOps Examples
- Important Interview Differences

Terraform functions help manipulate and transform values inside Terraform configurations, making infrastructure dynamic and production-ready.

---

# 🧠 What Are Terraform Functions?

Terraform functions are built-in helpers that:

- Transform values
- Perform calculations
- Manipulate strings
- Work with lists and maps
- Enable dynamic infrastructure

⚠️ Important Notes:
- Terraform does NOT allow custom functions.
- Only built-in functions can be used.
- Functions are pure (no side effects).

---

# 🔤 STRING FUNCTIONS

Used for:
- Resource naming
- Tag creation
- Environment labels
- AWS naming rule enforcement

---

## 1️⃣ upper()

```hcl
upper("dev-server")

Output:

DEV-SERVER

2️⃣ lower()
lower("MyAppBucket")


Output:

myappbucket


Use Case: AWS S3 bucket names must be lowercase.

3️⃣ length()
length("saurabh")


Output:

8

4️⃣ replace()
replace("dev_server", "_", "-")


Output:

dev-server

5️⃣ split()
split("-", "dev-backend-api")


Output:

["dev", "backend", "api"]

6️⃣ join()
join("-", ["dev", "backend", "api"])


Output:

dev-backend-api

7️⃣ trimspace()
trimspace("   dev   ")


Output:

dev

8️⃣ format()
format("%s-server", "prod")


Output:

prod-server

9️⃣ substr()
substr("production", 0, 4)


Output:

prod

📦 COLLECTION FUNCTIONS

Collections:

List → ["dev", "prod"]

Map → { env = "dev", team = "backend" }

Set → toset(["a","b"])

Used when handling:

Multiple environments

Multiple ports

Multiple resources

Tag automation

1️⃣ length()
length(["dev", "stage", "prod"])


Output:

3

2️⃣ contains()
contains(["dev", "prod"], "prod")


Output:

true

3️⃣ merge()
merge(
  { team = "devops" },
  { env = "prod" }
)


Output:

{
  team = "devops"
  env  = "prod"
}

4️⃣ keys()
keys({ env = "dev", team = "backend" })


Output:

["env", "team"]

5️⃣ values()
values({ env = "dev", team = "backend" })


Output:

["dev", "backend"]

6️⃣ element()
element(["dev", "stage", "prod"], 1)


Output:

stage

7️⃣ distinct()
distinct(["dev", "prod", "dev"])


Output:

["dev", "prod"]

8️⃣ flatten()
flatten([["dev"], ["prod"], ["stage"]])


Output:

["dev", "prod", "stage"]

9️⃣ concat()
concat(["a"], ["b"])


Output:

["a", "b"]

🔍 lookup() Function (Important)
Problem

Direct map access causes error if key does not exist:

local.map["region"]   # ❌ Error if key missing

Solution

Use lookup() for safe access.

Syntax
lookup(map, key, default)


map → Map to search

key → Key to retrieve

default → Fallback value

Example 1 – Key Exists
lookup(
  { instance_type = "t2.micro" },
  "instance_type",
  "t3.small"
)


Output:

t2.micro

Example 2 – Key Missing
lookup(
  { instance_type = "t2.micro" },
  "region",
  "us-east-1"
)


Output:

us-east-1


✔ No error
✔ Safe fallback

🚀 Real DevOps Example

Dynamic instance type selection:

variable "instance_types" {
  default = {
    dev  = "t2.micro"
    prod = "t3.large"
  }
}

locals {
  selected_type = lookup(var.instance_types, var.env, "t2.micro")
}


If:

var.env = "prod"


Output:

t3.large


If:

var.env = "stage"


Output:

t2.micro (default fallback)

🎯 Important Interview Differences
lookup() vs Direct Map Access
Direct Access	lookup()
Error if key missing	Safe
No fallback	Requires default
Risky in production	Production-safe
merge() vs concat()
merge()	concat()
Works on maps	Works on lists
Combines key-value pairs	Combines list items
📌 Most Important Functions to Remember
upper()
lower()
replace()
split()
join()
format()
substr()
length()
merge()
lookup()
flatten()
contains()
distinct()
concat()