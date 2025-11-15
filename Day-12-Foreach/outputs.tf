output "subnet_ids" {
  value = {
    for k, v in aws_subnet.subnets : k => v.id
  }
}

output "bucket_names" {
  value = [for b in aws_s3_bucket.buckets : b.bucket]
}
