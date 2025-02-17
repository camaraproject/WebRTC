Feature: CAMARA WebRTC Call Handling, v0.2.0-rc.1 - Operation deleteSession

  Background: Common deleteSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.2rc1/sessions/{vvoipSessionId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "transactionId" is set to a UUID value
    And the header "clientId" is set to a UUID value

  @webrtc_call_handling_deleteSession_01_generic_success_scenario
  Scenario: Cancel or terminate the vvoip session
    Given an existing voice-video session with "vvoipSessionId" as "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF"
    And the path parameter "vvoipSessionId" is set to the value for that voice-video session
    When the client sends a DELETE request to "/sessions/0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF"
    Then the response status code should be 204