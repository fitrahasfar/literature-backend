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
                    docker build -t ${image} .
                    exit
                    EOF"""
                }
            }
        }
        // stage('Test with Trivy') {
        //     steps {
        //         sh 'trivy image team/backend:staging'
        //     }
        // }
        // stage('Push to Docker Hub') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
        //             sh 'echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin'
        //             sh 'docker push team/backend:staging'
        //             sh 'docker push team/frontend:staging'
        //         }
        //     }
        // }
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
