resource "aws_s3_bucket" "po-settings-module" {
  bucket = "po-settings-module"
  acl = "private"
  policy = "${file("s3Policy.json")}"

  versioning {
      enabled = true
  }
}

locals {
    s3_origin_id = "viet-cloudfront"
}

resource "aws_cloudfront_distribution" "viet-cloudfront" {
  enabled = true
  default_root_object = "ps-settings-module.js"
  price_class = "PriceClass_200"
  
  origin {
    domain_name = "${aws_s3_bucket.po-settings-module.bucket_domain_name}"
    origin_id   = "${local.s3_origin_id}"
  }
  
  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    compress = true
    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
