.PHONY: plan destroy apply validate key init

init:
	terraform init

plan:
	terraform plan -var region=$(reg) -var image=$(img)

destroy:
	terraform destroy -auto-approve
apply:
	terraform apply -auto-approve -var region=$(reg) -var image=$(img)

validate:
	terraform validate

key:
	terraform output -raw private_key > my_ssh.key
