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
                echo "Cloning Repository from GitHub"
                git branch: 'main', credentialsId: 'github-credentials-id', url: 'git@github.com:JKooner1/DevOpsCW2.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                echo "Building Docker Image"
                sh 'docker build -t jagpalkooner/cw2-server:1.0 .'
            }
        }
        stage('Test Docker Image') {
            steps {
                echo "Testing Docker Image"
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
                echo "Deploying Docker Image to Kubernetes"
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
            echo "Pipeline execution completed."
        }
        success {
            echo "Pipeline executed successfully!"
        }
        failure {
            echo "Pipeline failed. Please check logs for details."
        }
    }
}
