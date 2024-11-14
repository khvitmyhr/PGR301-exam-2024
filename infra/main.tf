resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_sqs_exec_role_13"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_sqs_policy" {
  name   = "LambdaSQSPolicy_13"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Effect   = "Allow"
        Resource = aws_sqs_queue.my_sqs_queue.arn
      },
      {
         Action = "s3:PutObject"
        Effect = "Allow"
        Resource = "arn:aws:s3:::pgr301-couch-explorers/13/generated_images/*"
      },
      {
        # Legger til CloudWatch logging tillatelser
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        # Tillatelser for Bedrock
        Action = [
          "bedrock:InvokeService",
          "bedrock:InvokeModel"
        ]
        Effect = "Allow"
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = aws_iam_policy.lambda_sqs_policy.arn
}

#Opprette kø
resource "aws_sqs_queue" "my_sqs_queue" {
  name = "image_processing_queue_13"
}

# Create a zip file from the Python code (using the local lambda_function.py)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../lambda_sqs.py"
  output_path = "${path.module}/lambda_sqs.zip"
}

resource "aws_lambda_function" "image_processing_lambda" {
  function_name    = "image_processing_lambda_13"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "lambda_sqs.lambda_handler"  # Erstatt med riktig handler-funksjon fra Python-koden
  runtime          = "python3.8"
  filename         = data.archive_file.lambda_zip.output_path
  timeout          = 60
  
   environment {
    variables = {
      BUCKET_NAME = var.bucket_name  # Bruker bucket_name-variabelen fra variables.tf
    }
  }
}



resource "aws_lambda_event_source_mapping" "sqs_event_mapping" {
  event_source_arn = aws_sqs_queue.my_sqs_queue.arn
  function_name    = aws_lambda_function.image_processing_lambda.arn
  batch_size       = 10  # Tilpass batch-størrelsen etter behov
}


resource "aws_lambda_function_url" "comprehend_lambda_url" {
  function_name = aws_lambda_function.image_processing_lambda.function_name
  authorization_type = "NONE"  # Tilpass om du trenger autentisering
}

output "lambda_url" {
  value = aws_lambda_function_url.comprehend_lambda_url.function_url
}

output "sqs_queue_url" {
  value       =  aws_sqs_queue.my_sqs_queue.url
  description = "The URL of the SQS queue"
}