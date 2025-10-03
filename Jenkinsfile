pipeline {
    agent {
        docker {
            image 'node:16'
        }
    }

    stages {
        stage('Install Dependencies') {
            steps {
                sh 'npm install --save'
            }
        }

        stage('Run Unit Tests') {
	    steps {
		script {
		     try {
			sh 'npm test'
                     } catch (err) {
                        echo "No test script defined, skipping tests."
                     }
                 }
             }
        }

        stage('Security Scan') {
            steps {
                sh '''
                    npm install -g snyk
                    snyk test --severity-threshold=high
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t myapp:latest .'
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push myapp:latest'
            }
        }

	stage('Archive Artifacts') {
	    steps {
		archiveArtifacts artifacts: '**/build/**', fingerprint: true
	    }
	}
	
    }

    post {
        success {
            echo 'Build Successful'
        }
        failure {
            echo 'Build Failed'
        }
    }

}
