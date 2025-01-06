pipeline {
    agent Node-Dev-100163

    stages {
        stage('Build') {
            steps {
                sh 'make install'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}