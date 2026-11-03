Feature: CAMARA WebRTC Call Handling, v0.4.0-rc.2 - Operation getSessionDetailsById

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  #
  # Testing assets:
  # * An existing media session created by operation "createSession", or received through a session-invitation event, managed by the API client of the access token.
  # * An access token emitted to a different API client, for the token mismatch scenario.
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-call-handling.yaml

  Background: Common getSessionDetailsById setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.4rc2/sessions/{mediaSessionId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "mediaSessionId" is set by default to the identifier of an existing session

############################ Happy Path Scenarios #############################################

  @webrtc_call_handling_getSessionDetailsById_01_generic_success_scenario
  Scenario: Retrieve an existing media session
    Given an existing session created by operation "createSession"
    And the path parameter "mediaSessionId" is set to the value of the identifier for that session
    When the request "getSessionDetailsById" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/MediaSessionResponse"
    And the response property "$.mediaSessionId" is the value of the path parameter "mediaSessionId"
    And the response properties "$.originatorAddress" and "$.receiverAddress" have the same values as in the "createSession" request for that session

############################ Error Scenarios #############################################

  @webrtc_call_handling_getSessionDetailsById_400.01_invalid_mediaSessionId
  Scenario: Path parameter mediaSessionId not compliant with the schema
    Given the path parameter "mediaSessionId" is set to a value not compliant with the schema of parameter "mediaSessionId"
    When the request "getSessionDetailsById" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSessionDetailsById_400.02_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "getSessionDetailsById" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSessionDetailsById_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "getSessionDetailsById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSessionDetailsById_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "getSessionDetailsById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSessionDetailsById_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "getSessionDetailsById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSessionDetailsById_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-call-handling:sessions:read"
    When the request "getSessionDetailsById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSessionDetailsById_403.02_api_client_token_mismatch
  Scenario: Session not created by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to an API client which did not have rights to access/manage the session
    When the request "getSessionDetailsById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_getSessionDetailsById_404.01_not_found
  Scenario: Session not found
    Given the path parameter "mediaSessionId" is set to a value compliant with the schema that does not identify an existing session
    When the request "getSessionDetailsById" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
