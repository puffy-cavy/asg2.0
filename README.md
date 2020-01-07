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
INPUT_PARAMS = input message: 'Choose the application and the environment the autoscaling group belongs to', ok : "Confirm", id: 'applicationChoice',parameters: [choice(name:'APPLICATION', choices: APP_CHOICES, description: '')]
env.APP_NAME = "${APPLICATION}"
```
(注：如果APPLICATION call不出来，就用INPUT_PARAMS call)
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
wocao 又出现一个傻逼玩意儿，，INPUT_PARAMS.APPLICATION这种retrieve input的格式只用在多个parameter中，只有一个input的时候，直接用INPUT_PARAMS，用INPUT_PARAMS.APPLICATION反而找不着
#### 3.
把一个list从bash里传出去：
```
STACK_LIST=($(aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text | grep -w ${ENV_NAME}.*${APP_NAME}.*cluster))
echo ${STACK_LIST[*]}
```
return value外面加括号表示是list，传出去的要用[*]代表一个list
传进Jenkins的时候：
```
sh "source nameFinder.sh > nameList"
NAME_LIST = readFile('nameList').trim()
CLUSTER_CHOICE = NAME_LIST.split() as List
```
read进file 再trim		
					
#### 4.
我搞出来该怎么限制哪个用户能build这个project了。参考https://plugins.jenkins.io/authorize-project
先安装plugin：authorize project，进manage jenkins>configure global security>authorization>Project-based Matrix Authorization Strategy
一定要unchecked authenticated user，否则，任何log in进去的user都有相同的权限
然后添加各个username并选择权限
在同一个页面的Access Control for Builds里，都选 Run as User who Triggered Build
貌似选Run as Specific User就只能添加一个user，并且不管谁run一个build，都拥有这个specific user的权限。
然后在每一个project里都有Ahthorization,还要选一下run as user who triggered build
最后在每个project里再选谁可以access


		
