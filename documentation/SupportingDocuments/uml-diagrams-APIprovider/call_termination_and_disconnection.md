# 3.4. Call termination and disconnection

This part of the call flows cover call termination to Application Server as WebRTC API Invoker, where the call is originated from the SIP side.

In the call flows, the interface between the WebRTC Gateway and the Telco Network is a SIP-based NNI (Network-to-Network Interface). As such, IMS access-layer procedures (e.g., resource reservation, precondition) are out of scope, while reliable provisional responses (100rel / PRACK) are assumed to be supported on the NNI.

It is assumed that the WebRTC side has already completed event subscription and WebRTC Registration prior to this flow.

## 3.4.1. Call termination
### 3.4.1.1. Call flow

![fig1](./call_termination_and_disconnection_fig-1.png)

### 3.4.1.2. Example messages

#### [2] SIP INVITE
```
INVITE sip:+818000000001@operator.com;user=phone SIP/2.0
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889inv1
Max-Forwards: 70
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 1 INVITE
Contact: <sip:+818000000002@198.51.100.10:5060;transport=tcp>
Supported: 100rel, timer
Allow: INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, OPTIONS
Content-Type: application/sdp
Content-Length: 242

v=0
o=- 4576312012535546667 2 IN IP4 198.51.100.10
s=SIP Call
c=IN IP4 198.51.100.10
t=0 0
m=audio 49170 RTP/AVP 0 8 101
a=rtpmap:0 PCMU/8000
a=rtpmap:8 PCMA/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=sendrecv
a=ptime:20
```

#### [3] SIP 100 Trying
```
SIP/2.0 100 Trying
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889inv1;received=198.51.100.10
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 1 INVITE
Content-Length: 0
```

#### [5] POST SINK_URL
```http
POST /webhooks/webrtc HTTP/1.1
Host: asp.example.com
Content-Type: application/cloudevents+json
Authorization: Bearer eyJ2ZXIiOiIxLjAiLCJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9...
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000005

{
  "id": "evt-inv-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "source": "https://webrtc-gw.operator.com",
  "type": "org.camaraproject.webrtc-events.v0.session-invitation",
  "specversion": "1.0",
  "datacontenttype": "application/json",
  "time": "2025-02-05T10:30:00.100Z",
  "data": {
    "subscriptionId": "sub-a1b2c3d4-e5f6-7890-abcd-ef1234567890",
    "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0",
    "originatorAddress": "tel:+818000000002",
    "originatorName": "Bob",
    "receiverAddress": "tel:+818000000001",
    "receiverName": "Alice",
    "status": "Initial",
    "offer": {
      "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
    },
    "sequenceNumber": 1
  }
}
```

#### [6] 204 No Content
```http
HTTP/1.1 204 No Content
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000005
```

#### [7] GET /webrtc-call-handling/v0.3/sessions/{mediaSessionId}
```http
GET /webrtc-call-handling/v0.3/sessions/1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0 HTTP/1.1
Host: webrtc-gw.operator.com
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000007
registrationId: reg-550e8400-e29b-41d4-a716-446655440000
```

#### [10] 200 OK
```http
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000007

{
  "originatorAddress": "tel:+818000000002",
  "originatorName": "Bob",
  "receiverAddress": "tel:+818000000001",
  "receiverName": "Alice",
  "status": "Initial",
  "offer": {
    "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0"
}
```

#### [13] PUT /webrtc-call-handling/v0.3/sessions/{mediaSessionId}
```http
PUT /webrtc-call-handling/v0.3/sessions/1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0 HTTP/1.1
Host: webrtc-gw.operator.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000013
registrationId: reg-550e8400-e29b-41d4-a716-446655440000

{
  "originatorAddress": "tel:+818000000002",
  "originatorName": "Bob",
  "receiverAddress": "tel:+818000000001",
  "receiverName": "Alice",
  "status": "InProgress",
  "offer": {
    "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "answer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
  },
  "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0"
}
```

#### [16] 200 OK
```http
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000013

{
  "originatorAddress": "tel:+818000000002",
  "originatorName": "Bob",
  "receiverAddress": "tel:+818000000001",
  "receiverName": "Alice",
  "status": "InProgress",
  "offer": {
    "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "answer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
  },
  "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0"
}
```

#### [17] SIP 183 Session Progress
```
SIP/2.0 183 Session Progress
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889inv1;received=198.51.100.10
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 1 INVITE
Contact: <sip:webrtc-gw.operator.com:5060;transport=tcp>
Require: 100rel
RSeq: 1
Content-Type: application/sdp
Content-Length: 231

v=0
o=- 8066321617929821805 2 IN IP4 webrtc-gw.operator.com
s=SIP-to-WebRTC Call
c=IN IP4 203.0.113.100
t=0 0
m=audio 30000 RTP/AVP 0 101
a=rtpmap:0 PCMU/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=sendrecv
a=ptime:20
```

#### [20] SIP PRACK
```
PRACK sip:webrtc-gw.operator.com:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889prack1
Max-Forwards: 70
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 2 PRACK
RAck: 1 1 INVITE
Content-Length: 0
```

#### [21] SIP 200 OK (PRACK)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889prack1;received=198.51.100.10
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 2 PRACK
Content-Length: 0
```

#### [27] PUT /webrtc-call-handling/v0.3/sessions/{mediaSessionId}
```http
PUT /webrtc-call-handling/v0.3/sessions/1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0 HTTP/1.1
Host: webrtc-gw.operator.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000027
registrationId: reg-550e8400-e29b-41d4-a716-446655440000

