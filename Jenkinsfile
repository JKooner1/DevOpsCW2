pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "jagpalkooner/cw2-server:1.0"
        HOST_PORT = "8081" // Change to an available port
        CONTAINER_PORT = "8080"
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Test Docker Container') {
            steps {
                sh '''
                docker run -d -p $HOST_PORT:$CONTAINER_PORT $DOCKER_IMAGE
                sleep 5
                curl http://localhost:$HOST_PORT
                docker stop $(docker ps -q)
                '''
            }
        }

        stage('Push Docker Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker push $DOCKER_IMAGE
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl set image deployment/cw2-server cw2-server=$DOCKER_IMAGE --record
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the logs for details.'
        }
    }
}
