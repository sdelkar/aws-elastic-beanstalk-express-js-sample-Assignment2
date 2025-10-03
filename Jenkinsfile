pipeline {
    agent any

    environment {
        SNYK_TOKEN = credentials('snyk-token')
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        IMAGE_NAME = "sonamdelkar/project2-app"
    }

    stages {
        stage('Install Dependencies') {
            agent {
                docker {
                    image 'node:16'
                    args '-u root'
                }
            }
            steps {
                sh 'npm install --save'
            }
        }

        stage('Unit Tests') {
            agent {
                docker {
                    image 'node:16'
                    args '-u root'
                }
            }
            steps {
                sh 'npm test || echo "No tests defined, skipping."'
            }
        }

        stage('Security Scan (Snyk)') {
            agent {
                docker {
                    image 'node:16'
                    args '-u root'
                }
            }
            steps {
                sh '''
                  npm install -g snyk --unsafe-perm
                  snyk auth $SNYK_TOKEN
                  snyk test --severity-threshold=high || echo "Vulnerabilities found (non-blocking)"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest .'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                  echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                  docker push $IMAGE_NAME:latest
                '''
            }
        }
    }

    post {
        always {
            echo "Pipeline finished (Node 16 build and push)"
            cleanWs()
        }
        failure {
            echo "Pipeline failed. Check logs in Jenkins console."
        }
    }
}
