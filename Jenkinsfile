pipeline {
    agent none

    environment {
        AWS_ACCESS_KEY        = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_KEY        = credentials('AWS_SECRET_ACCESS_KEY')
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