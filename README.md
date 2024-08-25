Here's the updated `README.md` for setting up the Jenkins CI/CD Pipeline on an AWS Ubuntu distribution:

```markdown
# Jenkins CI/CD Pipeline with Docker and GitHub on AWS Ubuntu

This repository demonstrates a Jenkins pipeline implementation for achieving continuous integration and continuous deployment (CI/CD) using Docker and GitHub on an AWS Ubuntu server.

## Introduction

The CI/CD pipeline provided here automates the process of building, testing, and deploying your application whenever changes are pushed to the GitHub repository. Jenkins, an open-source automation server, orchestrates the pipeline, while Docker, a popular containerization platform, manages the deployment process.

## Prerequisites

Before setting up the pipeline, ensure that you have the following prerequisites:

1. An Amazon EC2 instance running Ubuntu with Jenkins, Git, and Docker installed.
2. A GitHub repository containing your application code and Dockerfile.

## Project Pipeline Flowchart

The CI/CD pipeline workflow is represented as follows:

![Jenkins CI/CD Pipeline with Docker and GitHub](https://github.com/harshartz/Jenkins-CI-CD-Pipeline-with-Docker-and-GitHub/assets/130890384/ab868d34-cfc4-4079-95b8-0b584622add5)

## Installation Instructions

### Installing Jenkins

To install Jenkins on an Ubuntu instance, follow these steps:

1. Update the package list and install Java:
    ```bash
    sudo apt update
    sudo apt install openjdk-11-jdk -y
    ```

2. Add the Jenkins repository and import the GPG key:
    ```bash
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
      /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    ```

3. Install Jenkins:
    ```bash
    sudo apt update
    sudo apt install jenkins -y
    ```

4. Start and enable the Jenkins service:
    ```bash
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    ```

5. Check the status of the Jenkins service:
    ```bash
    sudo systemctl status jenkins
    ```

### Installing Docker

To install Docker on Ubuntu, follow these steps:

1. Update the package list and install Docker:
    ```bash
    sudo apt update
    sudo apt install docker.io -y
    ```

2. Enable Docker to start on system boot:
    ```bash
    sudo systemctl enable docker
    ```

3. Start the Docker service:
    ```bash
    sudo systemctl start docker
    ```

### Installing Git

To install Git on Ubuntu, follow these steps:

1. Install Git:
    ```bash
    sudo apt update
    sudo apt install git -y
    ```

### Additional Configuration

To allow Jenkins to interact with Docker, execute the following command:

```bash
sudo usermod -aG docker jenkins
```

After executing the above command, restart Jenkins:

```bash
sudo systemctl restart jenkins
```

## Pipeline Overview

The Jenkins pipeline is triggered by a webhook configured on the GitHub repository. Whenever a developer pushes changes to the repository, the pipeline is initiated, and the following steps are executed:

1. The pipeline checks if there is a running Docker container for the application.
2. If a container is running, the pipeline copies the updated files from the Jenkins workspace to the running container, ensuring the changes are immediately reflected.
3. If no running container is found, the pipeline builds a new Docker image using the code from the GitHub repository and deploys it as a new container on the Amazon EC2 Ubuntu instance.
4. The deployed application can then be accessed on the target machine through the specified port.

## Getting Started

To get started with this CI/CD pipeline, follow these steps:

1. Set up Jenkins, Git, and Docker on your machine.
2. Provide Jenkins with a GitHub credential (token):
   - Generate a GitHub personal access token with the appropriate scopes (repo, webhook, etc.).
   - In Jenkins, go to "Manage Jenkins" > "Manage Credentials" > "Global credentials (unrestricted)".
   - Add a new credential of type "Secret text" or "Secret file" and enter your GitHub token.
   - Save the credential.
3. Configure Jenkins by accessing its web interface.
4. Create a new Jenkins job and configure it as follows:
   - Set the job type to "Freestyle Project".
   - Connect it to your GitHub repository (https://github.com/harshartz/Jenkins-project.git) and configure the webhook.
   - Select "GitHub hook trigger for GITScm polling" as the build trigger.
   - Add an "Execute Shell" build step to the pipeline and use the following code:
   ```bash
   #!/bin/bash

   container_id=$(docker ps --filter "status=running" --format "{{.ID}}")

   if [ -n "$container_id" ]; then
       docker cp /var/lib/jenkins/workspace/devops-project/. "$container_id":/usr/share/nginx/html
   else
       docker build -t server /var/lib/jenkins/workspace/devops-project
       docker run -d -p 9090:80 server
   fi
   ```
Run the Jenkins job and verify the successful execution of the pipeline.

![Screenshot (11)](https://github.com/harshartz/Jenkins-project/assets/130890384/1ffd9035-951d-4ced-89a2-84b6c5c7f6e0)

*Application is running, and whenever a developer commits changes to the GitHub repository, it will automatically get deployed to the application.*
```

### Summary of Changes:
- **Package Management**: Replaced `yum` with `apt` to reflect Ubuntu's package management system.
- **Jenkins and Docker Installation**: Updated commands to match the Ubuntu environment.
- **Java Installation**: Provided instructions for installing Java using `apt`.
