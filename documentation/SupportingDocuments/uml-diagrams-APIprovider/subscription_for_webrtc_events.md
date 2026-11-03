# 3.1. Subscription for WebRTC events

This part of the call flow covers subscribing, unsubscribing, and updating subscriptions for WebRTC events.

## 3.1.1. Event Subscriptions

### 3.1.1.1. Sequence

```mermaid
sequenceDiagram

    box Device
        participant DA as Device<br/>Application
    end

    box Application Service Provider
        participant AS as Application<br/>Server
    end

    box Operator Network
        participant AUTH as Auth<br/>Server
        participant WG as WebRTC<br/>Gateway
        participant TN as Telco<br/>Network
    end

    box Device
        participant RE as Remote<br/>Endpoint
    end

    DA->>AS: [1] Accessing ASP entry point<br/>(incl. AuthN & AuthZ)
    AS->>DA: [2] Activate Device Application
    activate DA

    AS->>AUTH: [3] GET /authorize

    AUTH-->>AS: [4] 302 Found<br/>(redirecting user agent)

    Note over DA,AUTH: [5] End user consent (e.g. ICM Auth Code Flow)

    AS->>AUTH: [6] POST /token

    AUTH-->>AS: [7] 200 OK

    AS->>WG: [8] POST /webrtc-events-subscriptions/{apiVersion}/subscriptions
    
    WG->>AUTH: [9] POST /token/introspection

    AUTH-->>WG: [10] 200 OK

    WG-->>AS: [11] 201 Created
    activate WG

    deactivate DA
    deactivate WG
```

### 3.1.1.2. Example messages

#### [3] GET /authorize

```http
GET /authorize?response_type=code
    &client_id=asp-webrtc-app-001
    &redirect_uri=https%3A%2F%2Fasp.example.com%2Fcallback
    &scope=openid%20webrtc-events-subscriptions%3Aorg.camaraproject.webrtc-events-subscriptions.v0.session-invitation%3Acreate%20webrtc-events-subscriptions%3Aorg.camaraproject.webrtc-events-subscriptions.v0.session-status%3Acreate%20webrtc-events-subscriptions%3Aorg.camaraproject.webrtc-events-subscriptions.v0.registration-ended%3Acreate
    &state=af0ifjsldkj
    &code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM
    &code_challenge_method=S256 HTTP/1.1
Host: auth.operator.com
```

#### [4] 302 Found

```http
HTTP/1.1 302 Found
Location: https://asp.example.com/callback?code=SplxlOBeZQQYbYS6WxSbIA&state=af0ifjsldkj
```

#### [6] POST /token

```http
POST /token HTTP/1.1
Host: auth.operator.com
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&code=SplxlOBeZQQYbYS6WxSbIA
&redirect_uri=https%3A%2F%2Fasp.example.com%2Fcallback
&code_verifier=dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk
```

#### [7] 200 OK

```http
HTTP/1.1 200 OK
Content-Type: application/json
Cache-Control: no-store

{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2F1dGgub3BlcmF0b3IuY29tIiwic3ViIjoiKzEyMzQ1Njc4OTAiLCJhdWQiOiJhc3Atd2VicnRjLWFwcC0wMDEiLCJleHAiOjE3MzQyNzI2MDAsImlhdCI6MTczNDI2OTAwMCwic2NvcGUiOiJvcGVuaWQgd2VicnRjLWV2ZW50cy1zdWJzY3JpcHRpb25zOm9yZy5jYW1hcmFwcm9qZWN0LndlYnJ0Yy1ldmVudHMtc3Vic2NyaXB0aW9ucy52MC5zZXNzaW9uLWludml0YXRpb246Y3JlYXRlIHdlYnJ0Yy1ldmVudHMtc3Vic2NyaXB0aW9uczpvcmcuY2FtYXJhcHJvamVjdC53ZWJydGMtZXZlbnRzLXN1YnNjcmlwdGlvbnMudjAuc2Vzc2lvbi1zdGF0dXM6Y3JlYXRlIHdlYnJ0Yy1ldmVudHMtc3Vic2NyaXB0aW9uczpvcmcuY2FtYXJhcHJvamVjdC53ZWJydGMtZXZlbnRzLXN1YnNjcmlwdGlvbnMudjAucmVnaXN0cmF0aW9uLWVuZHM6Y3JlYXRlIn0.signature",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "tGzv3JOkF0XG5Qx2TlKWIA",
  "id_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2F1dGgub3BlcmF0b3IuY29tIiwic3ViIjoiYWJjZDEyMzQiLCJhdWQiOiJhc3Atd2VicnRjLWFwcC0wMDEiLCJleHAiOjE3MzQyNzI2MDAsImlhdCI6MTczNDI2OTAwMCwibm9uY2UiOiJuLTBTNl9XekEyTWoifQ.signature"
}
```

