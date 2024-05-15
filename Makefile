############################# common #############################
vpc:
	cd common-infra/vpc && terraform apply
queue:
	cd common-infra/sqs && terraform apply

############################# service Deploy #############################
blue-deploy:
	cd service-blue && terraform init && terraform apply --auto-approve

green-deploy:
	cd service-green && terraform init && terraform apply --auto-approve

purple-deploy:
	cd service-purple && terraform init && terraform apply --auto-approve

############################# service Destroy #############################
blue-destory:
	cd service-blue && terraform init && terraform destroy --auto-approve

green-destroy:
	cd service-green && terraform init && terraform destroy --auto-approve

purple-destroy:
	cd service-purple && terraform init && terraform destroy --auto-approve

## Service 배포
service-deploy:
	@make blue-deploy
	@make green-deploy
	@make purple-deploy

## Service 삭제
service-destroy:
	@make blue-destory
	@make green-destory
	@make purple-destory

push:
	@git add .
	@git commit -m "apply"
	@git push origin master