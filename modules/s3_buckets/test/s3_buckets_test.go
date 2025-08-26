package test

import (
    "strings"
    "testing"

    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestS3BucketVersioning(t *testing.T) {
    t.Parallel()

    awsRegion := "us-east-1"
    environment := "test"
    bucketPrefix := "terratest-bucket"

    terraformOptions := &terraform.Options{
        TerraformDir: "../",
        Vars: map[string]interface{}{
            "environment":        environment,
            "aws_region":         awsRegion,
            "bucket_name_prefix": bucketPrefix,
            "enable_versioning":  true,
        },
    }

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)

    bucketName := terraform.Output(t, terraformOptions, "bucket_name")

    expectedPrefix := bucketPrefix + "-" + environment + "-" + awsRegion
    assert.True(t, strings.HasPrefix(bucketName, expectedPrefix))

    versioning := aws.GetS3BucketVersioning(t, awsRegion, bucketName)
    assert.Equal(t, "Enabled", versioning)
}

