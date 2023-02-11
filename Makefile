#FILES PATH
TMPDIR = "/tmp"
DEFF_MAKER = Makefolder/
FILE_NAME_CHECK = anyfilename #PLEASE CHANGE TO ENY WHEN USING FILE CHECKER
PATH_TO_FILE = $(DEFF_MAKER)$(FILE_NAME_CHECK) #ENABLE PUTH FILE CHECKING, USING OUR MAKEFOLDER
DEF_REQUIREMENTS = $(DEFF_MAKER)requirements.txt #USING REQUIERMENTS FOR OUR APP
GITIGNORE_STATIC = $(DEFF_MAKER)gitignorestatic #PATH TO static gitignore preperad just for your app
CUR_DIR = $(shell echo "${PWD}")
DOCKER_FILE_DIR := "dockerfiles"
YELLOW = "\033[1;33m" # Yellow text for echo
RED = "\033[0;31m" # RED text for echo
GREEN = "\033[0;32m" # Green text for echo
BLUE = "\033[0;34m" # Blue text for echo
STR_LENGTH := 64
_SUCCESS := "\033[32m[%s]\033[0m %s\n" # Green text for "printf"
_DANGER := "\033[31m[%s]\033[0m %s\n" # Red text for "printf"

#GET ADD VERSION
FILE := $(DEFF_MAKER)version.txt
VARIABLE := $(shell cat ${FILE})
DEFVERSION:= 1.0.0
VERSION := $(if $(VARIABLE),$(VARIABLE),$(DEFVERSION))
SCRIPT_VERSION:= $(DEFF_MAKER)version.sh
SCRIPT_GDD := $(DEFF_MAKER)gdd.sh
SCRIPT_NGINX := $(DEFF_MAKER)nginxgenerator.sh
SCRIPT_PM2 := $(DEFF_MAKER)pm2creator.sh
SCRIPT_GIT := $(DEFF_MAKER)gitrepo.sh
SCRIPT_DJ_SETTINGS := $(DEFF_MAKER)djsettings.sh
SCRIPT_DJ_URLS := $(DEFF_MAKER)djurls.sh
SCRIPT_DJ_INSTALLED_APPS := $(DEFF_MAKER)djapp.sh
ARGUMENT:= feature #can use major/feature/bug
NEWVERSION:=$(shell $(SCRIPT_VERSION) $(VERSION) $(ARGUMENT))
MESSAGE := app created, DEFAULT message
REMOTE_USER := root

#DEVELOP OR PRODUCT
DEV_MODE ?= 1
ifeq ($(DEV_MODE),1) #This is PRODUCT SETTINGS
APP_NAME := djappcontrol
START_APP_NAME := devcontrol
REMOTE_HOST := jsonsmile.com## OR other IP hostname ....
DOCKERFILE := ${DOCKER_FILE_DIR}/dev.Dockerfile
COMPOSEFILE := ${DOCKER_FILE_DIR}/dev.docker-compose.yml
DOCKER_APP_ENV := ${DOCKER_FILE_DIR}/.env.dev
DOCKER_CONTEXT := jsm_adalbert
CONTEXT_DESCRIPTION := develop
CONTEXT_HOST := host=ssh://adalbert@jsonsmile.com
FINAL_PORT := 8008
PORT_APP := 127.0.0.1:$(FINAL_PORT):8000
PORT_NGINX := 127.0.0.1:8888:80 
PORT_REDIS := 127.0.0.1:7379:6379
PORT_PSQ := 127.0.0.1:6543:5432
PORT_MEMCACHE := 127.0.0.1:22322:11211
DOMAIN := $(REMOTE_HOST)
else
APP_NAME := ipinfo #This is DEVELOP SETTINGS
START_APP_NAME := control
REMOTE_HOST := jsonsmile.com
DOCKERFILE := ${DOCKER_FILE_DIR}/prod.Dockerfile
COMPOSEFILE := ${DOCKER_FILE_DIR}/prod.docker-compose.yml
DOCKER_APP_ENV := ${DOCKER_FILE_DIR}/.env.prod
DOCKER_CONTEXT := jsm_root
CONTEXT_DESCRIPTION := production
CONTEXT_HOST := host=ssh://root@jsonsmile.com
FINAL_PORT := 4004
PORT_APP := 127.0.0.1:$(FINAL_PORT):8000
PORT_NGINX := 127.0.0.1:4444:80 
PORT_REDIS := 127.0.0.1:6379:6379
PORT_PSQ := 127.0.0.1:5432:5432
PORT_MEMCACHE := 127.0.0.1:21212:11211
DOMAIN := $(REMOTE_HOST)
endif

