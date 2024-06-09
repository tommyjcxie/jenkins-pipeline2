pipeline {

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        SSH_KEY               = credentials('ansible-key') // Use the ID of the SSH key credential
    }

   agent  any
    stages {
        stage('checkout') {
            steps {
                 script{
                
                       git branch: 'main', 
                         url: 'https://github.com/tommyjcxie/jenkins-pipeline2'
                       
                    }
                }
            }

        stage('Terraform Init and Plan') {
            steps {
                sh 'terraform init'
                // Generate the execution plan and save it to a file named tfplan
                sh 'terraform destory'
            }
        }

    
        
    }
}
