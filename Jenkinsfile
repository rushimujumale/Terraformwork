pipeline {
    agent any
    environment {
        TF_CLI_ARGS = "-no-color"
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code repository from GitHub
                git branch: 'main', credentialsId: 'd184034c-1779-42a9-9550-37882d4551c4', url: 'https://github.com/rushimujumale/Terraformwork.git'
            }
        }
        stage('Ask for Environment') {
            steps {
                script {
                    def envChoice = input(
                        id: 'envChoice',
                        message: 'Choose the environment:',
                        parameters: [
                            choice(name: 'dev', description: 'Development Environment'),
                            choice(name: 'staging', description: 'Staging Environment'),
                            choice(name: 'prod', description: 'Production Environment')
                        ]
                    )

                    // Set the environment based on the user's choice
                    env.ENVIRONMENT = envChoice
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

                    // Set a variable based on the user's choice
                    def hostedZoneType = zoneChoice == 'public' ? false : true

                    // Pass the choice to Terraform as an environment variable
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

