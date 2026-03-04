# 3.2. WebRTC Registration

This part of the call flow covers WebRTC registration.

## 3.2.1. WebRTC Registrations
### 3.2.1.1. Sequence

![fig1](./webrtc_registration_fig1.png)

### 3.2.1.2. Example messages

#### [6] POST /webrtc-registration/{apiVersion}/sessions
```
POST /webrtc-registration/v0.3/sessions HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-ef1234567890

{
  "deviceId": "7d444840-9dc0-11d1-b245-5ffdce74fad2",
  "registrationExpireTime": "2025-12-31T23:59:59.999Z"
}
```

> **NOTE**
>
> Depending on the WebRTC registration, SIP REGISTER may either be omitted or performed:
> 
> - When the Telco network assigns specific phone number ranges to the WebRTC Gateway and accepts SIP INVITE for call routing, SIP REGISTER is omitted.
> - When a SIP account is issued for each phone number used for interworking from WebRTC, SIP REGISTER is performed.
> 
> Even when SIP REGISTER is performed, it should be noted that the WebRTC Gateway does not have a SIM and therefore cannot use AKA′ authentication, making it different from IMS UE Registration.




#### [9] 200 OK
```
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: a1b2c3d4-e5f6-7890-abcd-ef1234567890

{
  "registrationId": "reg-12345678-abcd-ef90-1234-567890abcdef",
  "regInfo": {
    "phoneNumber": "+123456789",
    "regStatus": "Registered"
  },
  "expiresAt": "2025-12-31T23:59:59.999Z"
}
```

> **NOTE**
>
> The API Provider may define minimum, maximum, and default values for the WebRTC registration validity period. If the requested duration ("registrationExpireTime" - currentTime) is within the acceptable range, 'expiredAt' may be set to the requested value.
>
> Otherwise, the API Provider may either use (currentTime + default value) for 'expiredAt' or return an error.


## 3.2.2. Refresh WebRTC Registrations
### 3.2.2.1. Sequence

![fig2](./webrtc_registration_fig2.png)

### 3.2.2.2. Example messages

#### [15] PUT /webrtc-registration/{apiVersion}/sessions/{registrationId}
```
PUT /webrtc-registration/v0.3/sessions/reg-12345678-abcd-ef90-1234-567890abcdef HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: b2c3d4e5-f6a7-8901-bcde-f23456789012

{
  "registrationExpireTime": "2026-01-15T12:00:00.000Z"
}
```

> **ISSUE** (UnderDiscussion)
> 
> Related Issue: #144
>
> Related PR: #NN
>
> The description of the expiration time after update in the PUT operation only considers the case where the API Consumer does not specify a desired expiration time in the PUT request. The description needs to be revised.
>
> Informational descriptions for above need to be revised in webrtc-registration.yaml.

> **ISSUE** (UnderDiscussion)
> 
> Related Issue: #145
>
> Related PR: #NN
>
> PUT (update) should be used by the API Consumer to request refreshing existing WebRTC registrations before expiration based on monitoring expiredAt, while POST (new registration) should be used after receiving registration-ends. 
>
> Informational descriptions for above need to be added in webrtc-registration.yaml for clarification.

> **ISSUE** (UnderDiscussion)
> 
> Related Issue: #146
>
> Related PR: #NN
>
> When registration expires, initiating new calls (both incoming and outgoing) is no longer possible. The following behaviors need clarification:
> - Should ongoing media sessions be disconnected?
> - Should any remaining WebRTC event subscription resources associated with the related deviceId be deleted?
>
> If these behaviors are not implementation-dependent, they should be documented as informational descriptions in the webrtc-registration.yaml or webrtc-events.yaml to clarify the expected behavior.

#### [18] 200 OK
```
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: b2c3d4e5-f6a7-8901-bcde-f23456789012

{
  "regInfo": {
    "phoneNumber": "+123456789",
    "regStatus": "Registered"
  },
  "registrationId": "reg-12345678-abcd-ef90-1234-567890abcdef",
  "expiresAt": "2026-01-15T12:00:00.000Z"
}
```

## 3.2.3. WebRTC De-Registrations
### 3.2.3.1. Sequence

![fig3](./webrtc_registration_fig3.png)

### 3.2.3.2. Example messages

#### [24] DELETE /webrtc-registration/{apiVersion}/sessions/{registrationId}
```
DELETE /webrtc-registration/v0.3/sessions/reg-12345678-abcd-ef90-1234-567890abcdef HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: c3d4e5f6-a7b8-9012-cdef-345678901234
```

#### [27] 204 No Content
```
HTTP/1.1 204 No Content
x-correlator: c3d4e5f6-a7b8-9012-cdef-345678901234
```


