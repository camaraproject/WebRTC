Feature: CAMARA WebRTC Call Handling, v0.2.0-rc.1 - Operation createSession

  Background: Common createSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.2rc1/sessions"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "transactionId" is set to a UUID value
    And the header "clientId" is set to a UUID value

  @webrtc_call_handling_createSession_01_generic_success_scenario
  Scenario: Create a new call session
    When the client sends a POST request to "/sessions" with the following payload:
      """
      {
        "originatorAddress": "tel:+17085852753",
        "receiverAddress": "tel:+17085854000",
        "offer": {
          "sdp": "v=0\r\no=- 8066321617929821805 2 IN IP4 127.0.0.1\r\ns=-\r\nt=0 0\r\nm=audio 42988 RTP/SAVPF 102 113\r\nc=IN IP6 2001:e0:410:2448:7a05:9b11:66f2:c9e\r\nb=AS:64\r\na=rtcp:9 IN IP4 0.0.0.0\r\na=candidate:1645903805 1 udp 2122262783 2001:e0:410:2448:7a05:9b11:66f2:c9e 42988 typ host generation 0 network-id 3 network-cost 900\r\na=ice-ufrag:4eKp\r\na=ice-pwd:D4sF5Pv9vx9ggaqxBlHbAFMx\r\na=ice-options:trickle renomination\r\na=mid:audio\r\na=extmap:2 http://www.ietf.org/id/draft-holmer-rmcat-transport-wide-cc-extensions-01\r\na=sendrecv\r\na=rtcp-mux\r\na=crypto:1 AES_CM_128_HMAC_SHA1_80 inline:Xm3YciqVIWFNSwy19e9MvfZ2YOdAZil7oT/tHjdf\r\na=rtpmap:102 AMR-WB/16000\r\na=fmtp:102 octet-align=0; mode-set=0,1,2; mode-change-capability=2\r\na=rtpmap:113 telephone-event/16000\r\n"
        },
        "clientCorrelator": "fda6e26d-e7c8-4596-870c-c083c0d39b2c"
      }
      """
    Then the response status code should be 201
    And the response body complies with the OAS schema at "/components/schemas/VvoipSessionInformation"
    And the response body should contain a "callSessionId"
