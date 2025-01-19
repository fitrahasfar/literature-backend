def remote = 'remote'
def server = 'ftrh4551@103.127.139.214'
def directory = 'literature-backend'
def branch = 'main'
def image = 'fitrah4551/dumbflix:1.0.2'
def container = 'backend'
def discordWebhook = 'https://discord.com/api/webhooks/1328944383306891304/L4iCDGeKjinwXSyUYSKIln1dv3MREXkgm-f9FGy7EmhLOae9qp6QbVL8APRJ41-LoKRQ'

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
                    if [ \$(docker ps -q -f name=${container}) ]; then
                    docker stop ${container}
                    docker rm ${container}
                    fi
                    docker-compose up -d
                    exit
                    EOF"""
                }
            }
        }
        stage('Notify Discord') {
            steps {
                script {
                    def message = """
                    {
                        "content": "🚀 Deployment Successful for **${image}** on ${server}"
                    }
                    """
                    httpRequest(
                        url: discordWebhook,
                        httpMode: 'POST',
                        contentType: 'APPLICATION_JSON',
                        requestBody: message
                    )
                }
            }
        }
    }
    post {
        success {
            echo 'Staging Deployment Successful!'
        }
        failure {
            script {
                def message = """
                {
                    "content": "❌ Deployment Failed for **${image}** on ${server}"
                }
                """
                httpRequest(
                    url: discordWebhook,
                    httpMode: 'POST',
                    contentType: 'APPLICATION_JSON',
                    requestBody: message
                )
            }
        }
    }
}
