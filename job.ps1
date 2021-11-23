# replace the following values where appropriate.
# YOURTENANTIDGOESHERE YOURCLIENTIDGOESHERE YOURCLIENTSECRETGOESHERE YOURSERVICEMAILGOESHERE

$tokenParams = @{
  "URI"    = "https://login.microsoftonline.com/{0}/oauth2/v2.0/token" -f "YOURTENANTIDGOESHERE"
  "Method" = "POST"
  "Body"   = @{
    client_id     = "YOURAPPIDGOESHERE"
    scope         = "https://graph.microsoft.com/.default"
    client_secret = "YOURAPPSECRETGOESHERE"
    grant_type    = "client_credentials"
  }
}
$tokenresponse = Invoke-RestMethod @tokenParams

$emailParams = @{
  "URI"         = "https://graph.microsoft.com/v1.0/users/{0}/sendMail" -f "YOURSERVICEMAILGOESHERE"
  "Headers"     = @{
    'Content-Type'  = "application\json"
    'Authorization' = "Bearer {0}" -f $tokenresponse.access_token 
  }
  "Method"      = "POST"
  "ContentType" = 'application/json'
  "Body"        = (@{
      "message" = @{
        "subject"      = "Test {0:yyyyMMddHHmmss.fff}" -f (get-date)
        "toRecipients" = @(
          @{
            "emailAddress" = @{"address" = "rashbrook@patriottrans.com" }
          }
        ) 
      }
    }) | ConvertTo-JSON -Depth 6
}

Invoke-RestMethod @emailParams