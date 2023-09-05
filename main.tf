provider "aws" {
    region = "us-east-1"  
}

module "s3_buckets" {
    source      = "./s3"
    bucket_names = ["logs-original-test", "logs-parseados-test"]  
}

module "aws_lambda_function" {
    source = "./lambda"
    function_name = "lambda_corbeta_test"
}