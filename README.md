# email-with-msgraph
example of how to email with msgraph.

in the event you have a service id email address you would like to send email from, but want to send this through msgraph instead of using smtp. if you have this id on office 365, this method provides an alternative in powershell to using smtp since send-mailmessage is deprecated.

i found some examples, but wanted to document the entire process here with a working example as well as include some steps to setup the app registration for only one id sending.

# steps to setup

## setup the setup

before we start, there are some setup items:

1. decide on your app name. i will use NEWAPP in the examples below
2. decide on your service email. you will need to create this beforehand. i will use SVC@E.MAIL in the examples below
3. you will need azure cli tools installed
4. you will need exchangeonlinemanagement powershell module installed
5. for the examples below, it's assumed that you will be logged in with an id in the organization you want to put things in. 

note after creation of the app, i will use the value NEWAPPID in the examples below. this value will actually be a GUID so replace it as needed.

## 1. create application registration

`az ad app create --display-name 'SVC@E.MAIL emailer'`

you can also create a new app however you wish in the azure portal. skip this step if you already have an azure application. display name can be whatever you want. i just appended ' emailer' after the email address we are setting it up to email with.

if you forget or need to list the appid (you'll need this for the next steps) you can run `az ad app list | convertfrom-json | select displayname,appid`

## 2. give the application a password

`az ad app credential reset --id NEWAPPID`

make sure you use the correct app id as this will reset it and use the defaults for other values. the output response will be a json object with a 'password' property you will need to retain and use.

you can also create the new password however you wish in the azure portal. skip this step if you already have authentication sorted for this app.

## 3. give the application permission of mail.send

see this link for instructions on how to give the new app registration permissions. you want to go the api permissions, add one, select microsoft graph, application permissions, type in mail, and select mail.send.
https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-configure-app-access-web-apis

you then want to go and grand admin consent in the permissions window.

todo: add cli for this step.
## 4. restrict the application to using only one email address

```ps1
# load up the exchange online commands and connect
Import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

# check before you create the policy just to validate that NEWAPPID does have access
Test-ApplicationAccessPolicy -Identity anyother@e.mail -AppId NEWAPPID

# create the new policy restricting the app to a single email address
New-ApplicationAccessPolicy -AppId NEWAPPID -PolicyScopeGroupId SVC@E.MAIL -AccessRight RestrictAccess -Description "Restrict this app to SVC@E.MAIL"

# check after you create the policy just to validate that NEWAPPID does not have access anymore
Test-ApplicationAccessPolicy -Identity anyother@e.mail -AppId NEWAPPID
```



