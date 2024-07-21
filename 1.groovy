pipeline {
    agent any

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        TF_PATH = 'terraform/*'  // Путь к Terraform файлам
        ANSIBLE_PATH = 'ansible/*'  // Путь к Ansible файлам
    }

    stages {
        
        stage('Check Changes') {
            steps {
                // Проверяем, какие файлы были изменены
                script {
                    def gitChanges = sh(script: "git diff HEAD HEAD~ --name-only", returnStdout: true).trim()
                    if (gitChanges.contains(env.TF_PATH)) {
                        env.RUN_TERRAFORM = 'true'
                    }
                    if (gitChanges.contains(env.ANSIBLE_PATH)) {
                        env.RUN_ANSIBLE = 'true'
                    }
                }
            }
        }

        stage('Run Terraform') {
            when {
                expression { env.RUN_TERRAFORM == 'true' }
            }
            steps {
                echo 'Running Terraform'
                sh '''
                cd terraform
                terraform init
                terraform apply -auto-approve
                '''
            }
        }

        stage('Run Ansible') {
            when {
                expression { env.RUN_ANSIBLE == 'true' }
            }
            steps {
                echo 'Running Ansible'
                sh '''
                cd ansible
                ansible-playbook -i inventory playbook.yml
                '''
            }
        }
    }

    post {
        success {
            echo 'Deployment completed successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}