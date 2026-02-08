terraform {
    backend "s3" {
    bucket = "gusainsatatefile"
    key    = "test/terraform.tfstate"
    region = "ap-south-1"
    encrypt = true
    use_lockfile = true
    }
}