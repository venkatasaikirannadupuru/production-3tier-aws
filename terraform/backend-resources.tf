# ============================================================
# Terraform Remote State S3 Bucket
# ============================================================

resource "aws_s3_bucket" "terraform_state" {
  bucket_prefix = "production-3tier-terraform-state-"

  tags = {
    Name = "production-3tier-terraform-state"
  }
}

# ============================================================
# Enable Versioning
# ============================================================

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# ============================================================
# Block Public Access
# ============================================================

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
