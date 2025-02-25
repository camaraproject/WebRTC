Feature: CAMARA WebRTC Registration, v0.2.0-rc.1 - Operation deleteSession

  Background: Common deleteSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/v0.2rc1/sessions/{regSessionId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    And the header "clientId" is set to a UUID value
    And the path parameter "regSessionId" is set by default to a existing register session
 
  @webrtc_registration_deleteSession_01_generic_success_scenario
  Scenario: Delete an existing registration session
    Given an existing registration session with "regSessionId" as "existing-session-id"
    When the client sends a DELETE request to "/registrations/existing-session-id"
    Then the response status code should be 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the registration session should no longer exist

  # Error scenarios

  @webrtc_registration_deleteSession_404_session_not_found
  Scenario: Session identifier cannot be matched to a device
    Given the path parameter "regSessionId" is compliant with the parameter schema but does not identify a valid session
    When the HTTP "DELETE" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @webrtc_registration_deleteSession_400.1_no_request
  Scenario: Missing request path
    Given the path parameter "regSessionId" is not included
    When the HTTP "DELETE" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getSession_400.2_empty_request
  Scenario: Empty object as request path
    Given the path parameter "regSessionId" is set to ""
    When the HTTP "GET" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_registration_deleteSession_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the path parameter "regSessionId" is valid
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteSession_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the path parameter "regSessionId" is valid
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteSession_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "regSessionId" is valid
    When the HTTP "DELETE" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text