# 3.3. Call origination and disconnection

This part of the call flows cover call origination from Application Server as WebRTC API Invoker.

In the call flows, the interface between the WebRTC Gateway and the Telco Network is a SIP-based NNI (Network-to-Network Interface). As such, IMS access-layer procedures (e.g., resource reservation, precondition) are out of scope, while reliable provisional responses (100rel / PRACK) are assumed to be supported on the NNI.

## 3.3.1. Call origination
### 3.3.1.1. Call flow

![fig1](./call_origination_and_disconnection_fig-1.png)

### 3.3.1.2. Example messages

#### [7] POST /webrtc-call-handling/v0.3/sessions
```http
POST /webrtc-call-handling/v0.3/sessions HTTP/1.1
Host: webrtc-gw.operator.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000007
registrationId: reg-550e8400-e29b-41d4-a716-446655440000

{
  "originatorAddress": "tel:+818000000001",
  "originatorName": "Alice",
  "receiverAddress": "tel:+818000000002",
  "receiverName": "Bob",
  "offer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  }
}
```

> **ISSUE** (NotAddressed)
> 
> Related Issue: #NN
>
> Related PR: #NN
>
> The current API definition uses a single MediaSessionInformation schema as the message body across multiple operations (POST request/response, GET response, and PUT request/response). However, the set of required properties varies depending on the operation context. This overloading of a single schema reduces clarity and may lead to ambiguity for API consumers regarding which fields are mandatory in each operation.
> 
> It is proposed to define distinct schema types corresponding to each operation context (e.g., CreateMediaSessionRequest, CreateMediaSessionResponse, MediaSessionInfo, UpdateMediaSessionRequest, UpdateMediaSessionResponse) in webrtc-callhandling.yaml, and update the $ref references in each operation accordingly.


#### [10] SIP INVITE
```
INVITE sip:+818000000002@tn.operator.com;user=phone SIP/2.0
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776asdhds
Max-Forwards: 70
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 INVITE
Contact: <sip:webrtc-gw.operator.com:5060;transport=tcp>
Supported: 100rel, timer
Allow: INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, OPTIONS
Content-Type: application/sdp
Content-Length: 266

v=0
o=- 8066321617929821805 2 IN IP4 webrtc-gw.operator.com
s=WebRTC-to-SIP Call
c=IN IP4 203.0.113.100
t=0 0
m=audio 30000 RTP/AVP 0 8 101
a=rtpmap:0 PCMU/8000
a=rtpmap:8 PCMA/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=sendrecv
a=ptime:20
```

#### [13] SIP 100 Trying
```
SIP/2.0 100 Trying
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776asdhds;received=203.0.113.100
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 INVITE
Content-Length: 0
```

#### [14] 201 Created
```http
HTTP/1.1 201 Created
Content-Type: application/json
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000007

{
  "originatorAddress": "tel:+818000000001",
  "originatorName": "Alice",
  "receiverAddress": "tel:+818000000002",
  "receiverName": "Bob",
  "status": "Initial",
  "offer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "mediaSessionId": "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF"
}
```

#### [17] SIP 183 Session Progress
```
SIP/2.0 183 Session Progress
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776asdhds;received=203.0.113.100
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 INVITE
Contact: <sip:+818000000002@198.51.100.10:5060;transport=tcp>
Require: 100rel
RSeq: 1
Content-Type: application/sdp
Content-Length: 223

v=0
o=- 4576312012535546667 2 IN IP4 198.51.100.10
s=SIP Call
c=IN IP4 198.51.100.10
t=0 0
m=audio 49170 RTP/AVP 0 101
a=rtpmap:0 PCMU/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=sendrecv
a=ptime:20
```

