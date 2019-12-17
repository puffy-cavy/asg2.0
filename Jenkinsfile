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
					input {message: 'Choose the application and the environment the autoscaling group belongs to', ok : "Confirm", id: 'applicationChoice',
					 			  parameters{ choice(name:'APPLICATION', choices: APP_CHOICES, description: '')
								   			  choice(name:'ENVIRONMENT', choices: ENV_CHOICES, description: '')
								  }
					}  
					ENVIRONMENT = input message: 'Choose the environment the autoscaling group belongs to', ok : "Confirm", id: 'environmentChoice',
								  parameters:[choice(choices: ENV_CHOICES, description: '', name:'')]
					env.APP_NAME = "${APPLICATION}"
					env.ENV_NAME = "${ENVIRONMENT}"

					sh "source nameFinder.sh > nameList"
					NAME_LIST = readFile('nameList').trim()
					CLUSTER_CHOICE = NAME_LIST.split() as List
					CLUSTER = input message: 'Choose the cluster that need to be auto-scaled', ok : "Confirm", id: 'clusterChoice',
				              parameters:[choice(choices: CLUSTER_CHOICE, description: '', name:'')]
					env.STACK_NAME = "${CLUSTER}"	


					

					try{
						timeout(time: 5, unit: 'MINUTES'){
							DESIRED_CAPACITY = input(id: 'desiredCapacity', message: 'Input desried capacity of the auto scaling group', parameters: [[$class: 'TextParameterDefinition', defaultValue: '', description: '', name: '']])
							}
						}
					catch(e){
						echo('Skipping Updating Autoscaling group')
						throw e
						}

					try{
						timeout(time: 5, unit: 'MINUTES'){
							MIN_SIZE = input(id: 'minSize', message: 'Input minimum size of the auto scaling group', parameters: [[$class: 'TextParameterDefinition', defaultValue: '', description: '', name: '']])
							}
						}
					catch(e){
						echo('Skipping Updating Autoscaling group')
						throw e
						}

					try{
						timeout(time: 5, unit: 'MINUTES'){
							MAX_SIZE = input(id: 'maxSize', message: 'Input maximum size of the auto scaling group', parameters: [[$class: 'TextParameterDefinition', defaultValue: '', description: '', name: '']])
							}
						}
					catch(e){
						echo('Skipping Updating Autoscaling group')
						throw e
						}
	
					env.DESIRED_CAPACITY = "${DESIRED_CAPACITY}"
					env.MIN_SIZE = "${MIN_SIZE}"
					env.MAX_SIZE = "${MAX_SIZE}"
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