node('node'){
     currentBuild.result = "SUCCESS"
     try {
    stage('Checkout'){

          checkout scm
    }
    stage('Test'){
            
    }

     } catch (err) {

        currentBuild.result = "FAILURE"
        throw err
    }
}