#### [18] POST SINK_URL
```http
POST /webhooks/webrtc HTTP/1.1
Host: asp.example.com
Content-Type: application/cloudevents+json
Authorization: Bearer eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000016

{
  "id": "evt-183-f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "source": "https://webrtc-gw.operator.com",
  "type": "org.camaraproject.webrtc-events.v0.session-status",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "time": "2025-02-05T10:30:01.123Z",
  "data": {
    "subscriptionId": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mediaSessionId": "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF",
    "originatorAddress": "tel:+818000000001",
    "originatorName": "Alice",
    "receiverAddress": "tel:+818000000002",
    "receiverName": "Bob",
    "status": "InProgress",
    "offer": {
      "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
    },
    "answer": {
      "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
    },
    "reason": "183 Session Progress received from remote endpoint",
    "sequenceNumber": 1
  }
}
```

#### [20] 204 No Content
```http
HTTP/1.1 204 No Content
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000016
```

#### [21] SIP PRACK
```
PRACK sip:+818000000002@198.51.100.10:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776prack1
Max-Forwards: 70
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 2 PRACK
RAck: 1 1 INVITE
Content-Length: 0
```

#### [24] SIP 200 OK (PRACK)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776prack1;received=203.0.113.100
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 2 PRACK
Content-Length: 0
```

#### [30] SIP 180 Ringing
```
SIP/2.0 180 Ringing
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776asdhds;received=203.0.113.100
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 INVITE
Contact: <sip:+818000000002@198.51.100.10:5060;transport=tcp>
Require: 100rel
RSeq: 2
Content-Length: 0
```

#### [31] POST SINK_URL
```http
POST /webhooks/webrtc HTTP/1.1
Host: asp.example.com
Content-Type: application/cloudevents+json
Authorization: Bearer eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000027

{
  "id": "evt-180-a8b9c0d1-e2f3-4456-b789-0a1b2c3d4e5f",
  "source": "https://webrtc-gw.operator.com",
  "type": "org.camaraproject.webrtc-events.v0.session-status",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "time": "2025-02-05T10:30:02.456Z",
  "data": {
    "subscriptionId": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mediaSessionId": "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF",
    "originatorAddress": "tel:+818000000001",
    "originatorName": "Alice",
    "receiverAddress": "tel:+818000000002",
    "receiverName": "Bob",
    "status": "Ringing",
    "reason": "180 Ringing received from remote endpoint",
    "sequenceNumber": 2
  }
}
```

#### [33] 204 No Content
```http
HTTP/1.1 204 No Content
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000027
```

#### [34] SIP PRACK
```
PRACK sip:+818000000002@198.51.100.10:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776prack2
Max-Forwards: 70
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 3 PRACK
RAck: 2 1 INVITE
Content-Length: 0
```

#### [37] SIP 200 OK (PRACK)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776prack2;received=203.0.113.100
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 3 PRACK
Content-Length: 0
```

#### [39] SIP 200 OK (INVITE)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776asdhds;received=203.0.113.100
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 INVITE
Contact: <sip:+818000000002@198.51.100.10:5060;transport=tcp>
Allow: INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, OPTIONS
Supported: 100rel, timer
Content-Type: application/sdp
Content-Length: 223

v=0
o=- 4576312012535546667 4 IN IP4 198.51.100.10
s=SIP Call
c=IN IP4 198.51.100.10
t=0 0
m=audio 49170 RTP/AVP 0 101
a=rtpmap:0 PCMU/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=sendrecv
a=ptime:20
```

#### [40] POST SINK_URL
```http
POST /webhooks/webrtc HTTP/1.1
Host: asp.example.com
Content-Type: application/cloudevents+json
Authorization: Bearer eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000035

