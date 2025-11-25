pipeline {
    agent {
        kubernetes {
            cloud 'kubernetes'
            label 'kaniko-builder' 
        }
    }
    environment {
        ECR_URL = "085710281301.dkr.ecr.us-west-2.amazonaws.com/django-app-repo" 
        APP_REPO_URL = "https://github.com/SerhiiMis/goit-devops-ci-cd.git"
        IMAGE_TAG = "build-${env.BUILD_ID}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'lesson-8-9', url: APP_REPO_URL
            }
        }
        stage('Build and Push Image') {
            steps {
                container('kaniko') {
                    sh 'aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ${ECR_URL}'
                    sh "/kaniko/executor --context=\$(pwd) --dockerfile=Dockerfile --destination=${ECR_URL}:${IMAGE_TAG}"
                }
            }
        }
        stage('Update GitOps Repo (Argo CD Source)') {
            steps {
                container('git') {
        
                    sh "git clone ${APP_REPO_URL} helm-repo"
                    
                    dir('helm-repo/lesson-8-9/charts/django-app') {
        
                        sh "sed -i 's/imageTag: .*/imageTag: ${IMAGE_TAG}/' values.yaml"
                        
                        sh "git config user.email 'jenkins@example.com'"
                        sh "git config user.name 'Jenkins CI'"
                        
                        sh "git add values.yaml"
                        sh "git commit -m 'CI: Deploying image ${IMAGE_TAG}'
                        sh "git push origin lesson-8-9" 
                    }
                }
            }
        }
    }
}