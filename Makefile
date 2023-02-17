#FILES PATH
TMPDIR = "/tmp"
DEFF_MAKER = Makefolder/
CUR_DIR = $(shell echo "${PWD}")
# Yellow text for echo
YELLOW = "\033[1;33m"
# RED text for echo
RED = "\033[0;31m"
# Green text for echo
GREEN = "\033[0;32m"
# Blue text for echo
BLUE = "\033[0;34m"
STR_LENGTH := 121
# RAND_STR :=$(shell echo | uuidgen)$(shell openssl rand -base64 32)$(shell echo | uuidgen)
RAND_STR := $(shell LC_ALL=C tr -dc 'A-Za-z0-9!,-.+?:@=^_~' </dev/urandom | head -c $(STR_LENGTH))
# Green text for "printf"
_SUCCESS := "\033[32m[%s]\033[0m %s\n"
# Red text for "printf"
_DANGER := "\033[31m[%s]\033[0m %s\n" 

#PLEASE CHANGE TO ENY WHEN USING FILE CHECKER
FILE_NAME_CHECK = anyfilename

#ENABLE PUTH FILE CHECKING, USING OUR MAKEFOLDER
PATH_TO_FILE = $(DEFF_MAKER)$(FILE_NAME_CHECK)

#USING REQUIERMENTS FOR OUR APP
DEF_REQUIREMENTS = $(DEFF_MAKER)requirements.txt

#PATH TO static gitignore preperad just for your app
GITIGNORE_STATIC = $(DEFF_MAKER)git/gitignorestatic

#DOCKER FOLDER NAME, we will use it in app folder with settings file
DOCKER_FILE_DIR := dockerfiles


#GET FOLDERS VARIABLES
# VERSION FILE PATH
VERSION_FILE := $(DEFF_MAKER)version/version.txt

# GET THE VERSION FROM FILE
VARIABLE_VERSION := $(shell cat ${VERSION_FILE})

# DEFAULT VERSION
DEFVERSION := 1.0.0

VERSION := $(if $(VARIABLE_VERSION),$(VARIABLE_VERSION),$(DEFVERSION))
SCRIPT_VERSION:= $(DEFF_MAKER)version/version.sh
SCRIPT_GDD := $(DEFF_MAKER)godaddy/gdd.sh
SCRIPT_NGINX := $(DEFF_MAKER)nginx/nginxgenerator.sh
SCRIPT_DOCKER_NGINX := $(DEFF_MAKER)docker/docker_nginx_conf.sh
SCRIPT_PM2 := $(DEFF_MAKER)pm2/pm2creator.sh
SCRIPT_GIT := $(DEFF_MAKER)git/gitrepo.sh
SCRIPT_DJ_SETTINGS := $(DEFF_MAKER)django/djsettings.sh
SCRIPT_DJ_URLS := $(DEFF_MAKER)django/djurls.sh
SCRIPT_DJ_INSTALLED_APPS := $(DEFF_MAKER)django/djapp.sh

# DEFAULT FEATURE!!!! 1.0.0 can use major/feature/bug
VERSION_ARGUMENT := feature

NEWVERSION := $(shell $(SCRIPT_VERSION) $(VERSION) $(VERSION_ARGUMENT))

# DEFAULT MESSAGE FOR GIT INIT
GIT_MESSAGE := app created, DEFAULT GIT_message

