resource "aws_sqs_queue" "purple-dlq" {
  name = "purple-dlq"
}


resource "aws_sqs_queue" "purple-queue" {
  name = "purple-queue"

  delay_seconds             = 90    ## 메시지 전송 후 대기 시간
  max_message_size          = 2048  ## 최대 메시지 크기
  message_retention_seconds = 86400 ## 메시지 보존 기간 1일 (60 * 60 * 24)
  receive_wait_time_seconds = 10    ## 메시지 수신 대기 시간

  ## 메시지 재전송 정책
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.purple-dlq.arn
    maxReceiveCount     = 5 ## 총 4번 시도 한 후 Dead Letter Queue에 쌓임
  })

  depends_on = [aws_sqs_queue.purple-dlq]
}
