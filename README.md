Title: Django Project Setup and Deployment Automation with Git Integration and Domain Configuration

Description: This project offers an advanced and comprehensive solution for setting up and deploying new or existing Django Python projects. It leverages the power of Makefile for automation and dynamically generates variables based on user configurations. Designed for Ubuntu-based Linux servers, the project can automatically create a new server on DigitalOcean if needed and install necessary requirements such as Docker, Docker Compose, and Docker CLI if not already available on the server.

The solution includes domain configuration with GoDaddy, ensuring proper A record setup. It also configures Nginx for serving the application, with multi-port support enabled through upstream Nginx configuration. Additionally, the project incorporates Git automation, with a GitHub Actions workflow file, Git webhook setup, and Git secrets management for secure and automated deployment.

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
