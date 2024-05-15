############################# common #############################
vpc:
	cd common-infra/vpc && terraform apply

gateway: 
	cd common-infra/api-gateway && terraform apply

############################# service #############################
blue-deploy:
	cd service-blue && terraform init && terraform apply --auto-approve

green-deploy:
	cd service-green && terraform init && terraform apply --auto-approve

purple-deploy:
	cd service-purple && terraform init && terraform apply --auto-approve

## Service 배포
service-deploy:
	@make blue-deploy
	@make green-deploy
	@make purple-deploy

push:
	@git add .
	@git commit -m "apply"
	@git push origin master