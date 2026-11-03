Feature: CAMARA WebRTC Call Handling, v0.4.0-rc.2 - Operation createSession

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Whether callType "EMERGENCY" is supported. Support for EMERGENCY is implementation-declared:
  #   if supported, the EMERGENCY success scenario applies; if not, the 422 CALLTYPE_EMERGENCY_NOT_SUPPORTED scenario applies.
  #
  # Testing assets:
  # * A valid registrationId of an active registration created by operation "createRegistration" of webrtc-registration API.
  # * An originatorAddress belonging to that registration and a reachable receiverAddress.
  # * A valid WebRTC SDP offer.
  # * If EMERGENCY is supported, an emergency test environment where calls to an emergency service URN can be placed safely.
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-call-handling.yaml

  Background: Common createSession setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.4rc2/sessions"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the header "registrationId" is set by default to the identifier of an existing active registration
    And the request body is set by default to a request body compliant with the schema at "#/components/schemas/MediaSessionCreate"

############################ Happy Path Scenarios #############################################

  @webrtc_call_handling_createSession_01_regular_call_success
  Scenario: Create a regular voice-video session
    Given the request body property "$.originatorAddress" is set to the address associated with the registration
    And the request body property "$.receiverAddress" is set to a valid reachable address
    And the request body property "$.offer.sdp" is set to a valid SDP offer
    And the request body property "$.callType" is set to "REGULAR"
    When the request "createSession" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/MediaSessionResponse"
    And the response property "$.originatorAddress" has the same value as the request body property "$.originatorAddress"
    And the response property "$.receiverAddress" has the same value as the request body property "$.receiverAddress"
    And a subsequent request "getSessionDetailsById" with the path parameter "mediaSessionId" set to the response property "$.mediaSessionId" returns response status code 200

  @webrtc_call_handling_createSession_02_emergency_call_with_location_success
  Scenario: Create an emergency voice-video session with location details
    Given the implementation supports callType "EMERGENCY"
    And the request body property "$.originatorAddress" is set to the address associated with the registration
    And the request body property "$.receiverAddress" is set to "urn:service:sos"
    And the request body property "$.offer.sdp" is set to a valid SDP offer
    And the request body property "$.callType" is set to "EMERGENCY"
    And the request body property "$.locationDetails" is set to a valid value compliant with the schema at "#/components/schemas/LocationDetails"
    When the request "createSession" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/MediaSessionResponse"
    And the response property "$.receiverAddress" is "urn:service:sos"

############################ Error Scenarios #############################################

  @webrtc_call_handling_createSession_400.01_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "#/components/schemas/MediaSessionCreate"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_400.03_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to {}
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_400.04_missing_required_property
  Scenario Outline: Error response for missing required property in request body
    Given the request body property "<required_property>" is not included
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | required_property    |
      | $.originatorAddress  |
      | $.receiverAddress    |
      | $.offer              |

  @webrtc_call_handling_createSession_400.05_missing_registrationId_header
  Scenario: Missing registrationId header
    Given the header "registrationId" is not sent
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_400.06_invalid_registrationId_header
  Scenario: registrationId header not compliant with the schema
    Given the header "registrationId" is set to a value not compliant with the schema of parameter "registrationId"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_400.07_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "createSession" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "createSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "createSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "createSession" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-call-handling:sessions:create"
    When the request "createSession" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_call_handling_createSession_422.01_calltype_emergency_not_supported
  Scenario: Error response for callType EMERGENCY not supported
    Given the implementation does not support callType "EMERGENCY"
    And the request body property "$.callType" is set to "EMERGENCY"
    When the request "createSession" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "WEBRTC_CALL_HANDLING.CALLTYPE_EMERGENCY_NOT_SUPPORTED"
    And the response property "$.message" contains a user friendly text
