Feature: CAMARA WebRTC Registration, v0.3.0-rc.1 - Operation updateRegistrationById

  Background: Common updateRegistrationById setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/v0.3rc1/sessions/{registrationId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "registrationId" is set by default to a existing register session
 
  @webrtc_registration_updateRegistrationById_01_generic_success_scenario
  Scenario: Update an existing registration session
    Given an existing registration session with "registrationId" as "existing-session-id"
    And the path parameter "registrationId" is set to the value for that register session
    When the client sends a PUT request to "/sessions/existing-session-id"
    Then the response status code should be 204
    And the response header "x-correlator" has same value as the request header "x-correlator"

  # Error scenarios

  @webrtc_registration_updateRegistrationById_404_session_not_found
  Scenario: Session identifier cannot be matched to an existing call
    Given the path parameter "registrationId" is compliant with the parameter schema but does not identify a valid session
    When the HTTP "PUT" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @webrtc_registration_updateRegistrationById_400.1_no_request_body
  Scenario: Missing request path
    Given the path parameter "registrationId" is not included
    When the HTTP "PUT" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_400.2_empty_request_body
  Scenario: Empty object as request path
    Given the path parameter "registrationId" set to ""
    When the HTTP "PUT" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_registration_updateRegistrationById_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the path parameter "registrationId" is valid
    When the HTTP "PUT" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the path parameter "registrationId" is valid
    When the HTTP "PUT" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "registrationId" is valid
    When the HTTP "PUT" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text