pipeline {
    agent any

    stages {
        stage('Run Script') {
            steps {
                script {
                    // Checkout the repository
                    checkout scm

                    // Execute the pintu.sh script
                    sh 'sh pintu.sh'
                }
            }
        }
    }
}

