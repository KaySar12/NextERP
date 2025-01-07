node('Node-Dev-100163') {
    try {
        stage('Checkout') {
            checkout scm
        }
        stage('Setup') {
            sh 'make install'
        }
        stage('Testing') {
            sh 'make gen_test_config'
            sh 'make run_test'
            sh 'make clean_test' 
        }
        currentBuild.result = "SUCCESS" // Set success status after all stages complete
    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}