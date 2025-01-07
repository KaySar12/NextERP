node('Node-Dev-100163'){
     currentBuild.result = "SUCCESS"
    try {
        stage('Checkout'){
            checkout scm
        }
        stage('Setup'){
           steps {
            sh 'make install'
           }
        }
        stage('Testing'){
           steps {
            sh 'make gen_test_config'
           }
           steps{
            sh 'make run_test'
           }
               steps{
            sh 'make clean_test'
           }
        }
    } catch (err) {
        currentBuild.result = "FAILURE"
        throw err
    }
}