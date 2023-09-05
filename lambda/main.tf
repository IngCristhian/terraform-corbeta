resource "aws_lambda_function" "lambda" {
    function_name = var.function_name
    handler       = var.handler
    role          = aws_iam_role.lambda_role.arn
    runtime       = "python3.8"  
    # Se carga el código del archivo.py
    filename      = var.source_code_filename
    source_code_hash = filebase64sha256(var.source_code_filename)
}
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
