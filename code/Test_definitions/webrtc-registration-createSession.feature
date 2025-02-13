Feature: CAMARA WebRTC Registration, v0.2.0-rc.1 - Operation createSession

  Background: Common createSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/v0.2rc1/session"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "transactionId" is set to a UUID value
 
  @webrtc_registration_createSession_01_generic_success_scenario
  Scenario: Create a new registration session
    When the client sends a POST request to "/sessions" with the following payload:
      """
      {
        "deviceId": "string"
      }
      """
    Then the response status code should be 200
    And the response body should contain a "racmSessionId"