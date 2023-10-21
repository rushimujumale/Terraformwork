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
        stage('List .tfvars Files') {
            steps {
                script {
                    def branchOrTag = 'main' // Use 'main' branch
                    def githubRepoUrl = 'https://github.com/rushimujumale/Terraformwork.git'
                    
                    // Use 'git ls-tree' to list .tfvars files in the 'main' branch
                   def tfvarsFiles = sh(script: "git ls-files | grep -E '^.+\\.tfvars$'", returnStatus: true, returnStdout: true).trim().split('\n')



                    if (tfvarsFiles.isEmpty()) {
                        error("No .tfvars files found in the repository.")
                    }

                    // Prompt the user to choose a .tfvars file
                    def tfvarsChoice = input(
                        id: 'tfvarsChoice',
                        message: 'Choose a .tfvars file:',
                        parameters: tfvarsFiles.collect { choice(name: it, description: it) }
                    )

                    // Set the chosen .tfvars file as an environment variable
                    env.TFVARS_FILE = tfvarsChoice
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
                sh "terraform apply -var-file=environment/${env.ENVIRONMENT}/terraform