{
  "id": "evt-200-c4d5e6f7-8901-2345-6789-abcdef012345",
  "source": "https://webrtc-gw.operator.com",
  "type": "org.camaraproject.webrtc-events.v0.session-status",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "time": "2025-02-05T10:30:05.789Z",
  "data": {
    "subscriptionId": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mediaSessionId": "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF",
    "originatorAddress": "tel:+818000000001",
    "originatorName": "Alice",
    "receiverAddress": "tel:+818000000002",
    "receiverName": "Bob",
    "status": "Connected",
    "offer": {
      "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
    },
    "answer": {
      "sdp": "v=0\r\no=- 7893214567890123456 4 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
    },
    "reason": "200 OK received - call connected",
    "sequenceNumber": 3
  }
}
```

#### [42] 204 No Content
```http
HTTP/1.1 204 No Content
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000035
```

#### [43] SIP ACK
```
ACK sip:+818000000002@198.51.100.10:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776ack1
Max-Forwards: 70
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 ACK
Content-Length: 0
```







## 3.3.2. Call termination by call originator
### 3.3.2.1. Sequence

![fig2](./call_origination_and_disconnection_fig-2.png)

### 3.3.2.2. Example messages

#### [53] DELETE /webrtc-call-handling/v0.3/sessions/{mediaSessionId}
```http
DELETE /webrtc-call-handling/v0.3/sessions/0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF HTTP/1.1
Host: webrtc-gw.operator.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000051
```

#### [56] 204 No Content
```http
HTTP/1.1 204 No Content
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000051
```

#### [57] SIP BYE
```
BYE sip:+818000000002@198.51.100.10:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776bye1
Max-Forwards: 70
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 4 BYE
Content-Length: 0
```

#### [60] SIP 200 OK (BYE)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP webrtc-gw.operator.com:5060;branch=z9hG4bK776bye1;received=203.0.113.100
From: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
To: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 4 BYE
Content-Length: 0
```

#### [61] POST SINK_URL
```http
POST /webhooks/webrtc HTTP/1.1
Host: asp.example.com
Content-Type: application/cloudevents+json
Authorization: Bearer eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000059

{
  "id": "evt-bye-d5e6f7a8-b901-2345-6789-abcdef012345",
  "source": "https://webrtc-gw.operator.com",
  "type": "org.camaraproject.webrtc-events.v0.session-status",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "time": "2025-02-05T10:35:00.123Z",
  "data": {
    "subscriptionId": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mediaSessionId": "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF",
    "originatorAddress": "tel:+818000000001",
    "originatorName": "Alice",
    "receiverAddress": "tel:+818000000002",
    "receiverName": "Bob",
    "status": "Terminated",
    "reason": "Call terminated by originator",
    "sequenceNumber": 4
  }
}
```

#### [63] 204 No Content
```http
HTTP/1.1 204 No Content
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000059
```

## 3.3.3. Call termination by call receiver
### 3.3.3.1. Sequence

![fig3](./call_origination_and_disconnection_fig-3.png)

### 3.3.3.2. Example messages

#### [48] SIP BYE
```
BYE sip:webrtc-gw.operator.com:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889bye1
Max-Forwards: 70
From: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 BYE
Content-Length: 0
```

#### [49] SIP 200 OK (BYE)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889bye1;received=198.51.100.10
From: <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: "Alice" <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: a84b4c76e66710@webrtc-gw.operator.com
CSeq: 1 BYE
Content-Length: 0
```

#### [51] POST SINK_URL
```http
POST /webhooks/webrtc HTTP/1.1
Host: asp.example.com
Content-Type: application/cloudevents+json
Authorization: Bearer eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000049

{
  "id": "evt-bye-e6f7a8b9-c012-3456-7890-abcdef123456",
  "source": "https://webrtc-gw.operator.com",
  "type": "org.camaraproject.webrtc-events.v0.session-status",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "time": "2025-02-05T10:35:00.456Z",
  "data": {
    "subscriptionId": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mediaSessionId": "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF",
    "originatorAddress": "tel:+818000000001",
    "originatorName": "Alice",
    "receiverAddress": "tel:+818000000002",
    "receiverName": "Bob",
    "status": "Terminated",
    "reason": "Call terminated by receiver",
    "sequenceNumber": 4
  }
}
```

#### [53] 204 No Content
```http
HTTP/1.1 204 No Content
x-correlator: a1b2c3d4-e5f6-7890-abcd-000000000049
```







