pipeline {
    agent any
    environment {
        TF_CLI_ARGS = "-no-color"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', credentialsId: 'd184034c-1779-42a9-9550-37882d4551c4', url: 'https://github.com/rushimujumale/Terraformwork.git'
            }
        }
        stage('Ask for Environment') {
            steps {
                script {
                    def githubRepoUrl = 'https://github.com/rushimujumale/Terraformwork.git'
                    def filesList = sh(script: "curl -s -H 'Accept: application/vnd.github.v3.raw' ${githubRepoUrl}/contents/environments/dev", returnStatus: true, returnStdout: true).trim()
                    def fileList = filesList.tokenize("\n")
                    def tfvarsFiles = []

                    for (file in fileList) {
                        if (file.endsWith('.tfvars')) {
                            tfvarsFiles.add(file)
                        }
                    }

                    def tfvarsChoice = input(
                        id: 'tfvarsChoice',
                        message: 'Choose a .tfvars file:',
                        parameters: tfvarsFiles.collect { choice(name: it, description: it) }
                    )

                    env.TFVARS_FILE = "environments/dev/${tfvarsChoice}"
                }
            }
        }
        stage('Ask for Public or Private') {
            steps {
                script {
                    def zoneChoice = input(
                        id: 'zoneChoice',
                        message: 'Choose the hosted zone type:',
                        parameters: [
                            choice(name: 'public', description: 'Public Hosted Zone'),
                            choice(name: 'private', description: 'Private Hosted Zone')
                        ]
                    )

                    def hostedZoneType = zoneChoice == 'public' ? false : true

                    env.HOSTED_ZONE_TYPE = hostedZoneType.toString()
                }
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan and Apply') {
            steps {
                sh "terraform apply -var-file=environment/${env.ENVIRONMENT}/terraform.tfvars -var 'is_private=${env.HOSTED_ZONE_TYPE}' -auto-approve"
            }
        }
        stage('Terraform Destroy') {
            steps {
                input(id: 'destroy', message: 'Destroy the resources?', ok: 'Destroy')
                sh "terraform destroy -var-file=environment/${env.ENVIRONMENT}/terraform.tfvars -var 'is_private=${env.HOSTED_ZONE_TYPE}' -auto-approve"
            }
        }
    }
}

