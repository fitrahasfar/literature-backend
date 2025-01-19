def remote = 'remote'
def server = 'ftrh4551@103.127.139.214'
def directory = 'literature-backend'
def branch = 'main'
def image = 'fitrah4551/dumbflix:1.0.0'
pipeline {
    agent any
    stages {
        stage('Pull new code') {
            steps {
                sshagent([remote]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd 
                    cd ${directory}
                    git pull origin ${branch}
                    exit
                    EOF"""
                }
            }
        }
        stage('Build') {
            steps {
                sshagent([remote]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker build --no-cache -t ${image} .
                    exit
                    EOF"""
                }
            }
        }
        stage('Test with Trivy') {
            steps {
                sshagent([remote]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    trivy image ${image}
                    exit
                    EOF"""
                }
            }
        }
        stage('Push to Docker Hub') {
            steps {
                sshagent([remote]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker push ${image}
                    exit
                    EOF"""
                }
            }
        }
        stage('Deploy') {
            steps {
                sshagent([remote]){
                    sh """ssh -o StrictHostKeyChecking=no ${server} << EOF
                    cd ${directory}
                    docker-compose up -d
                    exit
                    EOF"""
                }
            }
        }
    }
    post {
        success {
            echo 'Staging Deployment Successful!'
        }
        failure {
            echo 'Staging Deployment Failed!'
        }
    }
}
