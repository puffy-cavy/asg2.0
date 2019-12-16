# asg2.0
With dropdown menu to select the application and environment
#### 1.
如果要在terminal里query 公司AWS的账户，先进行saml的验证，在amazon_adfs这个folder里。之后每一句query后面都要append “--profile saml”
比如 ```aws cloudformation describe-stacks --query 'Stacks[*].[StackName]' --output text --profile saml| grep -m 1 'qa-fsn-ecs-cluster'```