#CAN BE ANY BUT IT NEED TO BE ROOT PRIVILAGE
REMOTE_USER := root
#########################################################################################!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#############################
# DEVELOP OR PRODUCT !!!!!! #
#############################
DEV_MODE ?= 1
#This is DEVELOP SETTINGS
ifeq ($(DEV_MODE),1)
#DJANGO startproject
APP_NAME := djappcontrol
#DJANGO startapp
START_APP_NAME := devcontrol
## OR other IP hostname ....
REMOTE_HOST := jsonsmile.com
#DEVELOP docker app config file
APP_DOCKERFILE := ${DOCKER_FILE_DIR}/dev.Dockerfile
#DEVELOP docker nginx config file
NGINX_DOCKERFILE := ${DOCKER_FILE_DIR}/dev.nginx.Dockerfile
#DEVELOP docker-compose yml file
APP_COMPOSEFILE := dev.docker-compose.yml
#DEVELOP ENV FILE
DOCKER_APP_ENV := ${DOCKER_FILE_DIR}/.env.dev
#DOCKER DB ENV
DOCKER_DB_ENV := ${DOCKER_FILE_DIR}/.env.dev.db
# CHANGE TO OTHER SERVER DOCKER DEPLOY
DOCKER_CONTEXT := jsm_adalbert
# CONTEXT DESCRIPTION 
CONTEXT_DESCRIPTION := develop
#CONTEXT HOST
CONTEXT_HOST := host=ssh://adalbert@jsonsmile.com
# APP RUNING ON THIS PORT AFTER ALL
FINAL_PORT := 8008
# -p 127.0.0.1:8008:8000, inside docker any port you can use, but you need to change for nginx to
#INSIDE PORT NOT RECOMMENDED TO CHANGE
PORT_APP := 127.0.0.1:$(FINAL_PORT):8000
# Nginx outside port from docker container
PORT_NGINX_FINAL := 8888
PORT_NGINX := 127.0.0.1:$(PORT_NGINX_FINAL):80
# Redis outside port with def inside port
PORT_REDIS_FINAL := 7379
PORT_REDIS := 127.0.0.1:$(PORT_REDIS_FINAL):6379
# Posgres outside and docker inside port
PORT_PSQ_FINAL := 6543
PORT_PSQ := 127.0.0.1:$(PORT_PSQ_FNAL):5432
#Memcache outside and inside port
PORT_MEMCACHE := 127.0.0.1:22322:11211
#THIS IS USEFULL IF YOU HAVE DOMAIN NAME AND SERVER IP
DOMAIN := $(REMOTE_HOST)
else
#This is PRODUCT SETTINGS
APP_NAME := ipinfo
START_APP_NAME := control
REMOTE_HOST := jsonsmile.com
APP_DOCKERFILE := ${DOCKER_FILE_DIR}/prod.Dockerfile
NGINX_DOCKERFILE := ${DOCKER_FILE_DIR}/prod.nginx.Dockerfile
APP_COMPOSEFILE := prod.docker-compose.yml
DOCKER_APP_ENV := ${DOCKER_FILE_DIR}/.env.prod
DOCKER_DB_ENV := ${DOCKER_FILE_DIR}/.env.prod.db
DOCKER_CONTEXT := jsm_root
CONTEXT_DESCRIPTION := production
CONTEXT_HOST := host=ssh://root@jsonsmile.com
FINAL_PORT := 4004
PORT_APP := 127.0.0.1:$(FINAL_PORT):8000
PORT_NGINX_FINAL := 4444
PORT_NGINX := 127.0.0.1:$(PORT_NGINX_FINAL):80
PORT_REDIS_FINAL := 6379
PORT_REDIS := 127.0.0.1:$(PORT_REDIS_FINAL):6379
PORT_PSQ_FINAL := 5432
PORT_PSQ := 127.0.0.1:$(PORT_PSQ_FINAL):5432
PORT_MEMCACHE := 127.0.0.1:21212:11211
DOMAIN := $(REMOTE_HOST)
endif

# WILL BE OUR APP DOCKER IMAGE NAME AND HOSTNAME
APP_IMAGE_NAME := app_$(APP_NAME)
DB_IMAGE_NAME := db_$(APP_NAME)
NGINX_IMAGE_NAME := nginx_$(APP_NAME)
REDIS_IMAGE_NAME := redis_$(APP_NAME)
MEMCACHE_IMAGE_NAME := memcache_$(APP_NAME)
NGINX_DOCKER_CONF := ${DOCKER_FILE_DIR}/$(APP_IMAGE_NAME).conf

