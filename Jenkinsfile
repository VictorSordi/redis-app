pipeline {
    agent any
    stage('build docker image'){
        steps{
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
        stepś{
            sh 'test-app.sh'
        }
    }
}