# Files and directories
TMPDIR = "/tmp"
DEFF_MAKER = Makefolder/
CUR_DIR = $(shell echo "${PWD}")

# Text colors
YELLOW = "\033[1;33m"
RED = "\033[0;31m"
GREEN = "\033[0;32m"
BLUE = "\033[0;34m"

# Message colors
_SUCCESS := "\033[32m[%s]\033[0m %s\n"
_DANGER := "\033[31m[%s]\033[0m %s\n"

# String generation
STR_LENGTH := 121
RAND_STR := $(shell LC_ALL=C tr -dc 'A-Za-z0-9!,-.+?:@^_~' </dev/urandom | head -c $(STR_LENGTH))

# File and path settings
FILE_NAME_CHECK = anyfilename
PATH_TO_FILE = $(DEFF_MAKER)$(FILE_NAME_CHECK)
DEF_REQUIREMENTS = $(DEFF_MAKER)requirements.txt
GITIGNORE_STATIC = $(DEFF_MAKER)git/gitignorestatic
DOCKERIGNORE_STATIC = $(DEFF_MAKER)docker/dockerignorestatic
DOCKER_FILE_DIR := dockerfiles
VERSION_FILE := $(DEFF_MAKER)version/version.txt
STATIC_FILES := /home/myuser/web/static/
MEDIA_FILES := /home/myuser/web/media/
API_KEYS := $(DEFF_MAKER)api_keys.conf
DOCKER_APP_ENV_STAGING := ${DOCKER_FILE_DIR}/.env.stg
APP_DOCKERFILE_STAGING := ${DOCKER_FILE_DIR}/stg.Dockerfile

# Scripts
SCRIPT_VERSION:= $(DEFF_MAKER)version/version.sh
SCRIPT_GDD := $(DEFF_MAKER)godaddy/gdd.sh
SCRIPT_NGINX := $(DEFF_MAKER)nginx/nginxgenerator.sh
SCRIPT_NGINX_UPSTREAM := $(DEFF_MAKER)nginx/nginxgenerator_upstream.sh
SCRIPT_DOCKER_NGINX := $(DEFF_MAKER)docker/docker_nginx_conf.sh
SCRIPT_DOCKER_NGINX_UPSTREAM := $(DEFF_MAKER)docker/docker_nginx_conf_upstream.sh
SCRIPT_CHANGE_COMPOSE := $(DEFF_MAKER)docker/change_compose.sh
SCRIPT_INSTALL_DOCKER_DOCKER_COMPOSE := $(DEFF_MAKER)docker/install_docker_docker_compose.sh
SCRIPT_DOCKER_CONTAINER_INFO := $(DEFF_MAKER)docker/docker_container_info.sh
SCRIPT_PM2 := $(DEFF_MAKER)pm2/pm2creator.sh
SCRIPT_GIT := $(DEFF_MAKER)git/gitrepo.sh
SCRIPT_GITHUB_ACCESS := $(DEFF_MAKER)git/check_github_access.sh
SCRIPT_GIT_WEBHOOK_URL := $(DEFF_MAKER)git/create_webhook.sh
SCRIPT_GIT_ACTION_SETTINGS := $(DEFF_MAKER)git/set_secrets.sh
SCRIPT_GIT_IGNORE := $(DEFF_MAKER)git/gitignore_create.sh
SCRIPT_DJ_SETTINGS := $(DEFF_MAKER)django/djsettings.sh
SCRIPT_DJ_URLS := $(DEFF_MAKER)django/djurls.sh
SCRIPT_DJ_INSTALLED_APPS := $(DEFF_MAKER)django/djapp.sh
SCRIPT_DO_CLI := $(DEFF_MAKER)digitalocean/install_doctl.sh
SCRIPT_DO_DROPLET := $(DEFF_MAKER)digitalocean/create_droplet.sh
SCRIPT_DO_CHECK_CLI_INSTALL := $(DEFF_MAKER)digitalocean/check_install_dokctl.sh
SCRIPT_DO_DROPLET_DELETE := $(DEFF_MAKER)digitalocean/delete_droplet.sh
SCRIPT_DO_DOCKER_INSTALL := $(DEFF_MAKER)digitalocean/install_docker.sh

# Version settings
VARIABLE_VERSION := $(shell cat ${VERSION_FILE})
DEFVERSION := 1.0.0
VERSION := $(if $(VARIABLE_VERSION),$(VARIABLE_VERSION),$(DEFVERSION))
VERSION_ARGUMENT := feature
NEWVERSION := $(shell $(SCRIPT_VERSION) $(VERSION) $(VERSION_ARGUMENT))
LOCAL_BUILD := false

####################################
# !!!!!! DEVELOP OR PRODUCT !!!!!! #
####################################

DEV_MODE ?= 1
ifeq ($(DEV_MODE),1)
include makefile_dev.mk
else
include makefile_prod.mk
endif

####################################
# !!!!!! DEVELOP OR PRODUCT !!!!!! #
####################################

VENV := venv_$(APP_NAME)
SSH_SERVER := $(REMOTE_USER)@$(REMOTE_HOST)
SSH_SERVER_IP := $(REMOTE_USER)@$(IP)
APP_START := $(APP_NAME)/$(START_APP_NAME)
PATH_TO_PROJECT := $(APP_NAME)

#RSYNC SETTINGS
RSYNC = rsync
RSYNC_OPTIONS = -avP --exclude-from=$(DEFF_MAKER).rsyncignore
SOURCE_DIR = $(APP_NAME)
DESTINATION_DIR = "$(SSH_SERVER):$(RSYNC_DESTINATION_DIR)"

# IP and domain settings
IP := $(shell dig $(DOMAIN) +short @resolver1.opendns.com)
PROXY_PASS := http:\/\/127.0.0.1:$(PORT_NGINX_FINAL)
PROXY_PASS_UPSTREAM := http:\/\/127.0.0.1:$(FINAL_PORT)
PROXY_PASS_UPSTREAM_BACKUP := http:\/\/127.0.0.1:$(FINAL_PORT_STAGING)

ifeq ($(strip $(SUBDOMAIN_NAME)),)
    SUBDOMAIN = $(DOMAIN)
else
    SUBDOMAIN = $(SUBDOMAIN_NAME).$(DOMAIN)
endif

# Git settings
GIT_MESSAGE := app created, DEFAULT GIT_message
GITSSH := git@github.com:bartaadalbert/$(APP_NAME).git
GIT_WEBHOOK_URL := $(SUBDOMAIN_CSRF)/webhook