#WILL BE THE VEMV NAME IN PROJECT CREATE FOLDER
VENV := venv_$(APP_NAME)
#GIT REPO SSH ACCESS PATH
GITSSH := git@github.com:bartaadalbert/$(APP_NAME).git
# GIT BRANCH DEFAULT SET FOR main
BRANCH := main
# THE NGINX CONF FILE WITH PATH
NGINX_CONF := $(DEFF_MAKER)nginx/$(APP_NAME).$(DOMAIN).conf
# THE NGINX CONF FILE
NGINX_CONF_FILE := $(APP_NAME).$(DOMAIN).conf
#FOR NGINX REVERSE PROXY 
PROXY_PASS := http:\/\/127.0.0.1:$(FINAL_PORT)
#SUBDOMAIN WITH PROJECT NAME WITH OUR DOMAIN NAME
SUBDOMAIN := $(APP_NAME).$(DOMAIN)
#EXCEPT THIS URL FROM CSRF CHECKING
SUBDOMAIN_CSRF := "https:\/\/$(APP_NAME).$(DOMAIN)"
#THE USER NEED TU BE ROOT PRIVILAGE 
SSH_SERVER := $(REMOTE_USER)@$(REMOTE_HOST)
# PM2 CONFIG IF YOU WANT TO RUN APP WITH PM2
PM2_CONFIG := $(APP_NAME).config.js
#DJANGO APP START PATH , NEED TO BE INSIDE DJANGO startproject
APP_START := $(APP_NAME)/$(START_APP_NAME)
# USEFULL IF YOUR PROJECT IS READY AND YOU WANT TO INSTALL WITH THIS MAKER, NOTHONG TO CHANGE IF LOGIC THIS
PATH_TO_PROJECT := $(APP_NAME)
DOCKER_NETWORK := $(APP_NAME)_net
#PLEASE USE CERFULLY, YU NEED TO CHANGE IF YOUR APP ANME HAS . LIKE api.control
SUBDOMAIN_NAME := $(APP_NAME)
GUNICORN_COMMAND := "gunicorn --bind 0.0.0.0:8000 --workers 2 --threads 2 --worker-tmp-dir /dev/shm $(APP_NAME).wsgi:application"
STATIC_FILES := /home/app/web/static/
MEDIA_FILES := /home/app/web/media/
DJANGO_ALLOWED_HOSTS := localhost 127.0.0.1 [::1] $(SUBDOMAIN)
SQL_ENGINE := django.db.backends.postgresql
SQL_DATABASE := $(APP_NAME)_db$(DEV_MODE)
SQL_USER := $(shell uuidgen | sed 's/[-]//g' | head -c 20;)
SQL_PASSWORD := $(shell LC_ALL=C tr -dc 'A-Za-z0-9!,-.+?:@=^_~' </dev/urandom | head -c 32)
# SQL_PASSWORD := $(shell openssl rand -base64 32)
SQL_HOST := $(DB_IMAGE_NAME)
SQL_PORT := $(PORT_PSQ_FINAL)
DATABASE := postgres
POSTGRES_USER := $(SQL_USER)
POSTGRES_PASSWORD := $(SQL_PASSWORD)
POSTGRES_DB := $(SQL_DATABASE)
DJANGO_SUPERUSER_USERNAME := $(shell uuidgen | sed 's/[-]//g' | head -c 20;)
DJANGO_SUPERUSER_PASSWORD := $(shell LC_ALL=C tr -dc 'A-Za-z0-9!,-.+?:@=^_~' </dev/urandom | head -c 32)
DJANGO_SUPERUSER_EMAIL := admin@$(DOMAIN)

