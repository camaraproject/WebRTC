Feature: CAMARA WebRTC Registration, vwip - Operation updateRegistrationById

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Access token type: the API accepts 3-legged access tokens, identifying a single phone number, and 2-legged access tokens, which do not identify a single phone number. The Background access token is any of them, granted access to the registration under test.
  # * Operator TTL policy and allowed minimum and maximum for "registrationExpireTime".
  #
  # Testing assets:
  # * An existing registration created by operation "createRegistration" that has not expired.
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-registration.yaml

  Background: Common "updateRegistrationById" setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/vwip/sessions/{registrationId}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "#/components/schemas/RegSessionUpdate"
    And the path parameter "registrationId" is set by default to the identifier of an existing registration

############################ Happy Path Scenarios #############################################

  @webrtc_registration_updateRegistrationById_01_refresh_without_expire_time
  Scenario: Refresh a registration without registrationExpireTime
    Given the request body property "$.registrationExpireTime" is not included
    When the request "updateRegistrationById" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.registrationId" is equal to the path parameter "registrationId"
    And the response property "$.expiresAt" is present
    And the response property "$.expiresAt" is later than the time the request was sent
    And a subsequent request "getRegistrationById" with the same path parameter "registrationId" responds with status code 200 and the response property "$.expiresAt" equal to the one in this response

  @webrtc_registration_updateRegistrationById_02_refresh_with_expire_time_within_range
  Scenario: Refresh a registration with registrationExpireTime within the operator allowed range
    Given the request body property "$.registrationExpireTime" is set to a value within the operator allowed range
    When the request "updateRegistrationById" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.registrationId" is equal to the path parameter "registrationId"
    And the response property "$.expiresAt" is present
    And the response property "$.expiresAt" represents the same instant as the request body property "$.registrationExpireTime"
    And a subsequent request "getRegistrationById" with the same path parameter "registrationId" responds with status code 200 and the response property "$.expiresAt" equal to the one in this response

  @webrtc_registration_updateRegistrationById_03_refresh_with_expire_time_above_maximum
  Scenario: Refresh a registration with registrationExpireTime above the operator allowed maximum
    Given the request body property "$.registrationExpireTime" is set to a value later than the operator allowed maximum
    When the request "updateRegistrationById" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.registrationId" is equal to the path parameter "registrationId"
    And the response property "$.expiresAt" is present
    And the response property "$.expiresAt" is earlier than the request body property "$.registrationExpireTime"

############################ Error Scenarios #################################################

  @webrtc_registration_updateRegistrationById_400.01_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "#/components/schemas/RegSessionUpdate"
    When the request "updateRegistrationById" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_400.02_expire_time_below_minimum
  Scenario: Out of range registrationExpireTime below the operator allowed minimum
    Given the request body property "$.registrationExpireTime" is set to a value earlier than the operator allowed minimum
    When the request "updateRegistrationById" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_400.03_registration_id_not_schema_compliant
  Scenario: Path parameter "registrationId" not compliant with the schema
    Given the path parameter "registrationId" is set to a value not compliant with the schema (longer than 256 characters)
    When the request "updateRegistrationById" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_400.04_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "updateRegistrationById" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "updateRegistrationById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "updateRegistrationById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "updateRegistrationById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-registration:sessions:write"
    When the request "updateRegistrationById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_403.02_api_client_token_mismatch
  Scenario: Registration not accessible with the given access token
    Given the header "Authorization" is set to a valid access token emitted to an API client which did not have rights to access/manage the registration
    And the path parameter "registrationId" is set to the identifier of an existing registration
    When the request "updateRegistrationById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_updateRegistrationById_404.01_not_found
  Scenario: Non-existing "registrationId"
    Given the path parameter "registrationId" is set to a schema compliant value that does not identify any registration
    When the request "updateRegistrationById" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
