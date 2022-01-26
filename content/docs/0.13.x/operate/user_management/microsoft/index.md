---
title: Microsoft
description: Setting up OpenID Connect with Microsoft
weight: 20
---

These instructions will take you through the process of getting your Keptn authenticating with Microsoft. You will create a client within Microsoft and configure Keptn to use Microsoft for authentication.

* To set up SSO via OpenID with Microsoft, you have to [register an application](https://docs.microsoft.com/en-us/azure/active-directory/develop/quickstart-register-app) in order to get a client id, client secret, and a discovery endpoint.

* Then the following environment variables can be set when installing Keptn:
```
bridge:
  ...
  oauth:
    enabled: true
    discovery: "https://login.microsoftonline.com/${directory_tenant_id}/v2.0/.well-known/openid-configuration"
    secureCookie: true
    baseUrl: <base_url>
    clientID: <client_id>
    clientSecret: <client_secret>
    scope: "email"
```

* It is also possible to directly change the `Deployment` manifest of an existing Keptn installation. After entering the new environment values, the Bridge pod has to be restarted.
```
OAUTH_ENABLED: "true"
OAUTH_DISCOVERY: "https://login.microsoftonline.com/${directory_tenant_id}/v2.0/.well-known/openid-configuration"
SECURE_COOKIE: "true"
OAUTH_BASE_URL: <base_url>
OAUTH_CLIENT_ID: <client_id>
OAUTH_CLIENT_SECRET: <client_secret>
OAUTH_SCOPE: "email"
```

* When accessing the Bridge, the user is redirected to the identity provider.
{{< popup_image
link="./assets/oauth-login-message.png"
caption="Accessing bridge without being logged in" width="800px">}}
{{< popup_image
link="./assets/oauth-login.png"
caption="Entering user credentials" width="400px">}}

* After the user successfully logs in with his Microsoft credentials, the user is redirected back to the Bridge. Once redirected, the Bridge server fetches the user tokens and creates a session. The user is now successfully logged in.
{{< popup_image
link="./assets/oauth-logged-in.png"
caption="User is logged in" width="800px">}}