# Docker Image names
APP_IMAGE_NAME := app_$(APP_NAME)
DB_IMAGE_NAME := db_$(APP_NAME)
NGINX_IMAGE_NAME := nginx_$(APP_NAME)
REDIS_IMAGE_NAME := redis_$(APP_NAME)
MEMCACHE_IMAGE_NAME := memcache_$(APP_NAME)

# Docker nginx conf
NGINX_DOCKER_CONF := ${DOCKER_FILE_DIR}/nginx/$(APP_IMAGE_NAME).conf
NGINX_CONF := $(DEFF_MAKER)nginx/$(APP_NAME).$(DOMAIN).conf
NGINX_CONF_FILE := $(APP_NAME).$(DOMAIN).conf

# PM2 config js
PM2_CONFIG := $(APP_NAME).config.js

# SQL DB settings
SQL_ENGINE := django.db.backends.postgresql
SQL_DATABASE := $(APP_NAME)_db$(DEV_MODE)
SQL_USER := $(shell LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32)
SQL_PASSWORD := $(shell LC_ALL=C tr -dc 'A-Za-z0-9-._' </dev/urandom | head -c 32)
SQL_HOST := $(DB_IMAGE_NAME)
SQL_PORT := $(PORT_PSQ_FINAL)
DATABASE := postgres
POSTGRES_USER := $(SQL_USER)
POSTGRES_PASSWORD := $(SQL_PASSWORD)
POSTGRES_DB := $(SQL_DATABASE)

# Django settings
DJANGO_ALLOWED_HOSTS := localhost 127.0.0.1 [::1] $(SUBDOMAIN)
DJANGO_SUPERUSER_USERNAME := $(shell uuidgen | sed 's/[-]//g' | head -c 20;)
DJANGO_SUPERUSER_PASSWORD := $(shell LC_ALL=C tr -dc 'A-Za-z0-9!,-.+?:@^_~' </dev/urandom | head -c 32)
DJANGO_SUPERUSER_EMAIL := admin@$(DOMAIN)
TIME_ZONE := Europe/Budapest
LANGUAGE_CODE := en-us

#Docker settings
DOCKER_NETWORK := $(APP_NAME)_net
DOCKER_COMPOSE := docker-compose
DOCKER_COMPOSE_FILE := $(APP_NAME)/$(APP_COMPOSEFILE)
DOCKER_CHANGE_COMPOSE_FILE := $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).compose
COMPOSE_FILE_STUB_NAME := $(APP_MODE)_app_docker_compose.stub


# Image tag settings
NO_IMAGE_TAG := $(VERSION)
ifeq ($(NO_IMAGE_TAG),"")
APP_IMAGE_TAG := latest
else
APP_IMAGE_TAG := $(VERSION)
endif

#IMAGE SETTINGS
IMAGE := $(APP_IMAGE_NAME):$(APP_IMAGE_TAG)
APP_PORT_STAGING := $(FINAL_PORT_STAGING)
APP_MODE_STAGING := stg
APP_IMAGE_TAG_STAGING := latest

DEBUG := $(DEV_MODE)
SECRET_KEY := $(RAND_STR)
ENV_VARS_APP_ENV = DEBUG SECRET_KEY DJANGO_ALLOWED_HOSTS SQL_ENGINE SQL_DATABASE SQL_USER SQL_PASSWORD SQL_HOST SQL_PORT DATABASE DJANGO_SUPERUSER_USERNAME DJANGO_SUPERUSER_PASSWORD DJANGO_SUPERUSER_EMAIL
ENV_VARS_DOCKER_DB_ENV = POSTGRES_USER POSTGRES_PASSWORD POSTGRES_DB
ENV_VARS_DOTENV = APP_IMAGE_NAME APP_DOCKERFILE STATIC_FILES MEDIA_FILES PORT_APP DOCKER_APP_ENV DB_IMAGE_NAME REDIS_IMAGE_NAME DOCKER_DB_ENV PORT_PSQ PORT_REDIS NGINX_IMAGE_NAME PORT_NGINX DOCKER_NETWORK GUNICORN_COMMAND NGINX_DOCKERFILE TIME_ZONE LANGUAGE_CODE APP_IMAGE_TAG APP_DOCKERFILE_STAGING DOCKER_APP_ENV_STAGING PORT_APP_STAGING GUNICORN_COMMAND_STAGING
ENV_VARS_APP_ENV_STAGING = DEBUG APP_MODE_STAGING APP_PORT_STAGING APP_IMAGE_TAG_STAGING
FOLDERS = django docker git godaddy nginx pm2 version digitalocean

#GIT SECRETS
# CONVERT branch name to upper
BRANCH_UPPER := $(shell echo $(BRANCH) | tr a-z A-Z)
# Base secret variable names, by def the deploy key index 2 in array please if change it then be careful
SECRETS_VARS := SSH_USER REMOTE_HOST DEPLOY_KEY
GIT_SECRETS_VARS := $(addprefix $(BRANCH_UPPER)_,$(SECRETS_VARS))
# Set the values for the base secret variables
$(eval $(BRANCH_UPPER)_SSH_USER := $(REMOTE_USER))
$(eval $(BRANCH_UPPER)_REMOTE_HOST := $(REMOTE_HOST))
$(eval $(BRANCH_UPPER)_DEPLOY_KEY := $(SSH_GIT_KEY_FILE))
# Collect the values of the variables
GIT_VALUES_ARRAY :=
$(foreach VAR,$(GIT_SECRETS_VARS),$(eval GIT_VALUES_ARRAY += "$(value $(VAR))"))
SECRETS_STRING=$(shell echo $(GIT_SECRETS_VARS) | tr ' ' ',')
EXPECTED_VALUES_STRING=$(shell echo $(GIT_VALUES_ARRAY) | tr ' ' ',')



ARRAY = ""
define COLLECT_VARIABLES
  ARRAY += "$(1)=$(value $(1));"
endef

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@make bash_executable

.DEFAULT_GOAL := help


checker: ## This check the input enabel.
	@read -p "Are you sure? [y/N] " ans && ans=$${ans:-N} ; \
	if [ $${ans} = y ] || [ $${ans} = Y ]; then \
		printf $(_SUCCESS) "YES" ; \
	else \
		printf $(_DANGER) "NO, changes not made" ; \
		exit 1; \
	fi
	@echo 'Next steps...'


file_check: ## CHECK IF FILE EXISTING in MAIN DEFF_MAKER OR CHANGE THE PATH_TO_FILE VARIABLE
	@echo $(PATH_TO_FILE)
	@if [ ! -f $(PATH_TO_FILE) ]; then \
		printf $(_DANGER) "FILE NOT EXIST"; \
		exit 1; \
	else \
		printf $(_SUCCESS) "FILE EXIST"; \
	fi