#### [8] POST /webrtc-events-subscriptions/{apiVersion}/subscriptions

```http
POST /webrtc-events-subscriptions/{apiVersion}/subscriptions HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: b4333c46-49c0-4f62-80d7-f0ef930f1c46

{
  "protocol": "HTTP",
  "sink": "https://asp.example.com/webhooks/webrtc",
  "sinkCredential": {
    "credentialType": "ACCESSTOKEN",
    "accessToken": "eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.abc123",
    "accessTokenExpiresUtc": "2025-12-20T23:59:59.999Z",
    "accessTokenType": "bearer"
  },
  "types": [
    "org.camaraproject.webrtc-events-subscriptions.v0.session-invitation",
    "org.camaraproject.webrtc-events-subscriptions.v0.session-status",
    "org.camaraproject.webrtc-events-subscriptions.v0.registration-ended"
  ],
  "config": {
    "subscriptionDetail": {
      "deviceId": "7d444840-9dc0-11d1-b245-5ffdce74fad2"
    },
    "subscriptionExpireTime": "2025-12-31T23:59:59.999Z"
  }
}
```

#### [11] 201 Created

```http
HTTP/1.1 201 Created
Content-Type: application/json
x-correlator: b4333c46-49c0-4f62-80d7-f0ef930f1c46

{
  "protocol": "HTTP",
  "sink": "https://notificationServer.example.com/webhooks/webrtc",
  "types": [
    "org.camaraproject.webrtc-events-subscriptions.v0.session-invitation",
    "org.camaraproject.webrtc-events-subscriptions.v0.session-status",
    "org.camaraproject.webrtc-events-subscriptions.v0.registration-ended"
  ],
  "config": {
    "subscriptionDetail": {
      "deviceId": "7d444840-9dc0-11d1-b245-5ffdce74fad2"
    },
    "subscriptionExpireTime": "2025-12-31T23:59:59.999Z"
  },
  "id": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "startsAt": "2025-12-15T10:30:00.000Z",
  "expiresAt": "2025-12-31T23:59:59.999Z",
  "status": "ACTIVE"
}
```

## 3.1.2. Refresh event subscriptions

### 3.1.2.1. Sequence

```mermaid
sequenceDiagram

    box Device
        participant DA as Device<br/>Application
    end

    box Application Service Provider
        participant AS as Application<br/>Server
    end

    box Operator Network
        participant AUTH as Auth<br/>Server
        participant WG as WebRTC<br/>Gateway
        participant TN as Telco<br/>Network
    end

    box Device
        participant RE as Remote<br/>Endpoint
    end

    activate DA
    activate WG

    DA->>AS: [12] Event subscription update request

    AS->>AUTH: [13] GET /authorize

    AUTH-->>AS: [14] 302 Found<br/>(redirecting user agent)

    Note over DA,AUTH: [15] End user consent (e.g. ICM Auth Code Flow)

    AS->>AUTH: [16] POST /token

    AUTH-->>AS: [17] 200 OK

    AS->>WG: [18] PUT /webrtc-events-subscriptions/{apiVersion}/subscriptions/{subscriptionId}

    WG->>AUTH: [19] POST /token/introspection

    AUTH-->>WG: [20] 200 OK

    WG-->>AS: [21] 200 OK

    AS->>DA: [22] Event subscription update result

    deactivate DA
    deactivate WG
```

### 3.1.2.2. Example messages

#### [18] PUT /webrtc-events-subscriptions/{apiVersion}/subscriptions/{subscriptionId}

