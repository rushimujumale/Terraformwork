properties([
    parameters([
        [$class: 'ChoiceParameter', 
            choiceType: 'PT_SINGLE_SELECT', 
            description: 'Select the Modules Name from the Dropdown List', 
            filterLength: 1, 
            filterable: true, 
            name: 'modules', 
            randomName: 'choice-parameter-5631314439613978', 
            script: [
                $class: 'GroovyScript', 
                fallbackScript: [
                    classpath: [], 
                    sandbox: false, 
                    script: 
                        'return[\'Could not get Modules\']'
                ], 
                script: [
                    classpath: [], 
                    sandbox: false, 
                    script: 
                        'return["private_hosted_zone","public_hosted_zone"]'
                ]
            ]
        ], 
        [$class: 'DynamicReferenceParameter', 
            choiceType: 'ET_FORMATTED_HTML', 
            description: 'These are the details in HTML format', 
            name: 'parameter', 
            omitValueField: false, 
            randomName: 'choice-parameter-5633384460832175', 
            referencedParameters: 'modules', 
            script: [
                $class: 'GroovyScript', 
                fallbackScript: [
                    classpath: [], 
                    sandbox: false, 
                    script: 
                        'return[\'Could not get Parameter from modules Param\']'
                ], 
                script: [
                    classpath: [], 
                    sandbox: false, 
                    script: 
                        ''' service_tier_map = [
                              "private_hosted_zone": [
                                ["variable_name": "domain_name", "value": "" ],
                                ["variable_name": "vpc_id", "value": ""],
                        
                              ],
                              "public_hosted_zone": [
                                ["variable_name": "domain_name", "value": "" ]                       
                           ]
                          html_to_be_rendered = "<table><tr>"
                          service_list = service_tier_map[modules]
                          service_list.each { service ->
                            html_to_be_rendered = """
                              ${html_to_be_rendered}
                              <tr>
                              <td>
                              <input name=\"value\" alt=\"${service.variable_name}\" json=\"${service.variable_name}\" type=\"checkbox\" class=\" \">
                              <label title=\"${service.variable_name}\" class=\" \">${service.variable_name}</label>
                              </td>
                              <td>
                              <input type=\"text\" class=\" \" name=\"value\" value=\"${service.value}\"> </br>
                              </td>
                              </tr>
                          """
                          }
                          html_to_be_rendered = "${html_to_be_rendered}</tr></table>"
                          return html_to_be_rendered
                        '''
                ]
            ]
        ]
    ])
])

pipeline {  
  agent any
  stages {
      stage('Setup') {
            steps {
                script {
                    echo "${params.modules}"
                    echo "${params.parameter}"
                    def input = params.parameter.split(',')
                    def output = ''
                    def currentVariable = null
                    def isParsingArray = false
                    def arrayValue = []

                    input.each { item ->
                        if (isParsingArray) {
                            arrayValue.add(item.trim())
                            if (item.endsWith("]")) {
                                isParsingArray = false
                                output += "${currentVariable} = [${arrayValue.join(', ')}]\n"
                                currentVariable = null
                                arrayValue.clear()
                            }
                        } else {
                            if (item.startsWith("[")) {
                                currentVariable = item.trim()
                                isParsingArray = true
                                arrayValue.add(currentVariable)
                                if (item.endsWith("]")) {
                                    isParsingArray = false
                                    output += "${currentVariable} = [${arrayValue.join(', ')}]\n"
                                    currentVariable = null
                                    arrayValue.clear()
                                }
                            } else {
                                currentVariable = item.trim()
                                output += "${currentVariable} = \"${item.trim()}\"\n"
                                currentVariable = null
                            }
                        }
                    }

                    writeFile file: 'dev.tfvars', text: output

                }
            }
        }

        stage('Checkout Code') {
            steps {
                // change branch name to master before merging
                git branch: 'main', credentialsId: "d184034c-1779-42a9-9550-37882d4551c4", url: 'https://github.com/rushimujumale/Terraformwork.git'
            }
        }
        stage('Terraform Init') {
            steps {
                withCredentials(awsCredentials) {
                sh 'terraform fmt'
                sh 'terraform init'
                }
            }
        }
        stage('Terraform Plan') {
            environment {
                TF_VAR_public_key = "${params.public_key}"
                }
            steps {
               withCredentials(awsCredentials) {
                   sh "terraform plan -target=module.\"${params.modules}\" -var-file=\"UC.tfvars\" -out=terraform.plan"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials(awsCredentials) {
                    sh 'terraform apply -auto-approve terraform.plan'
                }
            }
        }
        // stage('Terraform Destroy') {
        //     steps {
        //         withCredentials(awsCredentials) {
        //             sh 'terraform destroy -auto-approve'
        //         }
        //     }
        // }
    }
}
