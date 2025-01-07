node('Node-Dev-100163') {
    try {
        stage('Checkout') {
            echo 'Pulling...' + env.BRANCH_NAME
            checkout scm
        }
        stage('Build') {
            steps{
                sh 'make install'
                sh 'make push-image'
                sh 'make build-image'
            }

        }
        stage('Start Docker Container'){
            steps{
                sh 'make clean_up' 
                sh 'make run-server-docker'
            }
        }
        stage('Testing') {
            steps{
               sh 'make run_test_docker' 
            }
        }
        stage('Publish') {
            steps{
               sh 'make push-image' 
            }
        }
        currentBuild.result = "SUCCESS" // Set success status after all stages complete
    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}