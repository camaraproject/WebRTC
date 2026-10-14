Feature: CAMARA WebRTC Call Handling, vwip - Operation updateSessionStatus

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

  Background: Common updateSessionStatus setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/vwip/sessions/{mediaSessionId}/status"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "mediaSessionId" is set by default to the identifier of an existing session
    And the request body is set by default to a request body compliant with the schema at "#/components/schemas/MediaSessionStatusChange"

############################ Happy Path Scenarios #############################################

  @webrtc_call_handling_updateSessionStatus_01_connected_with_answer
  Scenario: Accept an incoming session with status Connected and an SDP answer
    Given an existing incoming session in which the API client is the receiving party and the session is not yet connected
    And the path parameter "mediaSessionId" is set to the value of the identifier for that session
    And the request body property "$.status" is set to "Connected"
    And the request body property "$.answer.sdp" is set to a valid SDP answer
    When the request "updateSessionStatus" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/MediaSessionResponse"
    And the response property "$.status" is "Connected"
    And the response property "$.answer.sdp" has the same value as the request body property "$.answer.sdp"
    And a subsequent request "getSessionDetailsById" with the same path parameter "mediaSessionId" returns the response property "$.status" with value "Connected"

  @webrtc_call_handling_updateSessionStatus_02_ringing_without_sdp
  Scenario: Notify that the receiving endpoint is ringing without SDP
    Given an existing incoming session in which the API client is the receiving party and the session is not yet connected
    And the path parameter "mediaSessionId" is set to the value of the identifier for that session
    And the request body is set to {"status": "Ringing"}
    When the request "updateSessionStatus" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/MediaSessionResponse"
    And the response property "$.status" is "Ringing"

  @webrtc_call_handling_updateSessionStatus_03_no_change_returns_current_session
  Scenario: Update without changes returns the current session
    Given an existing session
    And the path parameter "mediaSessionId" is set to the value of the identifier for that session
    And the request body property "$.status" is set to the current status of that session
    And the request body properties "$.offer" and "$.answer" are not included
    When the request "updateSessionStatus" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/MediaSessionResponse"
    And the response body is the same as the response of a "getSessionDetailsById" request for that session sent before the update

############################ Error Scenarios #############################################

  @webrtc_call_handling_updateSessionStatus_400.01_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "#/components/schemas/MediaSessionStatusChange"
    When the request "updateSessionStatus" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "updateSessionStatus" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_400.03_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to {}
    When the request "updateSessionStatus" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_400.04_missing_required_property
  Scenario Outline: Error response for missing required property in request body
    Given the request body property "<required_property>" is not included
    When the request "updateSessionStatus" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | required_property |
      | $.status          |

  @webrtc_call_handling_updateSessionStatus_400.05_invalid_status
  Scenario: Request body property status not compliant with the schema
    Given the request body property "$.status" is set to a value not included in the enum of the schema at "#/components/schemas/SessionStatus"
    When the request "updateSessionStatus" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_400.06_invalid_mediaSessionId
  Scenario: Path parameter mediaSessionId not compliant with the schema
    Given the path parameter "mediaSessionId" is set to a value not compliant with the schema of parameter "mediaSessionId"
    When the request "updateSessionStatus" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_400.07_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "updateSessionStatus" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "updateSessionStatus" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "updateSessionStatus" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "updateSessionStatus" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-call-handling:sessions:write"
    When the request "updateSessionStatus" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_403.02_api_client_token_mismatch
  Scenario: Session not created by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to an API client which did not have rights to access/manage the session
    When the request "updateSessionStatus" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_updateSessionStatus_404.01_not_found
  Scenario: Session not found
    Given the path parameter "mediaSessionId" is set to a value compliant with the schema that does not identify an existing session
    When the request "updateSessionStatus" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
