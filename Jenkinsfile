node('Node-Dev-100163') {
    try {
        stage('Checkout') {
            echo 'Pulling...' + env.BRANCH_NAME
            checkout scm
        }
        stage('Build') {
            sh 'make install'
            sh 'make clean_up'
            sh 'make build_image'
        }
        stage('Start Docker Container'){ 
            sh 'make run_server_docker'
        }
        stage('Testing') {
            // sh 'make run_test_docker' 
        }
        stage('Publish') {
            sh 'make push_image' 
        }
        currentBuild.result = "SUCCESS" // Set success status after all stages complete
    } catch (err) {
        currentBuild.result = "SUCCESS"
        throw err
    }
}