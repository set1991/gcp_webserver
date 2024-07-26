pipeline {
    agent { label 'master' }
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage ('build IaC') {
            agent { label 'master' }
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
