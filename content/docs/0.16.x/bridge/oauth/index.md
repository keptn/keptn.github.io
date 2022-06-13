---
title: OpenID Authentication
description: Enable/Disable OpenID authentication and implementation details for the identity provider
weight: 20
keywords: [0.11.x-bridge]
aliases:
  - /docs/0.11.x/operate/user_management/openid_authentication/
---

## Enable/Disable Authentication

The Keptn Bridge contains a switch to enable/disable OpenID Connect-based authentication. This switch also enables session cookies.

You can enable/disable OpenID via the Helm Chart values when installing Keptn setting `enabled` to `true`:

```
bridge:
  ...
  oauth:
    enabled: false
    discovery: ""
    secureCookie: false
    trustProxy: ""
    baseUrl: ""
    clientID: ""
    clientSecret: ""
    IDTokenAlg: ""
    scope: ""
    userIdentifier: ""
```

Furthermore, additional values are required for OpenID to work:

- `baseUrl` - URL of the bridge (e.g. `http://localhost:3000` or `https://myBridgeInstallation.com`).
- `discovery` - Discovery URL of the identity provider (e.g. <https://api.login.yahoo.com/.well-known/openid-configuration>).
- `clientID` - Client ID, provided by the identity provider.
- `clientSecret` (optional) - Client secret, provided by the identity provider.
- `IDTokenAlg` (optional) - Algorithm that is used to verify the ID token (e.g. `ES256`). Default is `RS256`.
- `scope` (optional) - Additional scopes that should be added to the authentication flow (e.g. `profile email`), separated by space.
- `userIdentifier` (optional) - The property of the ID token that identifies the user. Default is `name` and fallback to `nickname`, `preferred_username` and `email`.

## Authentication flow with the identity provider

The following diagram shows the expected authentication flow with a custom identity provider that follows the implementation details explained below.

{{< popup_image
link="./assets/oauth-flow.png"
caption="Authentication flow with identity provider" width="800px">}}

Keptn Bridge checks the existence of the identity provider and also validates responses obtained from it. For example, the following are requests and responses the Keptn Bridge can expect from the identity provider.

*To obtain discovery request:*

```
Bridge Request :

   GET <identity_provider>/.well-known/openid-configuration

OIDC Provider Response :

  {
   "issuer": <issuer>,
   "authorization_endpoint": <authorization_endpoint>,
   "token_endpoint": <token_endpoint>,
   "jwks_uri": <jwks_endpoint>,
   "end_session_endpoint": <end_session_endpoint>
  }
```

*To validate authorization code & permissions:*

```
Bridge Request :

   POST <token_endpoint>

   {
     "state" : <state>,
     "code" : <authorization_code>,
     "scope": "openid",
     "client_id": <client_id>,
     "client_secret": <client_secret>, 
     "nonce": <nonce>,
     "code_verifier": <code_verifier>
   }

OIDC Provider Response :

  {
   "id_token": <id_token>,
   "access_token": <access_token>,
   "refresh_token": <refresh_token>,
   "expires_in": <expires_in>
  }
```

The identity provider must implement logic to:

- generate authorization requests,
- obtain tokens for valid authorization codes, and
- validate permission checks based on token contents or user information.
  Furthermore, authorization requests and token requests should be linked ideally through state, nonce, code challenge, and code verifier. The identity provider is expected to follow recommended best practices such as [PKCE](https://tools.ietf.org/html/rfc7636) and JWK validations where applicable.

## OpenID implementation details

<details><summary>OpenID Swagger documentation:</summary>
<p>

```
swagger: "2.0"
info:
  title: "Keptn Identity Provider"
  description: "Service contract for the identity provider for Keptn instance."
  version: "1"
tags:
- name: "Identity Provider"
  description: "Identity provider endpoints"
schemes:
- "https"
paths:
  /discovery:
    get:
      tags:
      - "Identity Provider"
      summary: "Discovery endpoint of this identity provider"
      description: "Contains discovery details to be used by Keptn bridge."
      produces:
      - "application/json"
      responses:
        "200":
          description: "Endpoints that are required for Keptn bridge"
          examples:
            application/json : {
              "issuer": "http://identity-provider:8080",
              "authorization_endpoint": "http://identity-provider:8080/authorization",
              "token_endpoint": "http://identity-provider:8080/token_decision",
              "jwks_uri": "http://identity-provider:8080/jwks",
              "end_session_endpoint": "http://identity-provider:8080/end_session",
            }
          schema:
            $ref: "#/definitions/Discovery"
  /token_endpoint:
    post:
      tags:
      - "Identity Provider"
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
            - client_id
            - code_verifier
            - nonce
          properties:
            code:
              type: string
            state:
              type: string
            scope:
              type: string
            client_id:
              type: string
            client_secret:
              type: string
            nonce:
              type: string
            code_verifier:
              type: string
      produces:
      - "application/json"
      responses:
        "200":
          description: "Successful login"
          examples:
            application/json : {
              "id_token": "ID_TOKEN",
              "access_token": "ACCESS_TOKEN",
              "refresh_token": "REFRESH_TOKEN",
              "expires_in": "EXPIRES_IN"
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
  /jwks_uri:
    get:
      tags:
      - "Identity Provider"
      summary: "Returns JSON Web key set"
      produces:
      - "application/json"
      responses:
        "200":
          description: "JSON Web key set fetched"
          examples:
            application/json : {
              "keys": [
                {
                  "alg": "ALG",
                  "e": "E",
                  "kid": "KID",
                  "kty": "KTY",
                  "n": "N",
                  "use": "USE",
                }
              ]
            }
          schema:
            $ref: "#/definitions/Jwks"
definitions:
  Discovery:
    type: "object"
    required: 
    - "issuer"
    - "authorization_endpoint"
    - "token_endpoint"
    - "jwks_uri"
    properties:
      issuer:
        type: string
      authorization_endpoint:
        type: string
      token_endpoint:
        type: string
      jwks_uri:
        type: string
      end_session_endpoint:
        type: string
  Jwks:
    type: "object"
    required:
    - "keys"
    properties:
      keys:
        type: array
        items:
          $ref: "#/definitions/Jwks_key"
  Jwks_key:
    type: "object"
    properties:
      alg:
        type: string
      e:
        type: string
      kid:
        type: string
      kty:
        type: string
      n:
        type: string
      use:
        type: string
  Success:
    type: "object"
    required: 
    - "id_token"
    - "access_token"
    - "refresh_token"
    - "expires_in"
    properties:
      id_token:
        type: string
      access_token:
        type: string
      refresh_token:
        type: string
      expires_in:
        type: number
  Forbidden:
    type: "object"
    properties:
      message:
        type: string
        description: "Explain the reason for failure."
```

</p>
</details>

When enabled, the Keptn Bridge expects the environment variable `OAUTH_DISCOVERY` to be correctly set. This must direct to a discovery endpoint with the following details:

1. Endpoint for authorization request generation - `authorization_endpopint`.
2. Endpoint to handle tokens and provide the login decision - `token_endpoint`.
3. Endpoint to fetch JSON Web key set to validate the ID token - `jwks_uri`.
4. (optional) Endpoint to handle the logout - `end_session_endpoint`.

With above-mentioned keys, the following is a sample response of the discovery

```
GET http://identity-provider:8080/.well-known/openid-configuration

{
 "authorization_endpoint": "http://identity-provider:8080/authorization",
 "token_endpoint": "http://identity-provider:8080/token_decision"
 "jwks_uri": "http://identity-provider:8080/jwks"
}
```

From the response, Keptn bridge identifies the specific endpoints it needs to consume. The following sections provide specific details of these endpoints.

### authorization endpoint

It generates an authentication code and redirects to the given redirect URI.

The following query parameters must be supported:

- client_id
- redirect_uri
- scope
- state
- nonce
- code_challenge
- code_challenge_method

### token endpoint

It consumes the `code` and `state` of the authorization response and the `scope`, `redirect_uri`, `client_id` and optionally the `client_secret` and provides the login decision. For simplicity, the following are the currently supported decisions:

1. HTTP 200 - Login is accepted
1. HTTP 403 - Login is unaccepted OR permission denied
1. Any other status - Considered as errors

Successful login example:

```
POST http://identity-provider:8080/token_decision
Content-Type: application/json
{
  "code": "qwert",
  "state": "123",
  "scope": "openid",
  "redirect_uri": "https://example.com/oauth/redirect,
  "client_id": "asdfxyz"
}

HTTP 200 OK
Content-Type: application/json
{
  "id_token": <id_token>,
  "access_token": <access_token>,
  "refresh_token": <refresh_token>,
  "expires_in": <expires_in>
}
```

Unsuccessful login example:

```
POST http://identity-provider:8080/token_decision
Content-Type: application/json
{
  "code": "qwery",
  "state": "123",
  "scope": "openid",
  "redirect_uri": "https://example.com/oauth/redirect,
  "client_id": "asdfxyz"
}

HTTP 403 Forbidden
Content-Type: application/json
{
  "message": "User Alex does not have permission to login to Keptn."
}
```

### jwks_uri endpoint

It contains a set of JSON Web Keys that are used for validating the received id token.

```
GET http://identity-provider:8080/jwks_endpoint

HTTP 200 OK
Content-Type: application/json
{
  "keys": [
    {
      "kty": "RSA",
      "use": "sig",
      "kid": "abcde",
      "n": "xyz",
      "e": "AQAB",
      "x5c": [
        "asdf"
      ]
    }
  ]
}
```
