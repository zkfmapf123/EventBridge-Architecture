output "queue" {
  value = {
    "blue" : aws_sqs_queue.blue-queue.url,
    "green" : aws_sqs_queue.green-queue.url,
    "purple" : aws_sqs_queue.purple-queue.url
  }
}
