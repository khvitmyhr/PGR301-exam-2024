output "lambda_url" {
  value = aws_lambda_function_url.comprehend_lambda_url.function_url
  description = "The URL of the lambda function"
}

output "sqs_queue_url" {
  value       =  aws_sqs_queue.my_sqs_queue.url
  description = "The URL of the SQS queue"
}