define my_func
    $(eval $@_PROTOCOL = "https:"")
    $(eval $@_HOSTNAME = $(1))
    $(eval $@_PORT = $(2))
    echo "${$@_PROTOCOL}//${$@_HOSTNAME}:${$@_PORT}/"
endef


.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

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
# my-target:
#     @$(call my_func,"example.com",8000)

file_check: ## CHECK IF FILE EXISTING in MAIN DEFF_MAKER OR CHANGE THE PATH_TO_FILE VARIABLE
	@echo $(PATH_TO_FILE)
	@if [[ ! -f $(PATH_TO_FILE) ]]; then \
		printf $(_DANGER) "FILE NOT EXIST"; \
		exit 1; \
	else \
		printf $(_SUCCESS) "FILE EXIST"; \
	fi

preconfig: ## Add all needed files
	@if [[ -d $(APP_NAME) ]]; then \
		mkdir $(APP_NAME)/$(DOCKER_FILE_DIR);\
		cp $(DEFF_MAKER)docker/app_docker.stub $(APP_NAME)/$(APP_DOCKERFILE);\
		cp $(DEFF_MAKER)docker/nginx_docker.stub $(APP_NAME)/$(NGINX_DOCKERFILE);\
		cp $(DEFF_MAKER)docker/app_docker_compose.stub $(APP_NAME)/$(APP_COMPOSEFILE);\
		cp $(DEFF_MAKER)/docker/$(APP_IMAGE_NAME).conf $(APP_NAME)/$(NGINX_DOCKER_CONF);\
		cp $(DEFF_MAKER)/docker/start-server.sh $(APP_NAME)/$(DOCKER_FILE_DIR)/start-server.sh;\
		cp $(DEFF_MAKER)/docker/entripoint.sh $(APP_NAME)/$(DOCKER_FILE_DIR)/entripoint.sh;\
		echo DEBUG=$(DEV_MODE) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo SECRET_KEY=$(RAND_STR) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo DJANGO_ALLOWED_HOSTS=$(DJANGO_ALLOWED_HOSTS) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo SQL_ENGINE=$(SQL_ENGINE) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo SQL_DATABASE=$(SQL_DATABASE) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo SQL_USER=$(SQL_USER) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo SQL_PASSWORD=$(SQL_PASSWORD) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo SQL_HOST=$(SQL_HOST) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo SQL_PORT=$(SQL_PORT) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo DATABASE=$(DATABASE) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo DJANGO_SUPERUSER_USERNAME=$(DJANGO_SUPERUSER_USERNAME) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo DJANGO_SUPERUSER_PASSWORD=$(DJANGO_SUPERUSER_PASSWORD) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo DJANGO_SUPERUSER_EMAIL=$(DJANGO_SUPERUSER_EMAIL) >> $(APP_NAME)/$(DOCKER_APP_ENV);\
		echo POSTGRES_USER=$(POSTGRES_USER) >> $(APP_NAME)/$(DOCKER_DB_ENV);\
		echo POSTGRES_PASSWORD=$(POSTGRES_PASSWORD) >> $(APP_NAME)/$(DOCKER_DB_ENV);\
		echo POSTGRES_DB=$(POSTGRES_DB) >> $(APP_NAME)/$(DOCKER_DB_ENV);\
	else\
		echo $(RED)"The app folder $(APP_NAME) not exist, cant add configs";\
	fi

delete_preconfig: checker ## THSI WILL DELETE OUR DOCKER CONFIGURATION
	@echo $(RED)DELETEING DOCKER CONFIGS ...
	@rm -rf $(APP_NAME)/$(DOCKER_FILE_DIR)

.gitignore: ## Create gitignore dinamic
	@cp $(DEFF_MAKER)gitignorestatic .gitignore

create_repo: checker ## Cretae github repository private whitout template
	$(shell $(SCRIPT_GIT) $(APP_NAME))
	@echo $(BLUE)The repo was created with $(APP_NAME) name

delete_repo: checker## DELETE teh repo in github with user and name setted before
	$(shell $(SCRIPT_GIT) $(APP_NAME) "DELETE")
	@echo $(YELLOW)The repo was deleted with $(APP_NAME) name

create_nginx: ## Create an nginx config with proxypass and servername
	- $(shell $(SCRIPT_NGINX) $(SUBDOMAIN) "$(PROXY_PASS)")
	@echo $(BLUE)The nginx conf $(NGINX_CONF) was created successfully

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
	@ssh $(SSH_SERVER) "apt install nginx"
	@scp $(NGINX_CONF) $(SSH_SERVER)":/etc/nginx/sites-available/"
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "ln -s /etc/nginx/sites-available/$(NGINX_CONF_FILE) /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "systemctl restart nginx"
	@ssh $(SSH_SERVER) "certbot --nginx -d $(SUBDOMAIN)"
	@ssh $(SSH_SERVER) "certbot renew --dry-run"
	@make delete_nginx

delete_ssl: checker## This will delete our ssl configs with nginx config
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-available/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF_FILE)"
	@ssh $(SSH_SERVER) "rm -f /etc/letsencrypt/live/$(SUBDOMAIN)"
	@ssh $(SSH_SERVER) "systemctl restart nginx"


delete_nginx: checker ## Delete nginx config with conf name
	@rm -f $(NGINX_CONF)
	@echo $(YELLOW)The nginx config $(NGINX_CONF) was deleted