```http
PUT /webrtc-events-subscriptions/{apiVersion}/subscriptions/sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890 HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: f8e7d6c5-b4a3-2190-fedc-ba0987654321

{
  "sinkCredential": {
    "credentialType": "ACCESSTOKEN",
    "accessToken": "eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.xyz789",
    "accessTokenExpiresUtc": "2026-01-20T23:59:59.999Z",
    "accessTokenType": "bearer"
  },
  "config": {
    "subscriptionDetail": {
      "deviceId": "7d444840-9dc0-11d1-b245-5ffdce74fad2"
    },
    "subscriptionExpireTime": "2026-01-31T23:59:59.999Z"
  }
}
```

#### [21] 200 OK

```http
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: f8e7d6c5-b4a3-2190-fedc-ba0987654321

{
  "protocol": "HTTP",
  "sink": "https://asp.example.com/webhooks/webrtc",
  "types": [
    "org.camaraproject.webrtc-events-subscriptions.v0.session-invitation",
    "org.camaraproject.webrtc-events-subscriptions.v0.session-status",
    "org.camaraproject.webrtc-events-subscriptions.v0.registration-ended"
  ],
  "config": {
    "subscriptionDetail": {
      "deviceId": "7d444840-9dc0-11d1-b245-5ffdce74fad2"
    },
    "subscriptionExpireTime": "2026-01-31T23:59:59.999Z"
  },
  "id": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "startsAt": "2025-12-15T10:30:00.000Z",
  "expiresAt": "2026-01-31T23:59:59.999Z",
  "status": "ACTIVE"
}
```

## 3.1.3. Unsubscribe from events

### 3.1.3.1. Sequence

```mermaid
sequenceDiagram

    box Device
        participant DA as Device<br/>Application
    end

    box Application Service Provider
        participant AS as Application<br/>Server
    end

    box Operator Network
        participant AUTH as Auth<br/>Server
        participant WG as WebRTC<br/>Gateway
        participant TN as Telco<br/>Network
    end

    box Device
        participant RE as Remote<br/>Endpoint
    end

    activate DA
    activate WG

    DA->>AS: [23] Event subscription delete request

    AS->>AUTH: [24] GET /authorize

    AUTH-->>AS: [25] 302 Found<br/>(redirecting user agent)

    Note over DA,AUTH: [26] End user consent (e.g. ICM Auth Code Flow)

    AS->>AUTH: [27] POST /token

    AUTH-->>AS: [28] 200 OK

    AS->>WG: [29] DELETE /webrtc-events-subscriptions/{apiVersion}/subscriptions/{subscriptionId}

    WG->>AUTH: [30] POST /token/introspection

    AUTH-->>WG: [31] 200 OK

    WG-->>AS: [32] 202 Accepted

    WG->>AS: [33] POST SINK_URL

    AS->>DA: [34] Event subscription delete result

    AS-->>WG: [35] 204 No Content
    deactivate WG

    deactivate DA

```

### 3.1.3.2. Example messages

#### [29] DELETE /webrtc-events-subscriptions/{apiVersion}/subscriptions/{subscriptionId}

```http
DELETE /webrtc-events-subscriptions/{apiVersion}/subscriptions/sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890 HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-ef1234567890
```

#### [32] 202 Accepted

```http
HTTP/1.1 202 Accepted
Content-Type: application/json
x-correlator: a1b2c3d4-e5f6-7890-abcd-ef1234567890

{
  "id": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890"
}
```

#### [33] POST {sink} (callback)

```http
POST /webhooks/webrtc HTTP/1.1
Host: asp.example.com
Content-Type: application/cloudevents+json
Authorization: Bearer eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.xyz789
x-correlator: b2c3d4e5-f6a7-8901-bcde-f23456789012

{
  "id": "evt-9a8b7c6d-5e4f-3210-fedc-ba9876543210",
  "source": "https://api.example.com/webrtc-events-subscriptions/{apiVersion}",
  "type": "org.camaraproject.webrtc-events-subscriptions.v0.subscription-ended",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "time": "2025-12-15T14:30:00.000Z",
  "data": {
    "subscriptionId": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "terminationReason": "SUBSCRIPTION_DELETED",
    "terminationDescription": "Subscription deleted by client request"
  }
}
```

#### [35] 204 No Content (callback response)

```http
HTTP/1.1 204 No Content
x-correlator: b2c3d4e5-f6a7-8901-bcde-f23456789012

```
