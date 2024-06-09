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
                // This command generates an execution plan and saves it to a file named tfplan
                sh "terraform plan"
            }
        }
  

        stage('Apply') {
            steps {
                sh "terraform apply -input=false tfplan"
            }
        }

        stage('ansible-execute') {
            steps {
                // execute ansible playbook
                // ansiblePlaybook playbook: 'create-EC2.yml'
            }
        }
    }

  }
