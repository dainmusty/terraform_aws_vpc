pipeline {
    agent any
    
    tools {
        terraform 'Terraform'
    }
    

    stages {
        stage('SCM Checkout') {
            steps {
                echo 'cloning repo with jenkins server'
                git branch: 'JIRA-25', credentialsId: '625e5371-0afe-44a2-8495-65016eb90f72', url: 'https://github.com/dainmusty/terraform_aws_vpc.git'
                sh 'ls'
            }
        }
        
        stage('terraform init') {
            steps {
                sh 'terraform init'
            }
        }  
        
        stage('terraform plan') {
            steps {
                sh 'terraform plan'
            }
        }
        
        stage('terraform action to apply or destroy plan') {
            steps {
                sh 'terraform ${action} --auto-approve'
            }
        }
    }
}
