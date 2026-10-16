Feature: CAMARA WebRTC Registration, v0.4.0-rc.2 - Operation deleteRegistrationById

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Access token type: the API accepts 3-legged access tokens, identifying a single phone number, and 2-legged access tokens, which do not identify a single phone number. The Background access token is any of them, granted access to the registration under test.
  #
  # Testing assets:
  # * An existing registration created by operation "createRegistration" for each success scenario.
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-registration.yaml

  Background: Common "deleteRegistrationById" setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/v0.4rc2/sessions/{registrationId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "registrationId" is set by default to the identifier of an existing registration

############################ Happy Path Scenarios #############################################

  @webrtc_registration_deleteRegistrationById_01_generic_success_scenario
  Scenario: Delete an existing registration
    Given an existing registration created by operation "createRegistration"
    And the path parameter "registrationId" is set to the value of the identifier for that registration
    When the request "deleteRegistrationById" is sent
    Then the response status code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And a subsequent request "getRegistrationById" with the same path parameter "registrationId" responds with status code 404

############################ Error Scenarios #################################################

  @webrtc_registration_deleteRegistrationById_400.01_registration_id_not_schema_compliant
  Scenario: Path parameter "registrationId" not compliant with the schema
    Given the path parameter "registrationId" is set to a value not compliant with the schema (longer than 256 characters)
    When the request "deleteRegistrationById" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteRegistrationById_400.02_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "deleteRegistrationById" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteRegistrationById_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "deleteRegistrationById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteRegistrationById_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "deleteRegistrationById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteRegistrationById_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "deleteRegistrationById" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteRegistrationById_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-registration:sessions:delete"
    When the request "deleteRegistrationById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteRegistrationById_403.02_api_client_token_mismatch
  Scenario: Registration not accessible with the given access token
    Given the header "Authorization" is set to a valid access token emitted to an API client which did not have rights to access/manage the registration
    And the path parameter "registrationId" is set to the identifier of an existing registration
    When the request "deleteRegistrationById" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_deleteRegistrationById_404.01_not_found
  Scenario: Non-existing "registrationId"
    Given the path parameter "registrationId" is set to a schema compliant value that does not identify any registration
    When the request "deleteRegistrationById" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
