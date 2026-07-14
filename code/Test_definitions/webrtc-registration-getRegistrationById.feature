Feature: CAMARA WebRTC Registration, vwip - Operation getRegistrationById

  Background: Common getRegistrationById setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/vwip/sessions/{registrationId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "registrationId" is set by default to a existing register session

  @webrtc_registration_getRegistrationById_01_generic_success_scenario
  Scenario: Get the registration information
    Given an existing registration session with "registrationId" as "a1b2c3d4-1234-5678-abcd-ef0123456789"
    And the path parameter "registrationId" is set to the value for that register session
    When the client sends a GET request to "/sessions/a1b2c3d4-1234-5678-abcd-ef0123456789"
    Then the response status code should be 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/RegSessionResponse"

  # Error scenarios

  @webrtc_registration_getRegistrationById_404_session_not_found
  Scenario: Registration identifier cannot be matched to an existing registration
    Given the path parameter "registrationId" is compliant with the parameter schema but does not identify a valid session
    When the HTTP "GET" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @webrtc_registration_getRegistrationById_400.1_no_request
  Scenario: Missing request path
    Given the path parameter "registrationId" not included
    When the HTTP "GET" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationById_400.2_empty_request
  Scenario: Empty object as request path
    Given the request body is set to "{}"
    And the path parameter "registrationId" is set to ""
    When the HTTP "GET" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_registration_getRegistrationById_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the path parameter "registrationId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationById_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the path parameter "registrationId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationById_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "registrationId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
