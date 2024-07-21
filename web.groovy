pipeline {
    agent { label 'master' }
    triggers {
        pollSCM('* * * * *')
    }
    stages {
        stage ('GIT clone') {
            agent { label 'master' }
            steps {
           // The below will clone your repo and will be checked out to master branch by default.
            git credentialsId: 'jenkins-rsa', url: 'git@github.com:set1991/gcp_webserver.git'
           // Do a ls -lart to view all the files are cloned. It will be clonned. This is just for you to be sure about it.
            sh "ls -lart ./*"         
        }
        }        
        stage ('prebuild lint tests') {
            agent { label 'master' }
            steps {
                sh '''
                echo 'Test type: syntax'
                cd ansible_project/
                ansible-playbook playbook.yml --syntax-check
                ansible-lint
                echo "Syntax check is complete"
                //linter test
                '''
            }
        }
        //building external LB infrastructure on GCP with terraform
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
        echo 'One way or another, I have finished'
    }
    success {
        echo 'I succeeded!'
    }
    failure {
        echo 'I failed :('
    }
    changed {
        echo 'Things were different before...'
    }
}      
}
