node('Node-Dev-100163') {
    try {
        stage('Checkout') {
            echo 'Pulling...' + env.BRANCH_NAME
            checkout scm
        }
        stage('Cleanup') {
            sh "make update_tag CURR_BRANCH=${env.BRANCH_NAME}"
            sh 'make clean_up' 
        }
        stage('Build') {
            // sh 'make install'
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