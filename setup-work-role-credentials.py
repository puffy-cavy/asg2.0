import os
import json
import sys

#TODO how do we share bash scripts and python code now that we have different repos for every service?
#command-line argument captured
# expects 'work-deploy-prod' or 'work-deploy-non-prod'
profile_descriptor = sys.argv[1:]

prod_deployment_role = '''aws sts assume-role --role-arn "arn:aws:iam::171241176688:role/work-deploy-prod" --role-session-name "plan-advantage-deploy-role-session"'''
prod_profile = '[profile work-deploy-prod]'

#non-prod role and profile
role = '''aws sts assume-role --role-arn "arn:aws:iam::811775850688:role/work-deploy-non-prod" --role-session-name "plan-advantage-deploy-role-session"'''
profile = '[profile work-deploy-non-prod]'

#override role and profile for production
if 'work-deploy-prod' in profile_descriptor:
	role = prod_deployment_role
	profile = prod_profile

aws_assume_role_output = os.popen(role).read()


aws_assume_role_parsed_output = json.loads(aws_assume_role_output)
access_key_id = aws_assume_role_parsed_output["Credentials"]["AccessKeyId"]
secret_access_key = aws_assume_role_parsed_output["Credentials"]["SecretAccessKey"]
session_token = aws_assume_role_parsed_output["Credentials"]["SessionToken"]
sts_role = aws_assume_role_parsed_output["AssumedRoleUser"]["Arn"]

with open(os.path.expanduser(os.environ['PWD']+"/aws/config/config_file"), "w+") as credentials_file:

	credentials_file.write(profile)
	credentials_file.write('\nregion=us-east-1')
	credentials_file.write('\naws_access_key_id=' + str(access_key_id))
	credentials_file.write('\naws_secret_access_key=' + secret_access_key)
	credentials_file.write('\naws_session_token=' + str(session_token))

credentials_file.close()