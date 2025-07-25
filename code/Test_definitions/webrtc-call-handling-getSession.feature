Feature: CAMARA WebRTC Call Handling, v0.3.0-rc.1 - Operation getSession

  Background: Common getSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.3rc1/sessions/{mediaSessionId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "mediaSessionId" is set by default to a existing register session

  @webrtc_call_handling_getSession_01_generic_success_scenario
  Scenario: Get the media session information
    Given an existing voice-video session with "mediaSessionId" as "0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF"
    And the path parameter "mediaSessionId" is set to the value for that voice-video session
    When the client sends a GET request to "/sessions/0AEE1B58BAEEDA3EABA42B32EBB3DFE07E9CFF402EAF9EED8EF"
    Then the response status code should be 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/MediaSessionInformation"

  # Error scenarios

  @webrtc_call_handling_getSession_404_session_not_found
  Scenario: Session identifier cannot be matched to an existing call
    Given the path parameter "mediaSessionId" is compliant with the parameter schema but does not identify a valid session
    When the HTTP "GET" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @webrtc_call_handling_getSession_400.1_no_request
  Scenario: Missing request path
    Given the path parameter "mediaSessionId" not included
    When the HTTP "GET" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSession_400.2_empty_request
  Scenario: Empty object as request path
    Given the request body is set to "{}"
    Given the path parameter "mediaSessionId" is set to ""
    When the HTTP "GET" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_call_handling_getSession_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the path parameter "mediaSessionId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSession_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the path parameter "mediaSessionId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSession_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "mediaSessionId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text