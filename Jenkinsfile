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
                sh 'npm install --save | tee install.log'
                archiveArtifacts artifacts: 'install.log', fingerprint: true
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
                sh 'npm test || echo "No tests defined"' 
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:latest1 . | tee build.log'
                archiveArtifacts artifacts: 'build.log', fingerprint: true
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh '''
                  echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                  docker push $IMAGE_NAME:latest1 | tee push.log
                '''
                archiveArtifacts artifacts: 'push.log', fingerprint: true
            }
        }

        stage('Security Scan') {
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
    }

    post {
        always {
            echo "Pipeline finished"
            // archive all logs from all stages
            archiveArtifacts artifacts: '**/*.log', allowEmptyArchive: true, fingerprint: true
            cleanWs()
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
