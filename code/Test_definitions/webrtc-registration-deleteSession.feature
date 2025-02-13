Feature: CAMARA WebRTC Registration, v0.2.0-rc.1 - Operation deleteSession

  Background: Common deleteSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/v0.2rc1/session"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "transactionId" is set to a UUID value
 
  @webrtc_registration_deleteSession_01_generic_success_scenario
  Scenario: Delete an existing registration session
    Given an existing registration session with "racmSessionId" as "existing-session-id"
    When the client sends a DELETE request to "/registrations/existing-session-id"
    Then the response status code should be 204
    And the registration session should no longer exist
