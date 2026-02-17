# 📘 Terraform Day 12 – Functions & Expressions

## 📌 Topics Covered
- Validation Block
- Regex
- can() Function
- toset()
- Numeric Functions (sum, max, min)
- Argument Expansion Operator (...)
- For Expression Filtering
- timestamp()

---

# 1️⃣ Validation Block

## 🔹 Why?
Wrong input = Wrong Infrastructure  
Validation input ko plan time pe check karta hai.

```hcl
variable "instance_type" {
  type = string

  validation {
    condition     = contains(["t2.micro", "t2.small"], var.instance_type)
    error_message = "Instance type must be t2.micro or t2.small."
  }
}

2️⃣ Regex

Pattern matching ke liye use hota hai.

Example: instance type must start with t2. or t3.

can(regex("^t[2-3]\\.", var.instance_type))

Pattern Breakdown:

^ → Start of string

t → Literal t

[2-3] → 2 or 3

. → Dot

3️⃣ can() Function

Error ko boolean me convert karta hai.
can(regex("^t[2-3]\\.", var.instance_type))
Match → true
Fail → false

4️⃣ toset()

List ko unique unordered collection me convert karta hai.
toset(["dev","prod","dev"])
6️⃣ Argument Expansion Operator (...)

List ko separate arguments me todta hai.

✅ Correct:

max(var.monthly_costs...)


Internally:

max(-50,100,75,200)

7️⃣ For Expression (Filtering)

Example:

variable "monthly_costs" {
  default = [-50,100,75,200]
}

Filter Positive Numbers
[
  for num in var.monthly_costs : num
  if num > 0
]


Output:

[100,75,200]

Sum Only Positive
sum([
  for num in var.monthly_costs : num
  if num > 0
])


Output:
375


---

# 8️⃣ timestamp()

Current UTC time return karta hai.

```hcl
timestamp()


Example Output:

2026-02-17T14:25:30Z


Use Cases:

Resource tagging

Unique naming

Deployment tracking

🎯 Key Learnings

Validation prevents wrong input

Regex validates patterns

can() prevents crash

toset() removes duplicates

sum() works with list

max() needs separate numbers

... expands list into arguments

For expression filters data

timestamp() returns current UTC time