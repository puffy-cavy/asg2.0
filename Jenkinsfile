def STACK_NAME
def DESIRED_CAPACITY
def MIN_SIZE
def MAX_SIZE

pipeline{
	agent any
	stages {
		stage('nonprod power scheduler'){
			// agent {
            //      label 'awsjenklinux'
            //  }
             environment {
                 PWD = pwd()
                 CURRENT_STAGE = 'non-prod'
                 CURRENT_ACTIVITY = 'deploy'
             }
			steps{
				script{
					ACCOUNT_CHOICES = ["Non-prod", "Prod"];
					def ACCOUNT_PARAMS = input(message: 'The ECS cluster modified is in Prod/ Non-prod account?', id: 'accountChoice',
					                            parameters: [[$class: 'ChoiceParameterDefinition', choices: ACCOUNT_CHOICES.join('\n'), name:'ACCOUNT',description: '']])
					echo ACCOUNT_PARAMS.ACCOUNT
					echo "${ACCOUNT}"
					if (ACCOUNT_PARAMS.ACCOUNT == "Non-prod") {
						ENV_CHOICES = ["dev", "qa", "stg"];
					}
					else if (ACCOUNT_PARAMS.ACCOUNT == "Prod") {
						ENV_CHOICES = ["uat", "prod"];
					}
					else {
						echo 'Input is wrong, go check'
					}
					APP_CHOICES = ["mpa", "fsn"];
					

					env.Profile="work-deploy-non-prod"
					sh 'chmod 777 aws-setup-credentials.sh'
                	sh 'aws-setup-credentials.sh'
					def INPUT_PARAMS = input(message: 'Choose the application and the environment the autoscaling group belongs to',id: 'applicationChoice',
					 			  	   parameters: [[$class: 'ChoiceParameterDefinition',
                             	  	   choices: APP_CHOICES.join('\n'),
                             		   name: 'APPLICATION',
                             		   description: 'Menu - select application option'],
									   [$class: 'ChoiceParameterDefinition',
                             	  	   choices: ENV_CHOICES.join('\n'),
                             		   name: 'ENVIRONMENT',
                             		   description: 'Menu - select environment option']])
					env.APP_NAME = INPUT_PARAMS.APPLICATION
					env.ENV_NAME = INPUT_PARAMS.ENVIRONMENT

					sh "source nameFinder.sh > nameList"
					NAME_LIST = readFile('nameList').trim()
					CLUSTER_CHOICE = NAME_LIST.split() as List
					CLUSTER = input message: 'Choose the cluster that need to be auto-scaled', ok : "Confirm", id: 'clusterChoice',
				              parameters:[choice(choices: CLUSTER_CHOICE, description: '', name:'')]
					env.STACK_NAME = "${CLUSTER}"	
					

					try{
						timeout(time: 5, unit: 'MINUTES'){
							def SIZE_PARAM = input(id: 'sizeChoice', message: 'Enter the size for the auto scaling group',
                            	parameters: [string(defaultValue: '',
                                            description: 'desired capacity for the auto scaling group',
                                            name: 'DESIRED_CAPACITY'),
                                    		string(defaultValue: '',
                                            description: 'min size for the auto scaling group',
                                            name: 'MIN_SIZE'),
											string(defaultValue: '',
                                            description: 'max size for the auto scaling group',
                                            name: 'MAX_SIZE'),
                            ])
							env.DESIRED_CAPACITY = SIZE_PARAM.DESIRED_CAPACITY
							env.MIN_SIZE = SIZE_PARAM.MIN_SIZE
							env.MAX_SIZE = SIZE_PARAM.MAX_SIZE
							}
						}
					catch(e){
						echo('Skipping Updating Autoscaling group')
						throw e
						}
						
					sh "source jenkins_bash.sh"

					}

				}
			}

	}
}