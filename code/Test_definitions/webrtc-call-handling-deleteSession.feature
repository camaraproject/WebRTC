Feature: CAMARA WebRTC Call Handling, v0.2.0-rc.1 - Operation deleteSession

  Background: Common updateSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.2rc1/sessions"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "transactionId" is set to a UUID value