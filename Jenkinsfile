node('Node-Dev-100163') {
    try {
        stage('Checkout') {
            echo 'Pulling...' + env.BRANCH_NAME
            checkout scm
        }
        stage('Build') {
            sh 'make install'
            sh 'make build-image'
        }
        stage('Start Docker Container'){
            sh 'make clean_up' 
            sh 'make run-server-docker'
        }
        stage('Testing') {
            sh 'make run_test_docker' 
        }
        stage('Publish') {
            sh 'make push-image' 
        }
        currentBuild.result = "SUCCESS" // Set success status after all stages complete
    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}