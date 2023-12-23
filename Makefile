.PHONY: plan destroy apply validate key init init_env quick_start
name ?= dev


.PHONY: help
help: ## Show this help
	@printf "Usage: make <target> %s %s %s %s %s %s\n" \
	;  echo "make init_env - create virtual environment" \
	;  echo "make space - create new terraform workspace" \
	;  echo "make select _your_ws_name - select terraform workspace" \
	;  echo "make init - init terraform" \
	;  echo "make plan region=eu image=rocky size=1 - plan terraform infra" \
	;  echo "make apply region=eu image=rocky size=1 - apply terraform infra" \
	;  echo "make destroy region=eu image=rocky size=1 - destroy terraform infra" \
	;  echo "make validate - validate terraform code" \
	;  echo "make key - save ssh key" \
	;  echo "make clean - remove all terraform state files" \
	;  echo "make quick_start - fast track to prepare env and init code"

init_env:
	poetry shell
	poetry install
	pre-commit install

space:
	terraform -chdir=terraform workspace new $(name)

select:
	terraform -chdir=terraform workspace select $(name)

init:
	cd terraform/ && terraform init

plan:
ifeq ($(DIGITALOCEAN_ACCESS_TOKEN),)
	@echo Warning: DIGITALOCEAN_ACCESS_TOKEN isn\'t defined;
	@read -rp 'DO token[hidden] ' DIGITALOCEAN_ACCESS_TOKEN;\
	terraform -chdir=terraform/ plan -var region=$(reg) -var image=$(img) -var size=$(size) -var do_token=$$DIGITALOCEAN_ACCESS_TOKEN
else
	terraform -chdir=terraform/ plan -var region=$(region) -var image=$(image) -var size=$(size)
endif

destroy:
ifeq ($(DIGITALOCEAN_ACCESS_TOKEN),)
	@echo Warning: DIGITALOCEAN_ACCESS_TOKEN isn\'t defined;
	@read -rp 'DO token[hidden] ' DIGITALOCEAN_ACCESS_TOKEN;\
	terraform -chdir=terraform/ destroy -auto-approve -var do_token=$$DIGITALOCEAN_ACCESS_TOKEN
endif
	terraform -chdir=terraform/ destroy -auto-approve

apply:
ifeq ($(DIGITALOCEAN_ACCESS_TOKEN),)
	@echo Warning: DIGITALOCEAN_ACCESS_TOKEN isn\'t defined;
	@read -rp 'DO token[hidden] ' DIGITALOCEAN_ACCESS_TOKEN;\
	terraform -chdir=terraform/ apply -auto-approve -var region=$(region) -var image=$(image) -var size=$(size) -var do_token=$$DIGITALOCEAN_ACCESS_TOKEN
else
	terraform  -chdir=terraform/ apply -auto-approve -var region=$(region) -var image=$(image) -var size=$(size)
endif

validate:
	terraform -chdir=terraform/ validate

key:
	terraform  -chdir=terraform/ output -raw private_key > my_ssh.key

clean:
	@rm -rf terraform/.terraform.lock.hcl terraform/.terraform terraform/terraform.tfstate.d
	@echo 'Cleaning done'

quick_start: init_env space init plan
