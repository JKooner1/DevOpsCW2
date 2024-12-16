pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        GITHUB_CREDENTIALS = credentials('github-credentials-id')
        K8S_SSH_CREDENTIALS = credentials('k8s-ssh-credentials-id')
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials-id', url: 'git@github.com:JKooner1/DevOpsCW2.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t jagpalkooner/cw2-server:1.0 .'
            }
        }
        stage('Test Docker Image') {
            steps {
                sh '''
                docker run -d --name test-container jagpalkooner/cw2-server:1.0
                docker ps | grep test-container
                docker rm -f test-container
                '''
            }
        }
        stage('Push to DockerHub') {
            steps {
                sh '''
                docker login -u $DOCKER_HUB_CREDENTIALS_USR -p $DOCKER_HUB_CREDENTIALS_PSW
                docker push jagpalkooner/cw2-server:1.0
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sshagent(credentials: ['k8s-ssh-credentials-id']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@44.221.203.136 "/usr/local/bin/kubectl set image deployment/cw2-server cw2-server=jagpalkooner/cw2-server:1.0"
                    '''
                }
            }
        }
    }
}
pipeline {
    agent any
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub-credentials-id')
        GITHUB_CREDENTIALS = credentials('github-credentials-id')
        K8S_SSH_CREDENTIALS = credentials('k8s-ssh-credentials-id')
        JAVA_ARGS = "-Xms512m -Xmx2048m" // Adjusting memory allocation for Jenkins processes
    }
    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials-id', url: 'git@github.com:JKooner1/DevOpsCW2.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo "Building Docker Image with updated code"
                sh 'docker build -t jagpalkooner/cw2-server:1.0 .'
            }
        }
        stage('Test Docker Image') {
            steps {
                echo "Testing the Docker Image"
                sh '''
                docker run -d --name test-container jagpalkooner/cw2-server:1.0
                docker ps | grep test-container
                docker rm -f test-container
                '''
            }
        }
        stage('Push to DockerHub') {
            steps {
                echo "Pushing Docker Image to DockerHub"
                sh '''
                docker login -u $DOCKER_HUB_CREDENTIALS_USR -p $DOCKER_HUB_CREDENTIALS_PSW
                docker push jagpalkooner/cw2-server:1.0
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                echo "Deploying updated Docker Image to Kubernetes"
                sshagent(credentials: ['k8s-ssh-credentials-id']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@44.221.203.136 "/usr/local/bin/kubectl set image deployment/cw2-server cw2-server=jagpalkooner/cw2-server:1.0"
                    '''
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline completed. Verifying deployment."
            sshagent(credentials: ['k8s-ssh-credentials-id']) {
                sh '''
                ssh -o StrictHostKeyChecking=no ubuntu@44.221.203.136 "curl $(minikube ip):<node-port>"
                '''
            }
        }
        failure {
            echo "Pipeline failed. Please review the logs."
        }
    }
}
