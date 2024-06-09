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
                      cleanWs()
                        dir("terraform")
                        {
                            git branch: 'main', 
                              url: 'https://github.com/tommyjcxie/jenkins-pipeline2'
                        }
                    }
                }
            }

          stage('execute') {
            steps {
                // execute ansible playbook
                ansiblePlaybook playbook: 'create-EC2.yml'
            }
        }
    }
}

       