create_subdomain: checker## This will create a subdomain nam=app_name in our main domain, 4 param is a specific IP
	$(shell $(SCRIPT_GDD) $(DOMAIN) $(SUBDOMAIN_NAME))
	@echo $(BLUE)"subdomain was created $(SUBDOMAIN_NAME).$(REMOTE_HOST)"

delete_subdomain: checker ## Delete the subdomain with this app_name
	$(shell $(SCRIPT_GDD) $(DOMAIN) $(SUBDOMAIN_NAME) "DELETE")
	@echo $(YELLOW)"subdomain was deleted $(SUBDOMAIN_NAME) on $(DOMAIN)"

context: ##Get available docker context s
	@docker context ls

images: ## Get all docker images
	-@docker images

ps: ## Get all runing docker containers
	-@docker ps -a 

change_context: context ## Change the docker context to other server
	@echo $(BLUE)The docker context will change to $(DOCKER_CONTEXT)
	@make checker
	@docker context use $(DOCKER_CONTEXT)
	@echo $(YELLOW)The Docker context changed to $(DOCKER_CONTEXT)


create_context: checker## Create new server docker context
	@docker context create $(DOCKER_CONTEXT) --description $(CONTEXT_DESCRIPTION) --docker $(CONTEXT_HOST)
	@echo $(BLUE)The $(DOCKER_CONTEXT) was created at $(CONTEXT_HOST)


delete_context: checker ## Delete the context
	@docker context rm $(DOCKER_CONTEXT)
	@echo $(RED)The $(DOCKER_CONTEXT) was deleted

just_venv: checker ## Create just venv
	@rm -rf $(VENV)
	@python3 -m venv $(VENV)
	@read -p "APP exist with requirements.txt? [y/N] " ans && ans=$${ans:-N} ; \
	if [ $${ans} = y ] || [ $${ans} = Y ]; then \
		printf $(_SUCCESS) "YES" ; \
		if [ -d $(PATH_TO_PROJECT) ] && [ -f $(PATH_TO_PROJECT)/requirements.txt ]; then \
			cat $(PATH_TO_PROJECT)/requirements.txt >> $(DEF_REQUIREMENTS); \
		fi \
	else \
		printf $(_DANGER) "NO, app requirements not adding! " ; \
		if [[ -d $(APP_NAME) ]]; then \
			cat $(GITIGNORE_STATIC) >> .gitignore;\
			echo "$(APP_NAME)/$(APP_NAME)/__pycache__" >> .gitignore;\
			echo "$(APP_NAME)/$(START_APP_NAME)/__pycache__" >> .gitignore;\
			echo "$(APP_NAME)/$(APP_NAME)/settings.py" >> .gitignore;\
			echo "$(APP_NAME)/.env*" >> .gitignore;\
			echo "$(APP_NAME)/$(DOCKER_FILE_DIR)" >> .gitignore;\
			printf $(_DANGER) "TRY TO CREATE REQUIREMENTS?" ; \
			printf $(_DANGER) "TRY TO CREATE REQUIREMENTS?" ; \
			read -p "CREATE REQUIREMENTS? [y/N] " ans && ans=$${ans:-N} ; \
			if [ $${ans} = y ] || [ $${ans} = Y ]; then \
				printf $(_SUCCESS) "YES" ; \
				make create_requirements; \
				cat $(PATH_TO_PROJECT)/requirements.txt >> $(DEF_REQUIREMENTS); \
			fi \
		fi \
	fi
	@source $(VENV)/bin/activate && python3 -m pip install --upgrade pip && pip install --upgrade -r $(DEF_REQUIREMENTS)
	@echo $(BLUE)"The venv was created  with name $(VENV)"
	@make create_pm2
	@make create_network
	@make create_docker_nginx
	@make preconfig
	


create_requirements: ## USE path to project and create requirements txt for your python app
	@if [[ -d $(VENV) ]]; then\
		source $(VENV)/bin/activate && pip install pipreqs && pipreqs $(PATH_TO_PROJECT); \
		echo $(BLUE)"The requirements created successfully";\
	else\
		echo $(RED)"The VENV FOLDER NOT EXIST, CANT CREATE REQUIERMENTS";\
	fi


