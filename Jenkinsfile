node('Node-Dev-100163') {
    try {
        stage('Checkout') {
            echo 'Pulling...' + env.BRANCH_NAME
            checkout scm
        }
        stage('Build') {
            steps{
                    sh 'make install'
                }
            steps{
                    sh 'make build-image'
                }
            steps{
                    sh 'make push-image'
            }
        }
        stage('Start Docker Container'){
            steps{
               sh 'make run-server-docker' 
            }
        }
        stage('Testing') {
            steps{
               sh 'make run_test_docker' 
            }
        }
        currentBuild.result = "SUCCESS" // Set success status after all stages complete
    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}