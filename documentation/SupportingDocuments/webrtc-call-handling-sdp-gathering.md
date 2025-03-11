# Obtaining a WebRTC SDP to create calls

CAMARA `webrtc-call-handling` API requires basic usage of the WebRTC API to create
calls. To put it simply, you need to obtain and create an `SDP`(Session Description
Protocol) body to use in the call creation.

Let's dig on it on this document.

Browsers offer the [WebRTC API](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API)
that include `getUserMedia()` to obtain access to media devices (microphone and
cameras), and `RTCPeerConnection` interface to create a network connection and
deliver the captured media to a far end.

That technology becomes responsible of most our common real-time communications on
the web nowadays, from broadcasting to video conference solutions.

The `RTCPeerConnection` interface, provides an `SDP`that is required by our CAMARA
webrtc-call-handling API. So we are going to explain how to obtain it.

Here is a simple code that you can test on your browser:

```
async function getAudioSDP() {
    const config = { iceServers: [{ urls: "stun:stun.l.google.com:19302" }] };
    const peerConnection = new RTCPeerConnection(config);

    try {
        // Get the audio stream
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        stream.getTracks().forEach(track => peerConnection.addTrack(track, stream));

        // Create an offer and set it as local description
        const offer = await peerConnection.createOffer();
        await peerConnection.setLocalDescription(offer);

        // Collect ICE candidates
        const candidates = [];
        peerConnection.onicecandidate = (event) => {
            if (event.candidate) {
                candidates.push(event.candidate);
            } else {
                // No more candidates, log the result
                const sdpData = {
                    sdp: peerConnection.localDescription.sdp,
                    candidates: candidates.map(c => c.candidate)
                };
                console.log("SDP body:", JSON.stringify(sdpData, null, 2));
            }
        };
    } catch (error) {
    console.error("Error accessing microphone:", error);
    }
}

// Run the function
getAudioSDP();
```

Maybe it will take a while to resolve the promise, but once you get it, you will
have a valid description for your session using the `SDP`standard
protocol.

Here is an example of received SDP. You can safely ignore the `candidates` field
and use only the `sdp` value:

```
SDP body: {
  "sdp": "v=0\r\no=- 4808447918291752114 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=extmap-allow-mixed\r\na=msid-semantic: WMS 0893fb9b-23c2-4571-a26d-13cb0f4fed9f\r\nm=audio 13765 UDP/TLS/RTP/SAVPF 111 63 9 0 8 13 110 126\r\nc=IN IP4 123.123.123.123\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:959305279 1 udp 2113937151 26e1f6e6-f0cb-47fb-a1b4-afa62b6a7f29.local 50745 typ host generation 0 network-cost 999\r\na=candidate:3375440286 1 udp 1677729535 123.123.123.123 13765 typ srflx raddr 0.0.0.0 rport 0 generation 0 network-cost 999\r\na=ice-ufrag:YoUo\r\na=ice-pwd:kK5J6IAgiKFDFU+2rC+FyZal\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:CO:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\na=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\na=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\r\na=sendrecv\r\na=msid:0893fb9b-23c2-4571-a26d-13cb0f4fed9f 2daf5a1e-d3bf-4d4e-95db-b8623fce4176\r\na=rtcp-mux\r\na=rtcp-rsize\r\na=rtpmap:111 opus/48000/2\r\na=rtcp-fb:111 transport-cc\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:63 red/48000/2\r\na=fmtp:63 111/111\r\na=rtpmap:9 G722/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:13 CN/8000\r\na=rtpmap:110 telephone-event/48000\r\na=rtpmap:126 telephone-event/8000\r\na=ssrc:932268938 cname:mzxQSFSDV3JpfIJY\r\na=ssrc:932268938 msid:0893fb9b-23c2-4571-a26d-13ccof4fed9f 2daf5a1e-d3bf-4d4e-95db-b8623fce4176\r\n",
  "candidates": [
    "candidate:959305279 1 udp 2113937151 26e1f6e6-f0cb-47fb-a1b4-afa62b6a7f29.local 50745 typ host generation 0 ufrag YoUo network-cost 999",
    "candidate:3375440286 1 udp 1677729535 123.123.123.123 13765 typ srflx raddr 0.0.0.0 rport 0 generation 0 ufrag YoUo network-cost 999"
  ]
}
```

Since there is a delay between the request and the creation of the peer connection
we can start the call creation using POST, and update the session using PUT and
including the new `SDP`and newer candidates obtained.

## Using the SDP to create calls

Here an example of **call creation** using the CAMARA webrtc-call-handling API
with the local `SDP` description gathered on the previous example:

```
POST /webrtc-call-handling/v0.2/sessions
{
    "originatorAddress": "tel:+17085852753",
    "receiverAddress": "tel:+17085854000",
    "offer": {
        "sdp": "v=0\r\no=- 4808447918291752114 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\na=group:BUNDLE 0\r\na=extmap-allow-mixed\r\na=msid-semantic: WMS 0893fb9b-23c2-4571-a26d-13cb0f4fed9f\r\nm=audio 13765 UDP/TLS/RTP/SAVPF 111 63 9 0 8 13 110 126\r\nc=IN IP4 123.123.123.123\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:959305279 1 udp 2113937151 26e1f6e6-f0cb-47fb-a1b4-afa62b6a7f29.local 50745 typ host generation 0 network-cost 999\r\na=candidate:3375440286 1 udp 1677729535 123.123.123.123 13765 typ srflx raddr 0.0.0.0 rport 0 generation 0 network-cost 999\r\na=ice-ufrag:YoUo\r\na=ice-pwd:kK5J6IAgiKFDFU+2rC+FyZal\r\na=ice-options:trickle\r\na=fingerprint:sha-256 CF:56:D8:57:9B:68:B2:1C:F6:ED:6C:CO:02:7C:96:C2:88:A3:C2:38:AD:A2:CA:F5:0D:47:BB:81:74:7B:75:17\r\na=setup:actpass\r\na=mid:0\r\na=extmap:1 urn:ietf:params:rtp-hdrext:ssrc-audio-level\r\na=extmap:2 http://www.webrtc.org/experiments/rtp-hdrext/abs-send-time\r\na=extmap:3 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\na=extmap:4 urn:ietf:params:rtp-hdrext:sdes:mid\r\na=sendrecv\r\na=msid:0893fb9b-23c2-4571-a26d-13cb0f4fed9f 2daf5a1e-d3bf-4d4e-95db-b8623fce4176\r\na=rtcp-mux\r\na=rtcp-rsize\r\na=rtpmap:111 opus/48000/2\r\na=rtcp-fb:111 transport-cc\r\na=fmtp:111 minptime=10;useinbandfec=1\r\na=rtpmap:63 red/48000/2\r\na=fmtp:63 111/111\r\na=rtpmap:9 G722/8000\r\na=rtpmap:0 PCMU/8000\r\na=rtpmap:8 PCMA/8000\r\na=rtpmap:13 CN/8000\r\na=rtpmap:110 telephone-event/48000\r\na=rtpmap:126 telephone-event/8000\r\na=ssrc:932268938 cname:mzxQSFSDV3JpfIJY\r\na=ssrc:932268938 msid:0893fb9b-23c2-4571-a26d-13ccof4fed9f 2daf5a1e-d3bf-4d4e-95db-b8623fce4176\r\n"
        },
    "clientCorrelator": "fda6e26d-e7c8-4596-870c-c083c0d39b2c"
}
```

Check extra information about this API on the inline YAML documentation or refer
to other supporting documents within this folder.

Happy webrtc-ing!

