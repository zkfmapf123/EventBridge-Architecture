variable "ecr_name" {
  default = "internal-service"
}

resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name
}

resource "random_id" "version" {
  byte_length = 8

  keepers = {
    first = "${timestamp()}"
  }

  depends_on = [aws_ecr_repository.ecr]
}

resource "null_resource" "dockerizing" {

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin ${aws_ecr_repository.ecr.repository_url} && docker build -t ${aws_ecr_repository.ecr.repository_url}:${random_id.version.hex} ."
  }

  triggers = {
    version = "${timestamp()}"
  }

  depends_on = [aws_ecr_repository.ecr]
}

resource "null_resource" "push" {

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.ecr.repository_url}:${random_id.version.hex}"
  }

  depends_on = [null_resource.dockerizing]

  triggers = {
    version = "${timestamp()}"
  }
}

