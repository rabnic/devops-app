pipeline {
    agent any

    environment {
        DOCKER_HUB_REPO = 'nichoscode/my_website'
        GIT_REPO = 'https://github.com/rabnic/devops-app.git'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'static', url: "${env.GIT_REPO}"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${env.DOCKER_HUB_REPO}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerHub') {
                        dockerImage.push()
                    }
                }
            }
        }

        stage('Deploy on AWS Ubuntu') {
            steps {
                script {
                    // Stop and remove any existing container
                    sh 'docker stop website || true'
                    sh 'docker rm website || true'

                    // Pull the Docker image from Docker Hub
                    sh "docker pull ${env.DOCKER_HUB_REPO}:${env.BUILD_ID}"

                    // Run the Docker container
                    sh "docker run -d --name website -p 80:80 ${env.DOCKER_HUB_REPO}:${env.BUILD_ID}"
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Clean workspace after the build
        }
    }
}