IMAGE_NAME := ${APP_NAME}
VENV := venv_$(APP_NAME)
GITSSH := git@github.com:bartaadalbert/$(APP_NAME).git
BRANCH := main
NGINX_CONF := $(DEFF_MAKER)$(APP_NAME).$(DOMAIN).conf
SUBDOMAIN := $(APP_NAME).$(DOMAIN)
SUBDOMAIN_CSRF := "https:\/\/$(APP_NAME).$(DOMAIN)"
SSH_SERVER := $(REMOTE_USER)@$(REMOTE_HOST)
PROXY_PASS := http:\/\/127.0.0.1:$(FINAL_PORT)
PM2_CONFIG := $(APP_NAME).config.js
APP_START := $(APP_NAME)/$(START_APP_NAME)
PATH_TO_PROJECT := $(APP_NAME)


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


checker: ## This clean checker.
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

file_check: ## CHECK IF FILE EXISTING in MAIN DEFF_MAKER
	@echo $(PATH_TO_FILE)
	@if [[ ! -f $(PATH_TO_FILE) ]]; then \
		printf $(_DANGER) "FILE NOT EXIST"; \
		exit 1; \
	else \
		printf $(_SUCCESS) "FILE EXIST"; \
	fi

preconfig: ## Add all needed files
	@if [[ -d $(APP_NAME) ]]; then\ 
		mkdir $(APP_NAME)/$(DOCKER_FILE_DIR);\
		touch $(APP_NAME)/$(DOCKERFILE);\
		touch $(APP_NAME)/$(COMPOSEFILE);\
		touch $(APP_NAME)/$(DOCKER_APP_ENV);\
	else\
		echo $(RED)"The app folder $(APP_NAME) not exist, cant add configs";\
	fi

	
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
	@if [ ! -f $(NGINX_CONF) ]; then\
		printf $(_DANGER) "The NGINX conf not exist, CREATE IT WITH: make create_nginx" ;\
		echo  $(YELLOW)"CREATE IT, AND CONTINUE?";\
		make checker;\
		make create_nginx;\
	fi
	@ssh $(SSH_SERVER) "apt install nginx"
	@scp $(NGINX_CONF) $(SSH_SERVER)":/etc/nginx/sites-available/"
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF)"
	@ssh $(SSH_SERVER) "ln -s /etc/nginx/sites-available/$(NGINX_CONF) /etc/nginx/sites-enabled/$(NGINX_CONF)"
	@ssh $(SSH_SERVER) "systemctl restart nginx"
	@ssh $(SSH_SERVER) "certbot --nginx -d $(SUBDOMAIN)"
	@ssh $(SSH_SERVER) "certbot renew --dry-run"

delete_ssl: checker## This will delete our ssl configs with nginx config
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-available/$(NGINX_CONF)"
	@ssh $(SSH_SERVER) "rm -f /etc/nginx/sites-enabled/$(NGINX_CONF)"
	@ssh $(SSH_SERVER) "rm -f /etc/letsencrypt/live/$(SUBDOMAIN)"
	@ssh $(SSH_SERVER) "systemctl restart nginx"


delete_nginx: checker ## Delete nginx config with conf name
	@rm -f $(NGINX_CONF)
	@echo $(YELLOW)The nginx config $(NGINX_CONF) was deleted

create_subdomain: checker## This will create a subdomain nam=app_name in our main domain
	$(shell $(SCRIPT_GDD) $(DOMAIN) $(APP_NAME))
	@echo $(BLUE)"subdomain was created $(APP_NAME).$(REMOTE_HOST)"

