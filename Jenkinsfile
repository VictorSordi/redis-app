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
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=redis-app -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN} -X"
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