create_app: checker## Create venv with Django startproject, and delete venv if exist
	@rm -rf $(VENV)
	@python3 -m venv $(VENV)
	@source $(VENV)/bin/activate && python3 -m pip install --upgrade pip && pip install --upgrade -r $(DEF_REQUIREMENTS)
	@if [[ ! -d $(APP_NAME) ]]; then\
		cp $(GITIGNORE_STATIC) .gitignore;\
		echo "$(APP_NAME)/$(APP_NAME)/__pycache__" >> .gitignore;\
		echo "$(APP_NAME)/$(START_APP_NAME)/__pycache__" >> .gitignore;\
		echo "$(APP_NAME)/$(APP_NAME)/settings.py" >> .gitignore;\
		echo "$(APP_NAME)/.env*" >> .gitignore;\
		echo "$(APP_NAME)/$(DOCKER_FILE_DIR)" >> .gitignore;\
		source $(VENV)/bin/activate && django-admin startproject $(APP_NAME) && make create_pm2 && cd $(APP_NAME) && python3 manage.py startapp $(START_APP_NAME);\
		echo $(BLUE)"The app folder $(APP_NAME) created with startapp $(START_APP_NAME) successfully";\
	else\
		echo $(YELLOW)"The app folder $(APP_NAME) exist, nothing to do";\
	fi

	-@if [[ -d $(APP_NAME)/$(START_APP_NAME) ]]; then\
		$(SCRIPT_DJ_SETTINGS) $(APP_NAME) $(SUBDOMAIN_CSRF) $(REDIS_IMAGE_NAME);\
		$(SCRIPT_DJ_URLS) $(APP_NAME) $(START_APP_NAME);\
		echo $(YELLOW)"The django settings was changed on app $(APP_NAME)";\
		make add_installed_apps $(APP_NAME) $(START_APP_NAME);\
	fi
	@cp $(DEF_REQUIREMENTS) $(APP_NAME)/requirements.txt
	@make create_network
	@make create_docker_nginx
	@make preconfig

add_installed_apps: checker ## Add in django settings installed apps new app
	$(shell $(SCRIPT_DJ_INSTALLED_APPS) $(START_APP_NAME) $(APP_NAME))
	@echo $(BLUE)"The app was added to installed app with name $(START_APP_NAME)"

app_settings: ## Change the existed app settings from settings dynamic
	@if [[ -d $(APP_NAME)/$(START_APP_NAME) ]]; then\
		$(SCRIPT_DJ_SETTINGS) $(APP_NAME) $(SUBDOMAIN_CSRF) $(REDIS_IMAGE_NAME);\
		echo $(YELLOW)"The django settings was changed with $(APP_NAME)";\
		make add_installed_apps $(APP_NAME) $(START_APP_NAME);\
	fi

delete_app: checker## THIS will remove our startproject with all data
	@rm -rf $(APP_NAME)
	@rm -rf $(VENV)
	@echo $(YELLOW)"the app $(APP_NAME) was deleted and also the venv $(VENV)"

git_init: ## ADD ssh pub key to git, this will be simple for the future using, and create an app in github
	@if [ -z $(APP_NAME) ]; then\
		echo $(RED)"The app name not configured";\
		exit 1;\
	fi

	@if [ -z $(GITSSH) ]; then\
		echo $(RED)"The git ssh repo not configured";\
		exit 1;\
	fi

	- @make create_repo
	@git init
	@git add .
	@git commit -m "$(VERSION)"
	@git remote add origin $(GITSSH)
	@git branch -M $(BRANCH)	
	@git push -u origin $(BRANCH)

git_push: ##Git add . and commit and push to branch, add tag
	@make save_version
	@git status
	- @git add .
	- @git commit -m "$(GIT_MESSAGE) with version $(VERSION)"
	- @git push -u origin $(BRANCH)

git_tag: ## This will tag our git with actual version 
	@git checkout $(BRANCH)
	@echo $(VERSION)
	@git tag $(VERSION)
	@git push --tags

save_version: check_version ## Save a new version with increment param VERSION_ARGUMENT=[1.0.0:major/feature/bug]
	$(shell echo $(NEWVERSION) > $(VERSION_FILE))
	@echo $(GREEN)new version: $(NEWVERSION)

check_version: ## Get the actual version
	@echo $(BLUE)current version: $(VERSION)

reset_version: clean_version ## This will generate new file with DEFVERSION or any VERSION
	$(shell echo $(DEFVERSION) > $(VERSION_FILE))
	@echo $(RED)reset version: $(DEFVERSION)