check_ssh_access: ## Check your ssh connection to remote server
	@echo "Checking if the server is alive at $(DOMAIN) or $(IP)..."
	@if nc -z -v -w $(TIMEOUT) $(DOMAIN) 22 >/dev/null 2>&1 || nc -z -v -w $(TIMEOUT) $(IP) >/dev/null 2>&1; then \
		echo "Server is alive at $(IP)"; \
		echo "Checking SSH access for $(SSH_SERVER)..."; \
		if ssh -o ConnectTimeout=$(TIMEOUT) -o BatchMode=yes -q $(SSH_SERVER) exit 2>/dev/null; then \
			echo $(GREEN)"SSH access is available at $(SSH_SERVER)"; \
		elif [ ! -z "$(IP)" ] && ssh -o ConnectTimeout=$(TIMEOUT) -o BatchMode=yes -q $(SSH_SERVER_IP) exit 2>/dev/null; then \
			echo $(GREEN)"SSH access is available at $(SSH_SERVER_IP)"; \
			echo "Create A record for domain $(DOMAIN) with IP $(IP)"; \
			bash $(SCRIPT_GDD) $(DOMAIN) "@" $(IP); \
		else \
			echo $(RED)"SSH access is not available."; \
			read -p "Do you want to add your SSH key to the remote server? (y/n): " answer; \
			if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
				echo $(BLUE)"Adding SSH key to the remote server..."; \
				ssh-copy-id $(SSH_SERVER_IP); \
			else \
				echo $(YELLOW)"Skipping adding SSH key to the remote server."; \
			fi \
		fi \
	else \
		echo $(RED)"Server is not alive at $(SSH_SERVER) or $(IP)"; \
		read -p "Do you want to create a server? (y/n): " create_server_answer; \
		if [ "$$create_server_answer" = "y" ] || [ "$$create_server_answer" = "Y" ]; then \
			echo "Creating a server..."; \
			make check_ip; \
		else \
			echo $(YELLOW)"Skipping server creation."; \
		fi \
	fi


check_ip: ## Verify if the domain's IP address is accessible
	@if [ -z "$(IP)" ]; then \
		echo $(YELLOW)"IP is empty, try creating a server..."; \
		make install_doctl; \
		make create_droplet; \
		make check_ssh_access; \
	else \
		echo $(GREEN)"IP is not empty: $(IP). You are ready to proceed."; \
	fi
	

#NGINX DOMAIN CONFIG START

create_nginx: ## Create nginx server config with simple reverse proxy or upstream proxy
	@read -p "Do you want to create a simple nginx config or an upstream config with proxy pass backup? (simple/upstream): " NGINX_TYPE; \
	if [ "$$NGINX_TYPE" = "simple" ]; then \
		bash $(SCRIPT_NGINX) $(SUBDOMAIN) "$(PROXY_PASS)"; \
	elif [ "$$NGINX_TYPE" = "upstream" ]; then \
		bash $(SCRIPT_NGINX_UPSTREAM) $(SUBDOMAIN) "$(PROXY_PASS_UPSTREAM)" "$(PROXY_PASS_UPSTREAM_BACKUP)" $(APP_MODE)_$(APP_NAME); \
	else \
		printf $(YELLOW)"Invalid choice. Please choose either 'simple' or 'upstream'."; \
	fi

create_ssl: ## Create ssl with certbot for our nginx conf in our server
	@ssh $(SSH_SERVER) "ls -lah /etc/nginx/sites-enabled/"
	@echo $(YELLOW)IF you dont see $(NGINX_CONF_FILE) continue...
	@echo $(RED)DONT forget set GODADDY API keys...
	@make checker
	@if [ ! -f $(NGINX_CONF) ]; then \
		printf $(_DANGER)"The NGINX conf not exist, CREATE IT WITH: make create_nginx" ;\
		make create_nginx;\
	fi
	@make create_subdomain
	@echo $(YELLOW)Please wait ...
	@sleep 60
	@ssh $(SSH_SERVER) "apt install -y nginx"
	@scp $(NGINX_CONF) $(SSH_SERVER)":/etc/nginx/sites-available/"
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "ln -s /etc/nginx/sites-available/$(NGINX_CONF_FILE) /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "systemctl restart nginx"
	@ssl_exists=$$(ssh $(SSH_SERVER) "test -f /etc/letsencrypt/live/$(SUBDOMAIN)/fullchain.pem && echo 'yes' || echo 'no'") ;\
	if [ "$$ssl_exists" == "no" ]; then \
		ssh $(SSH_SERVER) "apt-get install -y certbot" ;\
		ssh $(SSH_SERVER) "certbot --nginx -d $(SUBDOMAIN)" ;\
		ssh $(SSH_SERVER) "certbot renew --dry-run" ;\
	else \
		echo $(YELLOW)"SSL certificate for $(SUBDOMAIN) already exists. Skipping SSL creation." ;\
	fi
	@make delete_nginx_conf


delete_ssl: ## This will delete our ssl configs with nginx config
	@read -p "Are you sure you want to delete SSL and Nginx configurations for $(NGINX_CONF_FILE)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-available/$(NGINX_CONF_FILE)"; \
		ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"; \
		ssh $(SSH_SERVER) "rm -f /etc/letsencrypt/live/$(SUBDOMAIN)"; \
		ssh $(SSH_SERVER) "systemctl restart nginx"; \
		echo $(RED)"SSL and Nginx configurations for $(NGINX_CONF_FILE) have been deleted."; \
	else \
		echo $(YELLOW)"Skipping deletion of SSL and Nginx configurations."; \
	fi


delete_nginx_conf: ## Delete nginx config with conf name
	@read -p "Are you sure you want to delete the Nginx configuration $(NGINX_CONF)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		rm -f $(NGINX_CONF); \
		echo $(RED)The Nginx configuration $(NGINX_CONF) was deleted; \
	else \
		echo $(YELLOW)"Skipping deletion of the Nginx configuration."; \
	fi

create_subdomain: ## This will create a subdomain nam=app_name in our main domain, 4 param is a specific IP
	@bash $(SCRIPT_GDD) $(DOMAIN) $(SUBDOMAIN_NAME) $(IP)

delete_subdomain: ## Delete the subdomain with this app_name
	@read -p "Are you sure you want to delete the subdomain $(SUBDOMAIN_NAME) on $(DOMAIN)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GDD) $(DOMAIN) $(SUBDOMAIN_NAME) "DELETE"; \
		echo $(RED)"Subdomain $(SUBDOMAIN_NAME) on $(DOMAIN) was deleted"; \
	else \
		echo $(YELLOW)"Skipping deletion of the subdomain."; \
	fi

