base:
	cd common-infra/vpc && terraform apply --var-file="../../vars.tfvars"