node('Node-Dev-100163') {
    try {
        stage('Checkout') {
            echo 'Pulling...' + env.BRANCH_NAME
            checkout scm
        }
        stage('Cleanup') {
            sh 'make clean_up' 
        }
        stage('Build') {
            sh 'sed -i s/TAG := \$(shell rev-parse --abbrev-ref HEAD)/TAG := ${env.BRANCH_NAME}/g Makefile'
            sh 'make install'
            sh 'make stop_server_docker'
            sh 'make gen_config'
            sh 'make build_image'
        }
        stage('Start'){ 
            sh 'make run_server_docker'
            sh 'make restore_database'
        }
        stage('Testing') {
            sh 'make run_test_docker' 
        }
        stage('Publish') {
            sh 'make push_image' 
        }
        currentBuild.result = "SUCCESS" // Set success status after all stages complete
    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}