#NGINX DOMAIN CONFIG END


#APP CONFIGURATION START

collect_app_env: ## USE CAREFULLY CREATE ENV FILES APPENV
	@echo "" > $(APP_NAME)/$(DOCKER_APP_ENV)
	$(foreach var,$(ENV_VARS_APP_ENV),echo "$(var)=$(value $(var))" >> $(APP_NAME)/$(DOCKER_APP_ENV);)

collect_db_env: ## USE CAREFULLY CREATE ENV FILES DBENV
	@echo "" > $(APP_NAME)/$(DOCKER_DB_ENV)
	$(foreach var,$(ENV_VARS_DOCKER_DB_ENV),echo "$(var)=$(value $(var))" >> $(APP_NAME)/$(DOCKER_DB_ENV);)

collect_dot_env: ## USE CAREFULLY CREATE ENV FILES DOTENV
	@echo "" > $(APP_NAME)/.env
	$(foreach var,$(ENV_VARS_DOTENV),echo "$(var)=$(value $(var))" >> $(APP_NAME)/.env;)

collect_app_env_stg: ## USE CAREFULLY CREATE ENV FILES APPENV STAGING
	@echo "" > $(APP_NAME)/$(DOCKER_APP_ENV_STAGING)
	$(foreach var,$(ENV_VARS_APP_ENV_STAGING),echo "$(var)=$(value $(var))" >> $(APP_NAME)/$(DOCKER_APP_ENV_STAGING);)

create_directories: ## Create necessary directories
	@echo $(BLUE)Creating directories...
	@mkdir -p $(APP_NAME)/$(DOCKER_FILE_DIR)/nginx
	@mkdir -p $(APP_NAME)/.github/workflows

copy_files: create_directories ## Copy necessary files
	@echo $(BLUE)Copying files...
	@cp $(DEFF_MAKER)docker/$(APP_MODE)_app_docker.stub $(APP_NAME)/$(APP_DOCKERFILE)
	@cp $(DEFF_MAKER)docker/$(APP_MODE)_stg_app_docker.stub $(APP_NAME)/$(APP_DOCKERFILE_STAGING)
	@cp $(DEFF_MAKER)docker/nginx_docker.stub $(APP_NAME)/$(NGINX_DOCKERFILE_NAME)
	@cp $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf $(APP_NAME)/$(NGINX_DOCKER_CONF)
	@cp $(DEFF_MAKER)docker/start-server.sh $(APP_NAME)/$(DOCKER_FILE_DIR)/start-server.sh
	@cp $(DEFF_MAKER)docker/entripoint.sh $(APP_NAME)/$(DOCKER_FILE_DIR)/entripoint.sh
	@cp $(DEFF_MAKER)git/deploy.yml $(APP_NAME)/.github/workflows/deploy.yml


preconfig: ## Add all needed files
	@if [ -d $(APP_NAME) ]; then \
		make copy_files; \
		make set_compose; \
		cp $(DOCKER_CHANGE_COMPOSE_FILE) $(APP_NAME)/$(APP_COMPOSEFILE);\
		make collect_app_env; \
		make collect_db_env; \
		make collect_app_env_stg; \
		make collect_dot_env; \
		cat $(DOCKERIGNORE_STATIC) >> $(PATH_TO_PROJECT)/.dockerignore; \
	else\
		echo $(RED)"The app folder $(APP_NAME) not exist, can't add configs"; \
	fi

delete_preconfig: ## THIS WILL DELETE OUR DOCKER CONFIGURATION
	@read -p "Are you sure you want to delete the Docker configs in $(APP_NAME)/$(DOCKER_FILE_DIR)? This action cannot be undone. [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo $(RED)"Deleting Docker configs..."; \
		rm -rf $(APP_NAME)/$(DOCKER_FILE_DIR); \
	else \
		echo $(YELLOW)"Operation canceled, Docker configs not deleted."; \
	fi



just_venv: checker ## Create just venv
	@rm -rf $(VENV)
	@python3 -m venv $(VENV)
	@read -p "APP exist with requirements.txt? [y/N] " ans && ans=$${ans:-N} ; \
	if [ $${ans} = y ] || [ $${ans} = Y ]; then \
		printf $(_SUCCESS) "YES" ; \
		if [ -d $(PATH_TO_PROJECT) ] && [ -f $(PATH_TO_PROJECT)/requirements.txt ]; then \
			printf "\n" >> $(DEF_REQUIREMENTS); \
			cat $(PATH_TO_PROJECT)/requirements.txt >> $(DEF_REQUIREMENTS); \
		fi \
	else \
		printf $(_DANGER) "NO, app requirements not adding! " ; \
		if [ -d $(APP_NAME) ]; then \
			cat $(GITIGNORE_STATIC) >> .gitignore;\
			make append_gitignore; \
			printf $(_DANGER) "TRY TO CREATE REQUIREMENTS?" ; \
			read -p "CREATE REQUIREMENTS? [y/N] " ans && ans=$${ans:-N} ; \
			if [ $${ans} = y ] || [ $${ans} = Y ]; then \
				printf $(_SUCCESS) "YES" ; \
				make create_requirements; \
				printf "\n" >> $(DEF_REQUIREMENTS); \
				cat $(PATH_TO_PROJECT)/requirements.txt >> $(DEF_REQUIREMENTS); \
			fi \
		fi \
	fi
	@source $(VENV)/bin/activate && python3 -m pip install --upgrade pip && pip install --upgrade -r $(DEF_REQUIREMENTS)
	@echo $(BLUE)"The venv was created with name $(VENV)"
	@make create_pm2
	@make create_network
	@make create_docker_nginx
	@make preconfig


create_requirements: ## USE path to project and create requirements txt for your python app
	@if [ -d $(VENV) ]; then \
		source $(VENV)/bin/activate && pip install pipreqs && pipreqs $(PATH_TO_PROJECT); \
		echo $(BLUE)"The requirements created successfully"; \
	else \
		echo $(RED)"The VENV FOLDER NOT EXIST, CANT CREATE REQUIREMENTS"; \
	fi

