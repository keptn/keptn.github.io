---
title: OAuth/OpenID Authentication
description: Enable/Disable OAuth authentication and implementation details for OAuth service
weight: 20
keywords: [0.8.x-bridge]
---

## Enable/Disable Authentication

The Keptn Bridge contains a switch to enable/disable OAuth/OpenID Connect-based authentication. This switch also enables session cookies. 

You can enable/disable OAuth via the Helm Chart values when installing Keptn: 

```
bridge:
  ...
  oauth:
    enabled: false
    discovery: ""
    secureCookie: false
    trustProxy: ""
```

## Authentication flow with OAuth service

The following diagram shows the expected authentication flow with a custom OAuth service that follows the implementation details explained below. 

{{< popup_image
link="./assets/oauth-flow.png"
caption="Authentication flow with OAuth service" width="800px">}}

Keptn Bridge should check the existence of OAuth service and also validate responses obtained from it. For example, next are requests and responses the Keptn Bridge can expect from OAuth service.

*To obtain authorization request:*

```
Request :

   Get <OAuth_Service>/authorization

Response :

  {
   "location": <authorization_request>
  }
```

*To validate authorization code & permissions:*

```
Request :

   POST <OAuth_Service>/token_decision

   {
     "state" : <state>,
     "code" : <authorization_code>
   }

Response :

  {
   "user" : <USER_IDENTIFIER>
  }
```

OAuth service must implement logic to generate authorization requests, obtain tokens for valid authorization codes and validate permission checks based on token contents or user information. Furthermore, authorization request and token request should be linked ideally through state. OAuth-service is expected to follow recommended best practices such as use of [PKCE](https://tools.ietf.org/html/rfc7636) and JWK validations where applicable.

## OAuth service implementation details

<details><summary>OAuth service Swagger documentation:</summary>
<p>

```
swagger: "2.0"
info:
  title: "Keptn OAuth service"
  description: "Service contract for OAuth service for Keptn instance."
  version: "1"
tags:
- name: "Service discovery"
  description: "Service discovery"
- name: "OAuth Service"
  description: "OAuth service endpoints"
schemes:
- "https"
paths:
  /discovery:
    get:
      tags:
      - "Service discovery"
      summary: "Discovery endpoint of this service"
      description: "Contains service discovery details to be used by Keptn bridge."
      produces:
      - "application/json"
      responses:
        "200":
          description: "Endpoints that are required for Keptn bridge"
          examples:
            application/json : {
              "authorization": "http://oauth-service:8080/authorization",
              "token_decision": "http://oauth-service:8080/token_decision"
            }
          schema:
            $ref: "#/definitions/Discovery"
  /authorization:
    get:
      tags:
      - "OAuth Service"
      summary: "Expose authorization URL"
      description: "Response contains the authorization request URL to be used by Keptn bridge. Redirect URL must refer to <KEPTN_BASE_PATH>/oauth/redirect"
      produces:
      - "application/json"
      responses:
        "200":
          description: "Successful authorization URL with correct OAuth 2.0/OpenID Connect values."
          examples:
            application/json : {
              "authorization_url": "http://idp.com/authorization?client_id=xyz&redirect_uri=http://keptn.com/oauth/redirect&scope=openid&state=123"
            }
          schema:
            $ref: "#/definitions/Authorization"
  /token_decision:
    post:
      tags:
      - "OAuth Service"
      summary: "Consume state & code from redirect and provide login decision"
      description: "Token decision endpoint will be called from bridge with code and state values that sent through authorization response."
      parameters:
      - in: "body"
        name: "Token decision payload"
        description: "Contains state and code"
        required: true
        schema:
          type: object
          required:
            - code
            - state
          properties:
            code:
              type: string
            state:
              type: string
      produces:
      - "application/json"
      responses:
        "200":
          description: "Successful login"
          examples:
            application/json : {
              "user": "USER_IDENTIFIER"
            }
          schema:
            $ref: "#/definitions/Success"
        "403":
          description: "User doesn't have permission"
          examples:
            application/json : {
              "message": "Invalid state parameter"
            }
          schema:
            $ref: "#/definitions/Forbidden"
definitions:
  Discovery:
    type: "object"
    required: 
    - "authorization"
    - "token_decision"
    properties:
      authorization:
        type: string
      token_decision:
        type: string
  Authorization:
    type: "object"
    required:
    - "authorization_url"
    properties:
      authorization_url:
        type: string
  Success:
    type: "object"
    required: 
    - "result"
    properties:
      user:
        type: string
        description: "User identifier. This can be name, email or any preferred user identifier"
  Forbidden:
    type: "object"
    properties:
      message:
        type: string
        description: "Explain the reason for failure."
```

</p>
</details> 

The Keptn Bridge expects the environment variable `OAUTH_DISCOVERY`. This must direct to a discovery endpoint with the following details:

1. Endpoint for authorization request generation - `authorization`
1. Endpoint to handle tokens and provide the login decision - `token_decision`

With above-mentioned keys, the following is a sample response of the discovery

```
Get http://oauth-service:8080/discovery

{
 "authorization": "http://oauth-service:8080/authorization",
 "token_decision": "http://oauth-service:8080/token_decision"
}
```

From the response, Keptn bridge identifies the specific endpoints it needs to consume. Following sections provide specific details of these endpoints.

### authorization endpoint

Generates an authorization request with correct values and return that with the key *authorization_url* 

```
Get http://oauth-service:8080/authorization

{
 "authorization_url": "http://idp.com/authorization?client_id=xyz&redirect_uri=http://keptn.com/oauth/redirect&scope=openid&state=123"
}
```

### token_decision endpoint

Consumes code and token of the authorization response and provides the login decision. For simplicity, following are the currently supported decisions:

1. HTTP 200 - Login is accepted
1. HTTP 403 - Login is unaccepted OR permission denied
1. Any other status - Considered as errors

Successful login example:

```
Post http://oauth-service:8080/token_decision
Content-Type: application/json
{
  "code": "qwert",
  "state": "123"
}

HTTP 200 OK
Content-Type: application/json
{
  "user": <USER_IDENTIFIER>
}
```

Unsuccessful login example:

```
Post http://oauth-service:8080/token_decision
Content-Type: application/json
{
  "code": "qwery",
  "state": "123"
}

HTTP 403 Forbidden
Content-Type: application/json
{
  "message": "User Alex does not have permission to login to Keptn."
}
```