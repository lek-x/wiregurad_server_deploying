.PHONY: plan destroy apply validate key init init_env quick_start
name ?= dev


.PHONY: help
help: ## Show this help
	@printf "Usage:\n\tmake <target> %s %s %s %s %s %s\n" \
	  "[PIPENV=<prefix to run utilites, like: 'poetry run'>]" \
	  "[DEPLOYMENT_NAME=<new name for the project>]" \
	  "[ORIGINAL_DEPLOYMENT_NAME=<old name of the project>]" \
	  "[VERSION=<set this version>]"
	@printf "Targets:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	  | sort \
	  | awk 'BEGIN{FS=":"}{printf "  %-30s%s\n", $$1, substr($$2, match($$2, "## .*")+3)}'
	@printf '\nHints:\n' \
	  ; printf " - Create and/or source Python virtual environment in the first place, for example:\n    %s\n    %s\n" "python -m virtualenv ~/.local/lib/python3.9/github" "source ~/.local/lib/python3.9/github/bin/activate" \
	  ; echo " - Run 'make init' to setup local development environment" \
	  ; echo " - Run 'source ./env' to setup shell environment variables" \
	  ; echo " - It is recommended to run 'make validate' before commiting changes (or use 'make publish')" \
	  ; echo " - 'commitizen' is used to make commit and bump version"

init_env:
	poetry shell
	poetry install
	pre-commit install

space:
	terraform -chdir=terraform workspace new $(name)

select:
	terraform workspace select $(name)

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