delete_subdomain: checker ## Delete the subdomain with this app_name
	$(shell $(SCRIPT_GDD) $(DOMAIN) $(APP_NAME) "DELETE")
	@echo $(YELLOW)"subdomain was deleted $(APP_NAME) on $(DOMAIN)"

context: ##Get available docker context s
	@docker context ls

images: ## Get all docker images
	-@docker images

ps: ## Get all runing docker containers
	-@docker ps -a 

change_context: context ## Change the docker context to other server
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
		source $(VENV)/bin/activate && django-admin startproject $(APP_NAME) && cd $(APP_NAME) && python3 manage.py startapp $(START_APP_NAME);\
		echo $(BLUE)"The app folder $(APP_NAME) created with startapp $(START_APP_NAME) successfully";\
	else\
		echo $(YELLOW)"The app folder $(APP_NAME) exist, nothing to do";\
	fi

	-@if [[ -d $(APP_NAME)/$(START_APP_NAME) ]]; then\
		$(SCRIPT_DJ_SETTINGS) $(APP_NAME) $(SUBDOMAIN_CSRF);\
		$(SCRIPT_DJ_URLS) $(APP_NAME) $(START_APP_NAME);\
		echo $(YELLOW)"The django settings was changed on app $(APP_NAME)";\
		make add_installed_apps $(APP_NAME) $(START_APP_NAME);\
	fi

add_installed_apps: checker ## Add in django settings installed apps new app
	$(shell $(SCRIPT_DJ_INSTALLED_APPS) $(START_APP_NAME) $(APP_NAME))
	@echo $(BLUE)"The app was added to installed app with name $(START_APP_NAME)"

app_settings: ## Change the existed app settings from settings dynamic
	@if [[ -d $(APP_NAME)/$(START_APP_NAME) ]]; then\
		$(SCRIPT_DJ_SETTINGS) $(APP_NAME) $(SUBDOMAIN_CSRF);\
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
	- @git commit -m "$(MESSAGE) with version $(VERSION)"
	- @git push -u origin $(BRANCH)

save_version: check_version ## Save a new version with increment param ARGUMENT=[1.0.0:major/feature/bug]
	$(shell echo $(NEWVERSION) > $(FILE))
	@echo $(GREEN)new version: $(NEWVERSION)

check_version: ## Get the actual version
	@echo $(BLUE)current version: $(VERSION)

reset_version: clean_version ## This will generate new file with DEFVERSION or any VERSION
	$(shell echo $(DEFVERSION) > $(FILE))
	@echo $(RED)reset version: $(DEFVERSION)

clean_version: checker## This will delete our version file, will set version to DEFVERSION 1.0.0 or what you give
	$(shell rm $(FILE))
	@echo $(RED)the version file was deleted from app directory

tag: ## This will tag our git vith the version 
	@git checkout $(BRANCH)
	@echo $(VERSION)
	@git tag $(VERSION)
	@git push --tags

create_pm2: checker## Add pm2 config js to app folder
	@if [[ ! -d $(APP_NAME) ]]; then\
		echo $(RED)"Cant add pm2 config if APP not created before";\
		exit 1;\
	fi
	$(shell $(SCRIPT_PM2) $(APP_NAME) "$(FINAL_PORT)")
	@cp $(CUR_DIR)/$(DEFF_MAKER)$(PM2_CONFIG) $(APP_NAME)
	@echo $(BLUE)The config js was created and copied to APP folder

bash_executable: ## Make all .sh file executable for our app
	@sudo chmod u+x $(DEFF_MAKER)*.sh
	@echo $(GREEN)the bash files was made executable

activate: ##Activate the venv
	-@source $(VENV)/bin/activate

check:
	-@echo $(SUBDOMAIN_CSRF)
	echo $(NGINX_CONF)
	echo $(MODIFY)
	$(eval MODIFY=qwerty)
	echo $(MODIFY)	

build: ## Build the docker image
	@echo $(CUR_DIR)
	@echo $(THIS_MAKEFILE)
	

