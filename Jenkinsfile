pipeline {
    agent none

    environment {
        DOCKER_HUB_PASS     = credentials('DockerHubPass')
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
                            env.ANGULAR_IMAGE = "frontend-gl:$BUILD_NUMBER"
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
        stage('Publish Images') {
            parallel {
                stage('Publish Frontend Image') {
                    agent {
                        label 'aws-master'
                    }
                    steps {
                        sh "docker login -u arojasqx7 -p $DOCKER_HUB_PASS"
                        sh "docker push ${env.ANGULAR_IMAGE}"
                    }
                }
            }
        }
    }
}