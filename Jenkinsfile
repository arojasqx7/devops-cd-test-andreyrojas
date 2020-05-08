pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY        = credentials('AWS_ACCESS_KEY_ID') 
        AWS_SECRET_KEY        = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages {
        stage('Build Docker Images') {
            parallel {
                stage('Build Frontend') {
                    steps {
                        script {
                            def frontendImage = docker.build("frontend-gl:$BUILD_NUMBER", "./frontend")
                        }
                    }
                }
                stage('Build Backend') {
                    steps {
                        sh 'cd backend && docker-compose up -d'
                    }
                }
            }
        }
    }
}