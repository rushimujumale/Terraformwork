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

        stage('Select Environment Folder') {
            steps {
                script {
                    // Prompt user to select environment folder
                    def selectedFolder = input(
                        message: "Select the environment folder for configuration",
                        parameters: [choice(
                            name: 'ENV_FOLDER',
                            choices: 'dev\nprod\nstaging', // Add your environment choices here
                            description: 'Select the environment folder for configuration'
                        )]
                    )

                    // Set the selected environment folder as an environment variable
                    env.ENV_FOLDER = selectedFolder
                }
            }
        }

        stage('List tfvars') {
            steps {
                script {
                    // Find .tfvars files in the selected environment folder
                    def files = sh(returnStdout: true, script: "ls $WORKSPACE/environments/${env.ENV_FOLDER}/*.tfvars")

                    // Extract only the filename without the path and add it to the choiceArray
                    choiceArray = files.tokenize().collect {
                        it.tokenize('/').last()
                    }
                }
            }
        }

        stage('Select tfvars') {
            steps {
                script {
                    // Prompt user to select .tfvars file
                    def selectedTfvars = input(
                        message: "Select the .tfvars file for the VPC configuration",
                        parameters: [choice(
                            name: 'TERRAFORM_VARS',
                            choices: choiceArray,
                            description: 'Select the .tfvars file for the VPC configuration'
                        )]
                    )

                    // Check if the user made a selection
                    if (!selectedTfvars || selectedTfvars.isEmpty()) {
                        error "Please select the .tfvars file for the VPC configuration."
                    }

                    // Set the selected .tfvars file as an environment variable
                    env.TERRAFORM_VARS = selectedTfvars
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
                sh "terraform apply -var-file=environment/${env.ENV_FOLDER}/${env.TERRAFORM_VARS} -var 'is_private=${env.HOSTED_ZONE_TYPE}' -auto-approve"
            }
        }

        stage('Terraform Destroy') {
            steps {
                input(id: 'destroy', message: 'Destroy the resources?', ok: 'Destroy')
                sh "terraform destroy -var-file=environment/${env.ENV_FOLDER}/${env.TERRAFORM_VARS} -var 'is_private=${env.HOSTED_ZONE_TYPE}' -auto-approve"
            }
        }
    }
}
