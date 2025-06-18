# DevOps Test Project 🚀

A comprehensive AWS infrastructure deployment project using Terraform, Ansible, and GitHub Actions for automated infrastructure management and application deployment.

## Table of Contents 📑
- [Overview 🌟](#overview-)
- [Architecture 🏗️](#architecture-)
- [Project Structure 📁](#project-structure-)
- [Workflows ⚙️](#workflows-)
- [Security 🔐](#security-)
- [Monitoring & Maintenance 📊](#monitoring--maintenance-)
- [Environment Variables 🔧](#environment-variables-)
- [Getting Started 🚀](#getting-started-)

## Overview 🌟

This project demonstrates a complete DevOps pipeline that:
- Provisions AWS infrastructure using Terraform
- Configures servers using Ansible
- Automates deployments using GitHub Actions
- Implements secure state management
- Provides easy content updates

## Architecture 🏗️

### Overall Project Architecture
```
                                   +----------------+
                                   |     GitHub     |
                                   |   Repository   |
                                   +-------+--------+
                                           |
                                           | Trigger
                                           v
                                   +----------------+
                                   |    GitHub      |
                                   |    Actions     |
                                   +--------+-------+
                                           |
                         +-----------------)-(------------------+
                         |                 |                   |
                         v                 v                   v
                  +-----------+    +-----------+        +-----------+
                  | Terraform |    |  Ansible  |        |    AWS    |
                  +-----+-----+    +-----+-----+        |  Services |
                        |                |              +-----+-----+
                        |                |                    |
                        |                +---------------+    |
                        |                                |    |
                        v                                v    v
                   +--------+                        +----------------+
                   |   S3   |                        |      EC2      |
                   +--------+                        +----------------+
```

### Infrastructure Deployment Flow
```
    GitHub         GitHub Actions      Terraform          AWS          Ansible
      |                 |                 |               |               |
      |  Push Code     |                 |               |               |
      |--------------->|                 |               |               |
      |                |    Initialize   |               |               |
      |                |--------------->|               |               |
      |                |                |    Create     |               |
      |                |                |-------------->|               |
      |                |                |               |  Configure    |
      |                |                |               |<--------------|
      |                |                |               |               |
      |   Status       |                |               |               |
      |<---------------|                |               |               |
      |                |                |               |               |
```

### Hello Update Flow
```
    GitHub         Workflow           S3          Terraform        EC2
      |               |               |               |             |
      |  Push         |               |               |             |
      |-------------->|               |               |             |
      |               |  List Buckets |               |             |
      |               |-------------->|               |             |
      |               |    Response   |               |             |
      |               |<--------------|               |             |
      |               |               |    Init       |             |
      |               |---------------------->|       |             |
      |               |               |               |   Update    |
      |               |               |               |------------>|
      |    Status     |               |               |             |
      |<--------------|               |               |             |
      |               |               |               |             |
```

### Bucket Discovery Process
```
    +------------------+
    |    Start Flow    |
    +--------+---------+
             |
     +-------v--------+
     | Check Manual   |
     |    Input       |
     +-------+--------+
             |
    +--------v--------+     +-----------------+
    |  List Buckets   |     |   Use Given     |
    |                 |     |    Name         |
    +--------+--------+     +-----------------+
             |                       ^
    +--------v--------+             |
    |    Filter      |             |
    | terraform-state|             |
    +--------+--------+             |
             |                      |
    +--------v--------+            |
    |   Get First    |------------->
    |     Match      |
    +----------------+
```

## Project Structure 📁

```plaintext
devops-test-project/
├── .github/
│   └── workflows/
│       ├── deploy.yml         # Main deployment workflow
│       ├── hello-update.yml   # Content update workflow
│       └── destroy.yml        # Infrastructure cleanup
├── ansible/
│   ├── hello.txt             # Dynamic content file
│   ├── inventory             # Dynamic inventory file
│   └── playbook.yml          # Server configuration
├── terraform/
│   ├── main.tf               # Main infrastructure definition
│   ├── variables.tf          # Variable declarations
│   ├── outputs.tf            # Output definitions
│   └── user_data.sh          # EC2 initialization script
└── README.md
```

### Key Components Description 🔍

#### Terraform Files
- `main.tf`: Defines AWS infrastructure including VPC, EC2, ALB
- `variables.tf`: Declares input variables for configuration
- `outputs.tf`: Specifies output values for reference
- `user_data.sh`: EC2 instance initialization script

#### Ansible Files
- `playbook.yml`: Server configuration and application deployment
- `hello.txt`: Dynamic content for web application
- `inventory`: Generated inventory file for Ansible

#### GitHub Workflows
- `deploy.yml`: Main infrastructure deployment pipeline
- `hello-update.yml`: Content update workflow
- `destroy.yml`: Clean infrastructure removal

## Workflows ⚙️

### Main Deployment Workflow
1. Sets up Terraform backend in S3
2. Initializes Terraform
3. Creates/updates infrastructure
4. Configures servers with Ansible

### Hello Update Workflow
The hello-update workflow uses a sophisticated bucket discovery mechanism:

```
    +---------------+
    |     Start     |
    +-------+-------+
            |
    +-------v-------+         +-----------------+
    |  Check Input  |-------->| Use Given Name  |
    +-------+-------+   Yes   +---------+-------+
            |                           |
            | No                        |
    +-------v-------+                   |
    | List Buckets  |                   |
    +-------+-------+                   |
            |                           |
    +-------v--------+                  |
    |     Filter     |                  |
    |terraform-state-|                  |
    +-------+--------+                  |
            |                           |
    +-------v-------+                   |
    | First Match   |                   |
    +-------+-------+                   |
            |                           |
    +-------v-------+                   |
    |  Use Backend  |<------------------+
    +-------+-------+
            |
    +-------v-------+
    |   Continue    |
    | Deployment    |
    +---------------+
```

## Security 🔐

### Infrastructure Security
- VPC with public/private subnets
- Security groups with minimal access
- SSH key-based authentication
- No password authentication allowed

### State Management Security
- Encrypted S3 bucket for state storage
- DynamoDB table for state locking
- Version control of state files
- Public access blocked on S3

### Application Security
- HTTPS support ready
- Regular security updates via user_data.sh
- Principle of least privilege
- Secure secret management via GitHub

## Monitoring & Maintenance 📊

### Available Metrics
- EC2 instance health
- Application load balancer metrics
- VPC flow logs
- CloudWatch metrics

### Health Checks
- Load balancer health checks
- Application endpoint monitoring
- System resource monitoring
- Log aggregation

## Environment Variables 🔧

Required environment variables for deployment:

```plaintext
AWS_ACCESS_KEY_ID        # AWS credentials
AWS_SECRET_ACCESS_KEY    # AWS credentials
SSH_PUBLIC_KEY           # EC2 access
SSH_PRIVATE_KEY          # Ansible access
```

### Terraform Variables
- `aws_region`: Target AWS region
- `instance_type`: EC2 instance size
- `key_name`: SSH key pair name
- `ssh_public_key`: Public key for EC2

## Getting Started 🚀

1. Fork/clone the repository
2. Configure GitHub secrets:
    - AWS credentials
    - SSH keys
3. Customize variables in terraform/variables.tf
4. Push to main branch to trigger deployment

### Manual Deployment
```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply

# Run Ansible playbook
ansible-playbook -i ansible/inventory ansible/playbook.yml
```

### Content Updates
1. Modify ansible/hello.txt
2. Commit and push
3. Workflow automatically updates content

## Contributing 🤝

1. Fork the repository
2. Create a feature branch
3. Submit a pull request