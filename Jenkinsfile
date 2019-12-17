def STACK_NAME
def DESIRED_CAPACITY
def MIN_SIZE
def MAX_SIZE

pipeline{
	agent any
	stages {
		stage('DEV'){
			steps{
				script{
					APP_CHOICES = ["mpa", "fsn"];
					ENV_CHOICES = ["dev", "qa", "stg"];
					// INPUT_PARAMS = input message: 'Choose the application and the environment the autoscaling group belongs to', ok : "Confirm", id: 'applicationChoice',
					// 			  parameter: [choice(name:'APPLICATION', choices: APP_CHOICES, description: '')]
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
					// ENVIRONMENT = input message: 'Choose the environment the autoscaling group belongs to', ok : "Confirm", id: 'environmentChoice',
					// 			  parameters:[choice(choices: ENV_CHOICES, description: '', name:'')]
					// env.APP_NAME = "${APPLICATION}"
					// env.ENV_NAME = "${ENVIRONMENT}"

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
	
					// env.DESIRED_CAPACITY = SIZE_PARAM.DESIRED_CAPACITY
					// env.MIN_SIZE = SIZE_PARAM.MIN_SIZE
					// env.MAX_SIZE = SIZE_PARAM.MAX_SIZE
					sh "source jenkins_bash.sh"

					}

				}
			}


		stage('QA'){
			steps{
				sh "echo [QA STAGE]"
			}
		}
	}
}