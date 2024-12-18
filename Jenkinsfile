pipeline {
    agent any

    environment {
        TAG = sh(script: 'git describe --abbrev=0',,returnStdout: true).trim()
    }

    stages {
        stage('build docker image'){
        steps{
            //sh 'echo "jenkins" | sudo -S docker build -t devops/app .'
            sh 'docker build -t devops/app:${TAG} .'
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
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=redis-app -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.token=${env.SONAR_AUTH_TOKEN} -X"
                }
                sh 'sleep 10'
            }
        }

        stage("Quality Gate"){
            steps{
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
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

        stage('Upload docker image'){
            steps{
                script {
                    withCredentials([usernamePassword(credentialsId: 'nexus-user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh 'docker login -u $USERNAME -p $PASSWORD ${NEXUS_URL}'
                        sh 'docker tag devops/app:${TAG} ${NEXUS_URL}/devops/app:${TAG}'
                        sh 'docker push ${NEXUS_URL}/devops/app:${TAG}'
                    }
                }
            }
        }

        stage("Apply kubernetes files"){
            steps{
                sh '/usr/local/bin/kubectl apply -f ./k3s/redis.yaml'
                sh '/usr/local/bin/kubectl apply -f ./k3s/redis-app.yaml'
            }
        }
    }
}