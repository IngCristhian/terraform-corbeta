provider "aws" {
    region = "us-east-1"  
}

module "s3_buckets" {
    source      = "./s3"
    bucket_names = ["logs-original-test", "logs-parseados-test"]  
}

module "lambda_function" {
    source              = "./lambda"
    function_name       = "lambda_parser_test"
    handler             = "lambda.handler"  
    source_code_filename = "./lambda/lambda.py"     
}
