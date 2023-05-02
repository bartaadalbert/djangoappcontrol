Title: Django Project Setup and Deployment Automation with Git Integration and Domain Configuration

Description: This project offers an advanced and comprehensive solution for setting up and deploying new or existing Django Python projects. It leverages the power of Makefile for automation and dynamically generates variables based on user configurations. Designed for Ubuntu-based Linux servers, the project can automatically create a new server on DigitalOcean if needed and install necessary requirements such as Docker, Docker Compose, and Docker CLI if not already available on the server.

The solution includes domain configuration with GoDaddy, ensuring proper A record setup. It also configures Nginx for serving the application, with multi-port support enabled through upstream Nginx configuration. Additionally, the project incorporates Git automation, with a GitHub Actions workflow file, Git webhook setup, and Git secrets management for secure and automated deployment.

## Overview

This Makefile automates the process of setting up and configuring new or existing Django projects, streamlining your development workflow. To use it, simply place the Makefile and the accompanying `Makefolder` directory next to your Django project folder or the desired location where you want to create a new Django project.

## Required Environment Variables

To use the Makefile functions, you need to set the following environment variables in the `Makefolder/api_keys.conf` file:

- **GIT_ACCESS_TOKEN**: Your GitHub personal access token.
- **GIT_OWNER**: Your GitHub username (e.g., bartaadalbert).
- **GODADDY_API_KEY**: Your GoDaddy API key.
- **GODADDY_API_SECRET**: Your GoDaddy API secret.
- **DO_API_KEY**: Your DigitalOcean API key.
- **DOCKER_API_KEY**: Your Docker API key.

Please make sure to replace the placeholders (e.g., `your_digitalocean_api_key`) with your actual API keys or access tokens in the `Makefolder/api_keys.conf` file.

Remember to never include your actual API keys or access tokens directly in your README or source code. Use environment variables or a separate configuration file that is not included in your version control system to store sensitive information.

## Usage

1. To initialize a GitHub repository, run:
make git_init

2. To create a new Django project, run:
make new_django_project


3. To configure an existing Django project, run:
make existing_django_project


The Makefile comes with preconfigured templates for Docker, Nginx, Git, DigitalOcean, Django, PM2, and version management. You can modify these templates to suit your requirements by editing the corresponding stub files in the `Makefolder` directory (e.g., `Makefolder/nginx`, `Makefolder/docker`, `Makefolder/git`, etc.).

By default, the project version starts at `1.0.0` and follows the `major/feature/bug` format. The Makefile automatically updates the feature number every time you run the `make save_version` command. Alternatively, you can specify a different version argument, such as `make save_version ARGUMENT=bug` to update the bug number instead.

Upon completion, your Django app will be dockerized, and you can modify the created requirements, Gitignore, and set up a new Django app by calling the `make add_installed_apps` command.

Enjoy a streamlined and automated development experience with this Makefile project!

Now you can focus on your Python code, while this Makefile takes care of setting up and deploying your project. It automatically configures your Django application with Nginx as a reverse proxy, SSL for secure HTTPS connections, and enables deployment to any server specified in your Makefile settings for development or production environments. This streamlines the process, allowing you to concentrate on writing and improving your application.



Key Features:

1. Automates Django project setup and deployment using Makefile.
2. Dynamic variables generation based on user configurations.
3. Compatible with Ubuntu-based Linux servers.
4. Automatic creation of a new DigitalOcean server if needed.
5. Automatic installation of Docker, Docker Compose, and Docker CLI if not already present.
6. Error checking during the setup and deployment process.
7. Dockerized Django application with Nginx reverse proxy, Redis, and PostgreSQL.
8. GoDaddy domain configuration with A record setup.
9. Nginx server configuration with multi-port upstream support.
10. Git automation with GitHub Actions workflow, Git webhook, and Git secrets management.

This project is an all-in-one solution for developers seeking a fast, reliable, and secure way to set up and deploy Django applications on Ubuntu-based Linux servers with Git integration and domain configuration. It also provides an option to automatically create a new server on DigitalOcean if needed.
