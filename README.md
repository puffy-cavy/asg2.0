# asg2.0
With dropdown menu to select the application and environment
#### 1.
如果要在terminal里query 公司AWS的账户，先进行saml的验证，在amazon_adfs这个folder里。之后每一句query后面都要append “--profile saml”
比如 ```aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text --profile saml| grep -m 1 'qa-fsn-ecs-cluster'```
#### 2.
wojiucaole
input语句在script外和script里的syntax不一样！！！！Jenkins documentation上的是input在script外。input里有一个parameter和多个parameter也不一样，tm多个parameter的时候居然还加s。。。
正确的syntax：
https://stackoverflow.com/questions/47080683/read-interactive-input-in-jenkins-pipeline-to-a-variable
曾经一个页面一个input的时候：
```
INPUT_PARAMS = input message: 'Choose the application and the environment the autoscaling group belongs to', ok : "Confirm", id: 'applicationChoice',parameter: [choice(name:'APPLICATION', choices: APP_CHOICES, description: '')]
env.APP_NAME = "${APPLICATION}"
```
现在一个页面多个input的时候：
```
def INPUT_PARAMS = input(message: 'Choose the application and the environment the autoscaling group belongs to',id:'applicationChoice',parameters: [[$class: 'ChoiceParameterDefinition',
                             	  	   choices: APP_CHOICES.join('\n'),
                             		   name: 'APPLICATION',
                             		   description: 'Menu - select application option'],
									   [$class: 'ChoiceParameterDefinition',
                             	  	   choices: ENV_CHOICES.join('\n'),
                             		   name: 'ENVIRONMENT',
                             		   description: 'Menu - select environment option']])
					env.APP_NAME = INPUT_PARAMS.APPLICATION
					env.ENV_NAME = INPUT_PARAMS.ENVIRONMENT
```
parameters在input里和在script外的表现形式也不一样，，，反正input里的parameters是[]。。。
