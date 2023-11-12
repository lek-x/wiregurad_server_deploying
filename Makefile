.PHONY: plan destroy apply validate key init init_env
name ?= dev

init_env:
	poetry shell
	poetry install
	pre-commit install

space:
	terraform workspace new $(name)

select:
	terraform workspace select $(name)

init:
	terraform init

plan:
ifeq ($(DIGITALOCEAN_ACCESS_TOKEN),)
	@echo Warning: DIGITALOCEAN_ACCESS_TOKEN isn\'t defined;
	@read -rp 'DO token[hidden] ' DIGITALOCEAN_ACCESS_TOKEN;\
	terraform plan -var region=$(reg) -var image=$(img) -var size=$(size) -var do_token=$$DIGITALOCEAN_ACCESS_TOKEN
else
	terraform plan -var region=$(region) -var image=$(image) -var size=$(size)
endif

destroy:
ifeq ($(DIGITALOCEAN_ACCESS_TOKEN),)
	@echo Warning: DIGITALOCEAN_ACCESS_TOKEN isn\'t defined;
	@read -rp 'DO token[hidden] ' DIGITALOCEAN_ACCESS_TOKEN;\
	terraform destroy -auto-approve -var do_token=$$DIGITALOCEAN_ACCESS_TOKEN
endif
	terraform destroy -auto-approve

apply:
ifeq ($(DIGITALOCEAN_ACCESS_TOKEN),)
	@echo Warning: DIGITALOCEAN_ACCESS_TOKEN isn\'t defined;
	@read -rp 'DO token[hidden] ' DIGITALOCEAN_ACCESS_TOKEN;\
	terraform apply -auto-approve -var region=$(region) -var image=$(image) -var size=$(size) -var do_token=$$DIGITALOCEAN_ACCESS_TOKEN
else
	terraform apply -auto-approve -var region=$(region) -var image=$(image) -var size=$(size)
endif

validate:
	terraform validate

key:
	terraform output -raw private_key > my_ssh.key

clean:
	@rm -rf ./.terraform.lock.hcl ./.terraform
	@echo 'Cleaning done'
