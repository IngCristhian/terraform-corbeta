variable "bucket_names" {
    description = "Nombres de los buckets S3"
    type        = list(string)
}

resource "aws_s3_bucket" "buckets" {
    count         = length(var.bucket_names)
    bucket        = var.bucket_names[count.index]
    acl           = "private"  
}
