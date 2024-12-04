pipeline {
    agent any

    stages {
        stage('build docker image'){
        steps{
            //sh 'echo "jenkins" | sudo -S docker build -t devops/app .'
            sh 'docker build -t devops/app .'
            }
        }
    
        stage ('deploy docker compose - redis and app'){
        steps{
            sh 'docker compose up --build -d'
            }
        }

        stage('sleep for container deploy'){
        steps{
            sh 'sleep 10'
            }
        }

        stage('application test'){
        steps{
            sh 'chmod +x test-app.sh'
            sh './test-app.sh'
            }
        }
    }
}