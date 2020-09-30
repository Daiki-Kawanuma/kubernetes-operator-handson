pipeline {
    // ジョブを実行する Jenkins Agent を指定する
    agent {
        label 'master'
    }

    stages {
        stage('Docker Build') {
            steps {
                sh
                '''
                    docker build -t someapp-operator:1.0 operator
                '''
            }
        }
    }

    post {
        failure {
            emailext(
                subject: "Your pipeline job was faild: ${currentBuild.fullDisplayName}",
                body: "FAILED: JENKINS Job [${currentBuild.fullDisplayName}] is failed. The branch is [${env.BRANCH_NAME}] Please go to ${env.BUILD_URL}.",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}
