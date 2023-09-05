resource "aws_iam_role" "lambda_role" {
    name = "lambda_execution_role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action = "sts:AssumeRole",
            Effect = "Allow",
            Principal = {
                Service = "lambda.amazonaws.com"
            }
        }
    ]
    })
}

data "archive_file" "zip_the_python_code" {
    type = "zip"
    source_dir = "${path.module}/python/"
    source_path = "${path.module}/python/lambda.zip"
}

resource "aws_lambda_function" "lambda" {
    filename      = "${path.module}/python/lambda.zip"
    function_name = var.function_name
    role          = aws_iam_role.lambda_role.arn
    handler       = var.handler
    runtime       = "python3.8"  
    # Se carga el código del archivo.py
    # source_code_hash = filebase64sha256(var.source_code_filename)

}