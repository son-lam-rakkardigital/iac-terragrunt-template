# S3 bucket Terratest

This directory contains Terratest integration tests for the `s3_buckets` Terraform module.

## Prerequisites
- Go 1.20+
- Terraform installed and on your `PATH`
- AWS credentials with permissions to create and destroy S3 buckets

## Running the tests
From this directory, execute:

```bash
go test -v
```

The test provisions a temporary bucket in `us-east-1` with versioning enabled and automatically destroys it after execution.
