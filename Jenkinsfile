pipeline {

     parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    } 

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
                sh "terraform plan -out tfplan"
                
                //displays the contents of the saved plan (tfplan) and redirects the output to a file named tfplan.txt
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }
        stage('Approval') {
           when {
               not {
                   equals expected: true, actual: params.autoApprove
               }
           }

           steps {
               script {
                    def plan = readFile 'terraform/tfplan.txt'
                    input message: "Do you want to apply the plan?",
                    parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
               }
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
                ansiblePlaybook playbook: 'create-EC2.yml'
            }
        }
    }

  }
