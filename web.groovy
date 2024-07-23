pipeline {
    agent { label 'master' }
    triggers {
        pollSCM('* * * * *')
    }
    /*environment {
        TF_PATH = 'terraform/*'  // Путь к Terraform файлам
        ANSIBLE_PATH = 'ansible_project/*'  // Путь к Ansible файлам
        }*/
    stages {
       
       /* stage('Check Changes') {
            steps {
                // Проверяем, какие файлы были изменены
                script {
                    def gitChanges = sh(script: "git diff HEAD HEAD~  --name-only", returnStdout: true).trim()
                    if (gitChanges.contains(env.TF_PATH)) {
                        env.RUN_TERRAFORM = 'true'
                    }
                    if (gitChanges.contains(env.ANSIBLE_PATH)) {
                        env.RUN_ANSIBLE = 'true'
                    }
                }
            }
        }*/
        //building external LB infrastructure on GCP with terraform
        stage ('build IaC') {
            agent { label 'master' }
            /*when {
                expression { env.RUN_TERRAFORM == 'true' }
            }*/
            steps {
                echo 'Building infrastructure'
                sh '''
                cd terraform/
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
        
        stage ('prebuild lint tests') {
            agent { label 'master' }
            /*when {
                expression { env.RUN_ANSIBLE == 'true' }
            }*/
            steps {
                echo 'Test type: syntax'
                sh '''
                cd ansible_project/
                ansible-playbook playbook.yml --syntax-check
                echo "Syntax check is complete"
                '''
            }
        }
        stage('Ansible Run') {
            agent { label 'master' }
            /*when {
                expression { env.RUN_ANSIBLE == 'true' }
            }*/
            steps {
                
                sh '''
                cd ansible_project/
                ansible-playbook  playbook.yml
                '''
                
            }
        }
        stage('Website accessibility test') {
            agent { label 'master' }
            steps {
                 script {
                    def website = sh(script: "gcloud compute instances describe nginx-webserver --zone=europe-west2-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'", returnStdout: true).trim()
                    echo "ip webserver: ${website}"
                    sh "curl -XGET 'http://${website}'"
                }   
            }
        }

    }

post {
    always {
        echo 'Deploy web server on GCP is completed'
    }
    success {
        echo 'I succeeded!'
    }
    failure {
        echo 'I failed!'
    }
    
}      
}
