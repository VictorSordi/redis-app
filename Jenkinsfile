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

        stage('Sonarqube validation'){
            steps{
                script{
                    scannerHome = tool 'sonar-scanner';
                }
                withSonarQubeEnv('sonar-server'){
                    withCredentials([string(credentialsId: 'a91750a6a2714f85c727aaf722e627700082b9f4', variable: 'SONAR_AUTH_TOKEN')])
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=redis-app -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login ${env.SONAR_AUTH_TOKEN}"
                }
            }
        }

        stage('application test'){
        steps{
            sh 'chmod +x test-app.sh'
            sh './test-app.sh'
            }
        }

        stage("Shutdown test containers"){
        steps{
            sh 'docker compose down'
            }
        }
    }
}