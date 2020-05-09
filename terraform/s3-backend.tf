terraform {
    backend "s3" {
        bucket         = "terraform-up-and-running-state"
        key            = "workspaces-example/terraform.tfstate"
        region         = "us-east-2"
        dynamodb_table = "terraform-up-and-running-locks"
        encrypt        = true
    }
}