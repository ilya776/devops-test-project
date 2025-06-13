# Test Task for Junior DevOps Engineer

This repository contains a solution for the test task.

## Project Structure

- `terraform/`: Contains Terraform code for creating AWS infrastructure.
- `ansible/`: Contains Ansible playbook for configuring the web server.
- `.github/workflows/`: Contains GitHub Actions workflow for CI/CD.
- `hello.txt`: Contains the content for the web page.

## How it works

The CI/CD pipeline is triggered on every push to the `main` branch. It performs the following steps:

1.  **Terraform Apply**: Creates or updates the AWS infrastructure (EC2 instance, Security Group).
2.  **Ansible Playbook**: Configures the EC2 instance as a web server and deploys the content from `hello.txt`.

Any changes to the `hello.txt` file will be automatically reflected on the web page after the pipeline completes.