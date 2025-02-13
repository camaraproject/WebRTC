Feature: CAMARA WebRTC Registration, v0.2.0-rc.1 - Operation updateSession

  Background: Common updateSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/v0.2rc1/session"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "transactionId" is set to a UUID value
 
  @webrtc_registration_updateSession_01_generic_success_scenario
  Scenario: Update an existing registration session
    Given an existing registration session with "racmSessionId" as "existing-session-id"
    When the client sends a PUT request to "/registrations/existing-session-id" with the following payload:
      """
      {
        "clientId": "updated-client-id"
      }
      """
    Then the response status code should be 200
    And the response body should indicate a successful update