create_django_app: ## Create venv with Django startproject, and delete venv if exist
	@if [ ! -d $(APP_NAME) ]; then\
		read -p "Do you want to create the Django app $(APP_NAME) with startapp $(START_APP_NAME)? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			rm -rf $(VENV); \
			python3 -m venv $(VENV); \
			source $(VENV)/bin/activate && python3 -m pip install --upgrade pip && pip install --upgrade -r $(DEF_REQUIREMENTS); \
			cp $(GITIGNORE_STATIC) .gitignore; \
			make append_gitignore; \
			source $(VENV)/bin/activate && django-admin startproject $(APP_NAME) && make create_pm2 && cd $(APP_NAME) && python3 manage.py startapp $(START_APP_NAME);\
			cat $(DOCKERIGNORE_STATIC) >> $(PATH_TO_PROJECT)/.dockerignore; \
			echo $(BLUE)"The app folder $(APP_NAME) created with startapp $(START_APP_NAME) successfully";\
		fi;\
	else\
		echo $(YELLOW)"The app folder $(APP_NAME) exist, nothing to do";\
	fi

	-@if [ -d $(APP_NAME)/$(START_APP_NAME) ]; then \
		bash $(SCRIPT_DJ_SETTINGS) $(APP_NAME) $(SUBDOMAIN_CSRF) $(REDIS_IMAGE_NAME); \
		bash $(SCRIPT_DJ_URLS) $(APP_NAME) $(START_APP_NAME); \
		echo $(YELLOW)"The django settings was changed on app $(APP_NAME)"; \
		make add_installed_apps $(APP_NAME) $(START_APP_NAME); \
	fi
	@cp $(DEF_REQUIREMENTS) $(APP_NAME)/requirements.txt
	@make create_network
	@make create_docker_nginx
	@make preconfig


configure_docker: ## Configure Docker
	@make check_and_install_docker_docker_compose
	@make create_context
	@make check_ssh_access

deploy_github_actions: create_git_secrets ## Deploy the project to a remote server using GitHub Actions
	@echo $(GREEN)"Deploying the project with github actions, using rsync..."

deploy_git_webhook: create_gitwebhook  ## Deploy the project to a remote server using a Git webhook
	@echo $(GREEN)"Deploying the project with github webhooks, you need to setup on your server logic of your actions"

deploy_manual: ## Deploy the project locally using rsync
	@echo $(GREEN)"Deploying the project locally using rsync..."
	@make sync
	@echo $(GREEN)"Local deployment completed."
	@make rebuild

deploy: ## Deploy the project to a remote server, asking the deployment method
	@echo "Choose the deployment method:"
	@echo "1. GitHub Actions"
	@echo "2. Git Webhook"
	@echo "3. Manual Deployment (rsync)"
	@echo "4. None (default) no server configuration"
	@echo
	@read -p "Enter the number of your choice (1, 2, 3, or 4): " choice; \
	case $$choice in \
		1) make deploy_github_actions;; \
		2) make deploy_git_webhook;; \
		3) make deploy_manual;; \
		4) echo "No deployment method selected.";; \
		*) echo "Invalid choice. Please enter 1, 2, 3, or 4.";; \
	esac

new_django_project: save_version configure_docker change_context create_django_app deploy##  Set up a new Django project

existing_django_project: save_version configure_docker change_context just_venv deploy##  Configure an existing Django project


add_installed_apps: ## Add in django settings installed apps new app
	@read -p "Do you want to add $(START_APP_NAME) to Django's INSTALLED_APPS? (y/n): " proceed; \
	if [ "$$proceed" = "y" ] || [ "$$proceed" = "Y" ]; then \
		bash $(SCRIPT_DJ_INSTALLED_APPS) $(START_APP_NAME) $(APP_NAME); \
		echo $(BLUE)"The app was added to installed app with name $(START_APP_NAME)"; \
	else \
		echo $(YELLOW)"Skipping adding app to INSTALLED_APPS."; \
	fi

app_settings: ## Change the existed app settings from settings dynamic
	@if [ -d $(APP_NAME)/$(START_APP_NAME) ]; then\
		bash $(SCRIPT_DJ_SETTINGS) $(APP_NAME) $(SUBDOMAIN_CSRF) $(REDIS_IMAGE_NAME);\
		echo $(YELLOW)"The django settings was changed with $(APP_NAME)";\
		make add_installed_apps $(APP_NAME) $(START_APP_NAME);\
	fi

delete_app: ## THIS will remove our startproject with all data
	@read -p "Are you sure you want to delete the app $(APP_NAME) and the venv $(VENV)? This action cannot be undone. [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		rm -rf $(APP_NAME); \
		rm -rf $(VENV); \
		rm -rf .gitignore; \
		echo $(GREEN)"The app $(APP_NAME) was deleted and also the venv $(VENV)"; \
	else \
		echo $(YELLOW)"Operation canceled, app and venv not deleted."; \
	fi

create_pm2: ## Add pm2 config js to app folder
	@if [ ! -d $(APP_NAME) ]; then\
		echo $(RED)"Cant add pm2 config if APP not created before";\
		exit 1;\
	fi
	@if [ ! -f $(APP_NAME)/$(PM2_CONFIG) ]; then \
		bash $(SCRIPT_PM2) $(APP_NAME) "$(FINAL_PORT)"; \
		cp $(CUR_DIR)/$(DEFF_MAKER)pm2/$(PM2_CONFIG) $(APP_NAME); \
		echo $(BLUE)The config js was created and copied to APP folder; \
	else \
		read -p "The PM2 config file already exists. Do you want to overwrite it? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			bash $(SCRIPT_PM2) $(APP_NAME) "$(FINAL_PORT)"; \
			cp $(CUR_DIR)/$(DEFF_MAKER)pm2/$(PM2_CONFIG) $(APP_NAME); \
			echo $(BLUE)The config js was created and copied to APP folder; \
		else \
			echo $(YELLOW)"Operation canceled, PM2 config not overwritten."; \
		fi \
	fi

