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
                            echo "Angular Image is ${env.ANGULAR_IMAGE}"
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
                        sh "docker tag ${env.ANGULAR_IMAGE} arojasqx7/${env.ANGULAR_IMAGE}"
                        sh "docker push arojasqx7/${env.ANGULAR_IMAGE}"
                    }
                }
                stage('Publish Backend Images') {
                    agent {
                        label 'aws-slave-1'
                    }
                    steps {
                        sh "docker login -u arojasqx7 -p $DOCKER_HUB_PASS"
                        sh '''
                            docker tag mysql:latest arojasqx7/mysql:latest
                            docker tag allthethings/spring-boot-realworld-example-app:latest arojasqx7/allthethings/spring-boot-realworld-example-app:latest
                            docker push arojasqx7/mysql:latest
                            docker push arojasqx7/allthethings/spring-boot-realworld-example-app:latest
                        '''
                    }
                }
            }
        }
    }
}