{
  "originatorAddress": "tel:+818000000002",
  "originatorName": "Bob",
  "receiverAddress": "tel:+818000000001",
  "receiverName": "Alice",
  "status": "Ringing",
  "offer": {
    "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "answer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
  },
  "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0"
}
```

#### [30] 200 OK
```http
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000027

{
  "originatorAddress": "tel:+818000000002",
  "originatorName": "Bob",
  "receiverAddress": "tel:+818000000001",
  "receiverName": "Alice",
  "status": "Ringing",
  "offer": {
    "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "answer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
  },
  "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0"
}
```

#### [31] SIP 180 Ringing
```
SIP/2.0 180 Ringing
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889inv1;received=198.51.100.10
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 1 INVITE
Contact: <sip:webrtc-gw.operator.com:5060;transport=tcp>
Require: 100rel
RSeq: 2
Content-Length: 0
```

#### [34] SIP PRACK
```
PRACK sip:webrtc-gw.operator.com:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889prack2
Max-Forwards: 70
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 3 PRACK
RAck: 2 1 INVITE
Content-Length: 0
```

#### [35] SIP 200 OK (PRACK)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889prack2;received=198.51.100.10
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 3 PRACK
Content-Length: 0
```

#### [38] PUT /webrtc-call-handling/v0.3/sessions/{mediaSessionId}
```http
PUT /webrtc-call-handling/v0.3/sessions/1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0 HTTP/1.1
Host: webrtc-gw.operator.com
Content-Type: application/json
Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000038
registrationId: reg-550e8400-e29b-41d4-a716-446655440000

{
  "originatorAddress": "tel:+818000000002",
  "originatorName": "Bob",
  "receiverAddress": "tel:+818000000001",
  "receiverName": "Alice",
  "status": "Connected",
  "offer": {
    "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "answer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
  },
  "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0"
}
```

#### [41] 200 OK
```http
HTTP/1.1 200 OK
Content-Type: application/json
x-correlator: b2c3d4e5-f6a7-8901-bcde-000000000038

{
  "originatorAddress": "tel:+818000000002",
  "originatorName": "Bob",
  "receiverAddress": "tel:+818000000001",
  "receiverName": "Alice",
  "status": "Connected",
  "offer": {
    "sdp": "v=0\r\no=- 7893214567890123456 2 IN IP4 203.0.113.100\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\nm=audio 50000 UDP/TLS/RTP/SAVPF 111 0 8\r\nc=IN IP4 203.0.113.100\r\na=candidate:2098703421 1 udp 2122262783 203.0.113.100 50000 typ host generation 0\r\na=ice-ufrag:B7nX\r\na=ice-pwd:m9sK3jLpQwErT6yHvC2xNfAz\r\na=fingerprint:sha-256 A1:B2:C3:D4:E5:F6:07:18:29:3A:4B:5C:6D:7E:8F:90:01:12:23:34:45:56:67:78:89:9A:AB:BC:CD:DE:EF:F0\r\na=setup:actpass\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\n"
  },
  "answer": {
    "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 0.0.0.0\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=msid-semantic: WMS local-stream\r\nm=audio 42988 UDP/TLS/RTP/SAVPF 111\r\nc=IN IP4 203.0.113.50\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 203.0.113.50 42988 typ host generation 0\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:C0:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:active\r\na=mid:0\r\na=sendrecv\r\na=rtcp-mux\r\na=rtpmap:111 opus/48000/2\r\na=fmtp:111 minptime=10;useinbandfec=1\r\n"
  },
  "mediaSessionId": "1BFF2C69CBFFEB4FBCB53C0FCC4EEF18F8ADE503FBA0AFEE9F0"
}
```

#### [42] SIP 200 OK (INVITE)
```
SIP/2.0 200 OK
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889inv1;received=198.51.100.10
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 1 INVITE
Contact: <sip:webrtc-gw.operator.com:5060;transport=tcp>
Allow: INVITE, ACK, BYE, CANCEL, UPDATE, PRACK, OPTIONS
Supported: 100rel, timer
Content-Type: application/sdp
Content-Length: 231

v=0
o=- 8066321617929821805 4 IN IP4 webrtc-gw.operator.com
s=SIP-to-WebRTC Call
c=IN IP4 203.0.113.100
t=0 0
m=audio 30000 RTP/AVP 0 101
a=rtpmap:0 PCMU/8000
a=rtpmap:101 telephone-event/8000
a=fmtp:101 0-16
a=sendrecv
a=ptime:20
```

#### [45] SIP ACK
```
ACK sip:webrtc-gw.operator.com:5060;transport=tcp SIP/2.0
Via: SIP/2.0/TCP 198.51.100.10:5060;branch=z9hG4bK889ack1
Max-Forwards: 70
From: "Bob" <sip:+818000000002@tn.operator.com;user=phone>;tag=a6c85cf
To: <sip:+818000000001@operator.com;user=phone>;tag=1928301774
Call-ID: b95c5d87f77821@tn.operator.com
CSeq: 1 ACK
Content-Length: 0
```


## 3.4.2. Call termination by call originator (SIP side)

The call termination by the call originator (SIP side) follows the same pattern as described in section 3.3.3 (Call termination by call receiver) of the call origination flow, where a SIP BYE is received by the WebRTC Gateway from the Telco Network, and the session-status (Terminated) event is notified to the Application Server.

## 3.4.3. Call termination by call receiver (WebRTC side)

The call termination by the call receiver (WebRTC side) follows the same pattern as described in section 3.3.2 (Call termination by call originator) of the call origination flow, where the Application Server sends a DELETE request to the WebRTC Gateway to terminate the session, and the WebRTC Gateway sends a SIP BYE to the Telco Network.
