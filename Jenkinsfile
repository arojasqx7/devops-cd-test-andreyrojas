pipeline {
    agent none
    
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform-0.12.24"
    }

    environment {
        DOCKER_HUB_PASS   = credentials('DockerHubPass')
        ACCESS_KEY        = credentials('AWS_ACCESS_KEY_ID') 
        SECRET_KEY        = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Build Docker Images') {
            when {
               branch 'master'
            }
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
                        dir('backend') {
                            sh 'docker-compose up -d'
                        }
                    }
                }
            }
        }
        stage('Publish Images') {
            when {
               branch 'master'
            }
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
                            docker tag allthethings/spring-boot-realworld-example-app:latest arojasqx7/spring-boot-realworld-example-app:latest
                            docker push arojasqx7/mysql:latest
                            docker push arojasqx7/spring-boot-realworld-example-app:latest
                        '''
                    }
                }
            }
        }
        stage('Terraform Init') {
            when {
               branch 'master'
            }
            agent { 
                label 'aws-master'
            }
            steps {
                dir('terraform') {
                    sh "terraform init \
                        -get=true \
                        -input=false \
                        -force-copy \
                        -backend=true \
                        -backend-config 'access_key=$ACCESS_KEY' \
                        -backend-config 'bucket=terraform-state-infra-gl-test' \
                        -backend-config 'encrypt=true' \
                        -backend-config 'key=global/s3/terraform.tfstate' \
                        -backend-config 'region=us-east-1' \
                        -backend-config 'secret_key=$SECRET_KEY'" 
                }
            }
        }
        stage('Terraform Plan') {
            when {
               branch 'master'
            }
            agent { 
                label 'aws-master'
            }
            steps {
                dir('terraform') {
                    sh "terraform plan -var access_key=${ACCESS_KEY} -var secret_key=${SECRET_KEY}"
                }
            }
        }
        stage('Terraform Apply') {
            when {
               branch 'master'
            }
            agent { 
                label 'aws-master'
            }
            steps {
                dir('terraform') {
                    sh "terraform apply -var access_key=${ACCESS_KEY} -var secret_key=${SECRET_KEY} -input=false -auto-approve"
                }
            }
        }
        stage('Ansible Init Swarms') {
            agent { 
                label 'aws-master'
            }
            steps {
                dir('ansible') {
                    sh 'whoami'
                    sh 'ansible-playbook setup-docker-full-swarm.yml -u ec2-user -K'
                    sh 'whoami'
                }
            }
        }
    }
}