clean_version: checker## This will delete our version file, will set version to DEFVERSION 1.0.0 or what you give
	$(shell rm -f $(VERSION_FILE))
	@echo $(RED)the version file was deleted from app directory


create_pm2: ## Add pm2 config js to app folder
	@if [[ ! -d $(APP_NAME) ]]; then\
		echo $(RED)"Cant add pm2 config if APP not created before";\
		exit 1;\
	fi
	$(shell $(SCRIPT_PM2) $(APP_NAME) "$(FINAL_PORT)")
	@cp $(CUR_DIR)/$(DEFF_MAKER)pm2/$(PM2_CONFIG) $(APP_NAME)
	@echo $(BLUE)The config js was created and copied to APP folder

bash_executable: ## Make all .sh file executable for our app
	@sudo chmod u+x $(DEFF_MAKER)django/*.sh
	@sudo chmod u+x $(DEFF_MAKER)docker/*.sh
	@sudo chmod u+x $(DEFF_MAKER)git/*.sh
	@sudo chmod u+x $(DEFF_MAKER)godaddy/*.sh
	@sudo chmod u+x $(DEFF_MAKER)nginx/*.sh
	@sudo chmod u+x $(DEFF_MAKER)pm2/*.sh
	@sudo chmod u+x $(DEFF_MAKER)version/*.sh
	@echo $(GREEN)the bash files was made executable

create_network: ## CREATE DOCKER NETWORK IF NOT EXIST
	@docker network ls
	@echo $(YELLOW)CHECK DOCKER NETWORK AND CREATE IT  WITH NAME $(DOCKER_NETWORK)
	@make checker
	@if [[ "$(shell docker network ls | grep "${DOCKER_NETWORK}")" == "" ]]; then \
    	docker network create "${DOCKER_NETWORK}"; \
		echo $(BLUE)"DOCKER NETWORK WAS CREATED WITH NAME $(DOCKER_NETWORK)"; \
	else \
		echo $(YELLOW)"DOCKER NETWORK WITH NAME $(DOCKER_NETWORK) EXIST"; \
	fi

delete_network: ## DELETE DOCKER NETWORK BY NAME
	@docker network ls
	@echo $(RED)DELETE DOCKER NETWORK WITH NAME $(DOCKER_NETWORK)
	@make checker
	@if [[ "$(shell docker network ls | grep "${DOCKER_NETWORK}")" != "" ]]; then \
    	docker network rm $(DOCKER_NETWORK); \
		echo $(RED)"DOCKER NETWORK WAS DELETED WITH NAME $(DOCKER_NETWORK)"; \
	else \
		echo $(YELLOW)"DOCKER NETWORK WITH NAME $(DOCKER_NETWORK) NOT EXIST, NOTHING TO DO"; \
	fi

create_docker_nginx: checker ## CREATE DOCKER NGINX CONF INSIDE DOCKER
	-@echo $(BLUE)CREATING DOCKER NGINX REVERSE PROXY HANDLE WITH HOSTNAME $(APP_IMAGE_NAME)
	@if [ ! -f $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf ]; then \
		$(SCRIPT_DOCKER_NGINX) $(APP_IMAGE_NAME); \
	else \
		echo $(YELLOW)"DOCKER NGINX REVERSE PROXY WITH NAME $(APP_IMAGE_NAME).conf EXIST"; \
	fi


delete_docker_nginx: ##DELETE THE NGINX REVERSE PROXY FOR THIS APP
	@echo $(RED)DELETE DOCKER NGINX CONF WITH NAME $(APP_IMAGE_NAME).conf
	@make checker
	@rm -rf $(DEFF_MAKER)docker/$(APP_IMAGE_NAME).conf
	@echo $(RED)DOCKER NGINX CONF WAS DELETED WITH NAME $(APP_IMAGE_NAME).conf;
	

check:
	-@echo $(SUBDOMAIN_CSRF)
	echo $(NGINX_CONF)
	echo $(MODIFY)
	$(eval MODIFY=qwerty)
	echo $(MODIFY)	

bb:
	@echo $(STR)
 


build: ## Build the docker image
	@echo $(CUR_DIR)
	@echo $(THIS_MAKEFILE)



	

