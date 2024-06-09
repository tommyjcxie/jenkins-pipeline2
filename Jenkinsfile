pipeline {

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
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

        stage('Plan') {
            steps {
                sh 'terraform init'
                // Generate the execution plan and save it to a file named tfplan
                sh 'terraform plan -out=tfplan'
                // Apply the plan immediately
                sh 'terraform apply -input=false tfplan'
            }
        }
  
    }

  }
