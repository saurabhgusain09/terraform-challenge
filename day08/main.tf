#creating s3 bucket 
resource "aws_s3_bucket" "gusainbucket1" {
  count = 2
  bucket = var.bucket_names[count.index]
  tags = var.tags
}

#convert the set into list 
# resource "aws_s3_bucket" "gusainbucket2" {
#   count = 2
#   bucket = tolist(var.buci_names)[count.index]
#   tags = var.tags
# }

resource "aws_s3_bucket" "gusainbucket23" {
  for_each = var.buci_names
  bucket = each.value
  tags = var.tags

  depends_on = [ aws_s3_bucket.gusainbucket1 ]
}