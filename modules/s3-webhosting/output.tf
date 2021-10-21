output "Domain-S3"{
  value = aws_s3_bucket.host.website_endpoint
}

output "arn-s3-host" {
  value = aws_s3_bucket.host.arn
}

output "name-s3-host" {
  value = aws_s3_bucket.host.bucket
}

output "cloudfront-id" {
  value = aws_cloudfront_distribution.s3_distribution.id
}
