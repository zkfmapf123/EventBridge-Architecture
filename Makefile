vpc:
	cd common-infra/vpc && terraform plan

push:
	@git add .
	@git commit -m "apply"
	@git push origin master