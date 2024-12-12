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
                    /snap/bin/kubectl set image deployment/cw2-server cw2-server=jagpalkooner/cw2-server:1.0
                    '''
                }
            }
        }
    }
}
