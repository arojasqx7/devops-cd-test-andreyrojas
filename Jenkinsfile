pipeline {
    agent none

    environment {
    }
    stages {
        stage('Build Docker Images') {
            parallel {
                stage('Build Frontend') {
                    agent {
                        label 'aws-master'
                    }
                    steps {
                        script {
                            def frontendImage = docker.build("frontend-gl:$BUILD_NUMBER", "./frontend")
                        }
                    }
                }
                stage('Build Backend') {
                    agent {
                        label 'aws-slave-1'
                    }
                    steps {
                        sh 'cd backend && docker-compose up -d'
                    }
                }
            }
        }
    }
}