bash_executable: ## Make all .sh files executable for our app
	@for folder in $(FOLDERS); do \
		sudo chmod u+x $(DEFF_MAKER)$$folder/*.sh; \
	done
	@echo $(GREEN)the bash files were made executable

sync: ## We will use rsync to copy our project to remote server
	@read -p "Do you want to sync your project to the remote server? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		ssh $(SSH_SERVER) "mkdir -p $(RSYNC_DESTINATION_DIR)"; \
		$(RSYNC) $(RSYNC_OPTIONS) $(SOURCE_DIR) $(DESTINATION_DIR); \
		echo $(GREEN)"Project synced to the remote server."; \
	else \
		echo $(YELLOW)"Operation canceled, project not synced."; \
	fi


#APP CONFIGURATION END

# GIT COMMANDS START

create_gitignore: ## Create gitignore from already exist file in your app directory
	@echo "" > .gitignore
	@cp $(GITIGNORE_STATIC) .gitignore
	@read -p "Do you want to append to an existing .gitignore file or create a new one? (append/new): " GITIGNORE_OPTION; \
	if [ "$$GITIGNORE_OPTION" = "new" ]; then \
		make append_gitignore; \
	else \
		if [ -f "$(APP_NAME)/.gitignore" ]; then \
			tmp_file=$$(bash $(SCRIPT_GIT_IGNORE) $(APP_NAME)); \
			cat $$tmp_file >> .gitignore; \
			rm $$tmp_file; \
		fi \
	fi; \

append_gitignore: ## Append to gitignore some static 
	@echo "$(APP_NAME)/$(APP_NAME)/__pycache__" >> .gitignore
	@echo "$(APP_NAME)/$(START_APP_NAME)/__pycache__" >> .gitignore
	@echo "$(APP_NAME)/$(APP_NAME)/settings.py" >> .gitignore
	@echo "$(APP_NAME)/.env*" >> .gitignore
	@echo "$(APP_NAME)/$(DOCKER_FILE_DIR)" >> .gitignore

github_access: ## Check the github access from local or remote server
	@read -p "Do you want to use a local server or remote server? (local/remote): " server_choice; \
	case $$server_choice in \
		local) \
			bash $(SCRIPT_GITHUB_ACCESS) $$server_choice;; \
		remote) \
			bash $(SCRIPT_GITHUB_ACCESS) $$server_choice $SSH_SERVER;; \
		*) \
			echo "Invalid choice. Please enter 'local' or 'remote'.";; \
	esac

create_repo: ## Create a GitHub repository private without a template
	@repo_exists=$$(bash $(SCRIPT_GIT) $(APP_NAME) "CHECK"); \
	if [ "$$repo_exists" == "no" ]; then \
		read -p "Do you want to create a new GitHub repository with the name $(APP_NAME)? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			bash $(SCRIPT_GIT) $(APP_NAME); \
			echo $(BLUE)"The repo was created with the name $(APP_NAME)"; \
		else \
			echo $(YELLOW)"Operation canceled, repository not created."; \
		fi \
	else \
		echo $(RED)"A repository with the name $(APP_NAME) already exists. No changes were made."; \
	fi

delete_repo: ## Delete the GitHub repository with user and name set before
	@read -p "Do you want to delete the GitHub repository with the name $(APP_NAME)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GIT) $(APP_NAME) "DELETE"; \
		echo $(YELLOW)"The repo was deleted with the name $(APP_NAME)"; \
	else \
		echo $(YELLOW)"Operation canceled, repository not deleted."; \
	fi

create_gitwebhook: ## Create github webhook with django app url setted before
	@bash $(SCRIPT_GIT_WEBHOOK_URL) $(APP_NAME) $(GIT_WEBHOOK_URL)
	@echo $(BLUE)The webhook was created to reponame $(APP_NAME) with url $(GIT_WEBHOOK_URL)

delete_gitwebhook: ## DELETE github webhook
	@read -p "Are you sure you want to delete the webhook in repo $(APP_NAME) with URL $(GIT_WEBHOOK_URL)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GIT_WEBHOOK_URL) $(APP_NAME) $(GIT_WEBHOOK_URL) "DELETE"; \
		echo $(RED)"The webhook was deleted in repo $(APP_NAME) with url $(GIT_WEBHOOK_URL)"; \
	else \
		echo $(YELLOW)"Aborted delete git webhook."; \
	fi

git_init: ## ADD ssh pub key to git, this will be simple for the future using, and create an app in github
	$(eval GIT_EMAIL := $(shell git config --global user.email))
	$(eval GIT_NAME := $(shell git config --global user.name))
	@if [ -z "$(GIT_EMAIL)" ] || [ -z "$(GIT_NAME)" ]; then \
		echo $(RED)"Please set up your Git email and name using the following commands:"; \
		echo "git config --global user.email \"you@example.com\""; \
		echo "git config --global user.name \"Your Name\""; \
		exit 1; \
	fi
	@if [ -z $(APP_NAME) ]; then\
		echo $(RED)"The app name not configured";\
		exit 1;\
	fi

	@if [ -z $(GITSSH) ]; then\
		echo $(RED)"The git ssh repo not configured";\
		exit 1;\
	fi

	-@make create_repo
	@git init
	@git add .
	@git commit -m "$(VERSION)"
	@git remote add origin $(GITSSH)
	@git branch -M $(BRANCH)	
	@git push -u origin $(BRANCH)

git_push: ##Git add . and commit and push to branch, add tag
	@make save_version
	@git status
	@printf "Enter the files you want to add (separated by spaces, or press ENTER to add all): "; \
	read files && files=$${files:-.}; \
	git add $$files
	$(eval GIT_MESSAGE := $(shell read -p "Do you want to set a custom git message? (Current: $(GIT_MESSAGE)) " custom_message && echo $${custom_message:-$(GIT_MESSAGE)}))
	-@git commit -m "$(GIT_MESSAGE) with version $(VERSION)"
	@printf "Do you want to proceed with the push? (Y/n): "; \
	read proceed && proceed=$${proceed:-Y}; \
	if [ $${proceed} = Y ] || [ $${proceed} = y ]; then \
		git push -u origin $(BRANCH); \
	else \
		echo $(YELLOW)"Push skipped."; \
	fi

git_tag: ## This will tag our git with actual version 
	@git checkout $(BRANCH)
	@echo $(VERSION)
	@git tag $(VERSION)
	@git push --tags

create_git_secrets: ##This will create our secrets file and secrets for using github actions
	@echo "This will call our script set_secrets.sh for github"
	@read -p "Do you want to proceed? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_GIT_ACTION_SETTINGS) $(SECRETS_STRING) $(EXPECTED_VALUES_STRING) $(APP_NAME); \
	else \
		echo $(YELLOW)"Aborted github secrets."; \
	fi

# GIT COMMANDS END

#VERSION CONTROL START

save_version: check_version ## Save a new version with increment param VERSION_ARGUMENT=[1.0.0:major/feature/bug]
	@read -p "Do you want to save the new version $(NEWVERSION)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo $(NEWVERSION) > $(VERSION_FILE); \
		echo $(GREEN)"New version: $(NEWVERSION)"; \
	else \
		echo $(YELLOW)"Operation canceled, new version not saved."; \
	fi

check_version: ## Get the actual version
	@echo $(BLUE)current version: $(VERSION)

reset_version: clean_version ## This will generate new file with DEFVERSION or any VERSION
	@echo $(DEFVERSION) > $(VERSION_FILE)
	@echo $(RED)reset version: $(DEFVERSION)

clean_version: ## This will delete our version file, will set version to DEFVERSION 1.0.0 or what you give
	@read -p "Do you want to delete the version file? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		rm -f $(VERSION_FILE); \
		echo $(RED)"The version file was deleted from the app directory"; \
	else \
		echo $(YELLOW)"Skipping version file deletion."; \
	fi

#VERSION CONTROL END


#DOCKER COMMANDS START

check_and_install_docker_docker_compose: ## Check docker docker-compose and if not installed try install
	@command -v docker >/dev/null 2>&1 || { echo "Docker is not installed. Proceeding with installation..."; NEED_INSTALL=true; }
	@command -v docker-compose >/dev/null 2>&1 || { echo "Docker Compose is not installed. Proceeding with installation..."; NEED_INSTALL=true; }
	@if [ "$$NEED_INSTALL" = "true" ]; then \
		echo $(YELLOW)" Starting Docker and Docker Compose installation..."; \
		make install_docker_docker_compose; \
	else \
		echo $(GREEN)" Docker and Docker Compose are already installed."; \
	fi

install_docker_docker_compose: ## INSTALL DOCKER DOCKER-COMPOSE local or remote
	@bash $(SCRIPT_INSTALL_DOCKER_DOCKER_COMPOSE) $(IP)

set_compose: ## Enable set for the docker-compose file
	@read -p "Do you want to change the docker-compose file? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		echo $(BLUE)The compose file will change; \
		bash $(SCRIPT_CHANGE_COMPOSE) $(APP_IMAGE_NAME) $(DB_IMAGE_NAME) $(REDIS_IMAGE_NAME) $(NGINX_IMAGE_NAME) $(COMPOSE_FILE_STUB_NAME) ; \
		echo $(BLUE)The compose file was set; \
	else \
		echo $(YELLOW)"Skipping docker-compose file changes."; \
	fi

context: ##Get available docker context list
	-@docker context ls

images: ## Get all docker images
	-@docker images

ps: ## Get all runing docker containers
	-@docker ps -a 

choose_context:
	@read -p "Do you want to use Docker context locally or remotely (l/r)? " answer; \
	if [ "$$answer" = "l" ] || [ "$$answer" = "L" ]; then \
		echo $(YELLOW)"Setting Docker context to local..."; \
		make change_context DOCKER_CONTEXT=default; \
	elif [ "$$answer" = "r" ] || [ "$$answer" = "R" ]; then \
		echo $(YELLOW)"Setting Docker context to remote..."; \
		make change_context DOCKER_CONTEXT=$(DOCKER_CONTEXT); \
	else \
		echo $(YELLOW)"Skipping Docker context change."; \
	fi

change_context: context ## Change the docker context to other server
	@echo $(BLUE)The docker context will change to $(DOCKER_CONTEXT)
	@read -p "Do you want to change the Docker context to $(DOCKER_CONTEXT)? (y/n): " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		docker context use $(DOCKER_CONTEXT); \
		echo $(YELLOW)The Docker context changed to $(DOCKER_CONTEXT); \
	else \
		echo $(YELLOW)"Skipping Docker context change."; \
	fi


create_context: ## Create new server docker context
	@read -p "Do you want to create a new Docker context named $(DOCKER_CONTEXT) at $(CONTEXT_HOST)? (y/n): " proceed; \
	if [ "$$proceed" = "y" ] || [ "$$proceed" = "Y" ]; then \
		docker context create $(DOCKER_CONTEXT) --description $(CONTEXT_DESCRIPTION) --docker $(CONTEXT_HOST); \
		echo $(BLUE)"The $(DOCKER_CONTEXT) was created at $(CONTEXT_HOST)"; \
		make change_context; \
	else \
		echo $(YELLOW)"Skipping Docker context creation."; \
	fi

delete_context: ## Delete the context
	@if docker context inspect $(DOCKER_CONTEXT) >/dev/null 2>&1; then \
		read -p "Do you want to delete the Docker context $(DOCKER_CONTEXT)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			docker context rm $(DOCKER_CONTEXT); \
			echo $(RED)The $(DOCKER_CONTEXT) was deleted; \
		else \
			echo $(YELLOW)"Skipping Docker context deletion."; \
		fi \
	else \
		echo $(YELLOW)"Docker context $(DOCKER_CONTEXT) does not exist"; \
	fi

create_network: ## CREATE DOCKER NETWORK IF NOT EXIST
	@docker network ls
	@echo $(YELLOW)CHECK DOCKER NETWORK AND CREATE IT  WITH NAME $(DOCKER_NETWORK)
	@if [ "$(shell docker network ls | grep "${DOCKER_NETWORK}")" == "" ]; then \
		read -p "Do you want to create a Docker network with name $(DOCKER_NETWORK)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			docker network create "${DOCKER_NETWORK}"; \
			echo $(BLUE)"DOCKER NETWORK WAS CREATED WITH NAME $(DOCKER_NETWORK)"; \
		else \
			echo $(YELLOW)"Skipping Docker network creation."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NETWORK WITH NAME $(DOCKER_NETWORK) EXIST"; \
	fi

delete_network: ## DELETE DOCKER NETWORK BY NAME
	@docker network ls
	@echo $(RED)DELETE DOCKER NETWORK WITH NAME $(DOCKER_NETWORK)
	@if [ "$(shell docker network ls | grep "${DOCKER_NETWORK}")" != "" ]; then \
		read -p "Do you want to delete the Docker network with name $(DOCKER_NETWORK)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			docker network rm $(DOCKER_NETWORK); \
			echo $(RED)"DOCKER NETWORK WAS DELETED WITH NAME $(DOCKER_NETWORK)"; \
		else \
			echo $(YELLOW)"Skipping Docker network deletion."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NETWORK WITH NAME $(DOCKER_NETWORK) NOT EXIST, NOTHING TO DO"; \
	fi

create_docker_nginx:
	-@echo $(BLUE)CREATING DOCKER NGINX REVERSE PROXY HANDLE WITH HOSTNAME $(APP_IMAGE_NAME)
	@if [ ! -f $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf ]; then \
		read -p "Do you want to create a simple or upstream Docker Nginx configuration for $(APP_IMAGE_NAME)? (s/u): " answer; \
		if [ "$$answer" = "s" ] || [ "$$answer" = "S" ]; then \
			bash $(SCRIPT_DOCKER_NGINX) $(APP_IMAGE_NAME); \
		elif [ "$$answer" = "u" ] || [ "$$answer" = "U" ]; then \
			bash $(SCRIPT_DOCKER_NGINX_UPSTREAM) "$(APP_IMAGE_NAME):$(FINAL_PORT)" "stg_$(APP_IMAGE_NAME):$(FINAL_PORT_STAGING)"; \
		else \
			echo $(YELLOW)"Invalid input. Skipping Docker Nginx configuration creation."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NGINX REVERSE PROXY WITH NAME $(APP_IMAGE_NAME).conf EXIST"; \
	fi


delete_docker_nginx: ##DELETE THE NGINX REVERSE PROXY FOR THIS APP
	@echo $(RED)DELETE DOCKER NGINX CONF WITH NAME $(APP_IMAGE_NAME).conf
	@if [ -f $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf ]; then \
		read -p "Do you want to delete the Docker Nginx configuration for $(APP_IMAGE_NAME)? (y/n): " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			rm -rf $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf; \
			echo $(RED)DOCKER NGINX CONF WAS DELETED WITH NAME $(APP_IMAGE_NAME).conf; \
		else \
			echo $(YELLOW)"Skipping Docker Nginx configuration deletion."; \
		fi \
	else \
		echo $(YELLOW)"DOCKER NGINX REVERSE PROXY WITH NAME $(APP_IMAGE_NAME).conf DOES NOT EXIST"; \
	fi

stop: ## Stop all or c=<name> containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop $(c); \
	fi

rebuild: ## Rebuild all or c=<name> containers in foreground
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d --build $(c); \
	fi

rebuild_stg: ## Make rebuild with staging option
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d --build $(STAGING_APP_NAME); \
		if [ "$$($(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps -q $(STAGING_APP_NAME) | wc -l)" -eq 1 ]; then \
			echo $(GREEN)"Staging container is running! Building production image..."; \
			$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) build --no-cache $(APP_IMAGE_NAME); \
			echo $(GREEN)"Production image built successfully!"; \
		else \
			echo $(RED)"Staging container failed to start, please check logs..."; \
			$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop stg_$(APP_IMAGE_NAME); \
		fi; \
	fi

restart: ## Restart all or c=<name> containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) stop $(c); \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up $(c) -d; \
	fi

status: ## Show status of containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) ps; \
	fi

up: ## Start all or c=<name> containers in foreground
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up $(c); \
	fi

start: ## Start all or c=<name> containers in background
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) up -d $(c); \
	fi


logs: ## Show logs for all or c=<name> containers
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) logs --tail=100 -f $(c); \
	fi

clean:  ## Clean all data
	@if [ ! -f $(DOCKER_COMPOSE_FILE) ]; then \
		echo $(RED)"DOCKER_COMPOSE_FILE not found"; \
	else \
		read -p "Are you sure you want to clean all data? [y/N]: " answer; \
		if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
			$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILE) down; \
		else \
			echo "Aborted."; \
		fi \
	fi


migrate: ## Migrate Django
	@docker exec -it $(APP_IMAGE_NAME) python manage.py makemigrations --noinput
	@docker exec -it $(APP_IMAGE_NAME) python manage.py migrate --noinput

collectstatic: ## Get static folder to Docker app
	@docker exec -it $(APP_IMAGE_NAME) python manage.py collectstatic --no-input --clear

create_superuser: ## Create Django super user
	@docker exec -it $(APP_IMAGE_NAME) python3 manage.py createsuperuser --no-input

clean_volumes: ## Clean Docker created volumes by this app
	@docker volume rm -f $$(docker volume ls | grep $(APP_NAME))

app_command: ## Docker exec in app image commands
	@docker exec -it $(APP_IMAGE_NAME) $(dc)

container_info: change_context ## GET the info about countainer or all runned container ci=<name> containers or id
	@bash $(SCRIPT_DOCKER_CONTAINER_INFO) $(ci)

#DOCKER COMMANDS END


#DOCKER REGISTRY START

setup_registry: ## Set up a private Docker registry on the server
	@ssh $(SSH_SERVER) "docker run -d -p 5000:5000 --restart=always --name registry registry:2"

delete_registry: ## Delete registry in server
	@ssh $(SSH_SERVER) "docker rm -f registry"

push_image: ## Push image to remote Docker registry via SSH tunnel
	# Open SSH tunnel to remote host, with a socket name so that we can close it later
	@ssh -M -S $(SOCKET_NAME) -fnNT -L 5000:$(REMOTE_HOST):5000 $(SSH_SERVER)

	@if [ $$? -eq 0 ]; then \
		echo $(GREEN)"SSH tunnel established, we can push image"; \
		docker push localhost:5000/$(IMAGE); \
		ssh -S $(SOCKET_NAME) -O exit $(SSH_SERVER); \
		echo $(RED)"SSH tunnel closed"; \
	else \
		echo $(RED)"Failed to establish SSH tunnel"; \
	fi

pull_image: ## Pull image from remote Docker registry via SSH tunnel
	# Open SSH tunnel to remote host, with a socket name so that we can close it later
	@ssh -M -S $(SOCKET_NAME) -fnNT -L 5000:$(REMOTE_HOST):5000 $(SSH_SERVER)

	@if [ $$? -eq 0 ]; then \
		echo $(GREEN)"SSH tunnel established, we can pull image"; \
		docker pull localhost:5000/$(IMAGE); \
		ssh -S $(SOCKET_NAME) -O exit $(SSH_SERVER); \
		echo $(RED)"SSH tunnel closed"; \
	else \
		echo $(RED)"Failed to establish SSH tunnel"; \
	fi

#DOCKER REGISTRY END


#DIGITALOCEAN CLI START

install_doctl: ## Install DigitalOcean cli to local server
	@bash $(SCRIPT_DO_CHECK_CLI_INSTALL)

create_ssh_key: ## Create ssh key for server access with path
	@if [ -f "$(SSH_KEY_FILE)" ]; then \
		read -p "SSH key already exists. Do you want to create a new key? (y/n): " answer; \
	else \
		answer="y"; \
	fi; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		ssh-keygen -t rsa -b 4096 -C "$(SSH_KEY_COMMENT)" -f "$(SSH_KEY_FILE)"; \
	else \
		echo $(YELLOW)"Skipping SSH key creation."; \
	fi

add_ssh_key: ## Add the public key to the remote server's authorized_keys
	@ssh-copy-id -i $(SSH_KEY_FILE).pub $(REMOTE_USER)@$(IP)

create_droplet: create_ssh_key ## Create DigitalOcean droplet and get the ip address
	$(eval IP := $(shell $(SCRIPT_DO_DROPLET) $(SSH_KEY_NAME) $(SSH_KEY_FILE) $(APP_NAME))) 
	@echo $(GREEN)"Droplet created with IP: $(IP)"
	@bash $(SCRIPT_DO_DOCKER_INSTALL) $(IP)

delete_droplet: ## DELETE DigitalOcean droplet by droplet name
	@read -p "Are you sure you want to delete the droplet for $(APP_NAME)? [y/N]: " answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		bash $(SCRIPT_DO_DROPLET_DELETE) $(APP_NAME); \
	else \
		echo $(YELLOW)"Aborted deleting droplet."; \
	fi


#DIGITALOCEAN CLI END

