Feature: CAMARA WebRTC Registration, vwip - Operation getRegistrationsByDeviceId

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Access token type: the API accepts 3-legged access tokens, identifying a single phone number, and 2-legged access tokens, which do not identify a single phone number. The Background access token is any of them, authorizing the phone numbers of the registrations under test.
  #
  # Testing assets:
  # * A deviceId with at least one active registration created by operation "createRegistration".
  # * A deviceId with active registrations bound to phone numbers both authorized and not authorized by the access token.
  # * A valid UUID not used as deviceId in any active registration.
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-registration.yaml

  Background: Common "getRegistrationsByDeviceId" setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/vwip/sessions"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the query parameter "deviceId" is set by default to the deviceId of an existing registration

############################ Happy Path Scenarios #############################################

  @webrtc_registration_getRegistrationsByDeviceId_01_generic_success_scenario
  Scenario: Retrieve the registrations of a device
    Given at least an existing registration created by operation "createRegistration"
    And the query parameter "deviceId" is set to the deviceId of that registration
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an array whose items comply with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response body includes an item whose property "$.registrationId" is the identifier of that registration

  @webrtc_registration_getRegistrationsByDeviceId_02_empty_response
  Scenario: No active registrations for the deviceId
    Given the query parameter "deviceId" is set to a valid UUID not used as deviceId in any active registration
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an empty array "[]"

  @webrtc_registration_getRegistrationsByDeviceId_03_registrations_of_other_phone_numbers_excluded
  Scenario: Registrations bound to phone numbers not authorized by the access token are not returned
    Given existing registrations created by operation "createRegistration" for the same deviceId and different phone numbers
    And the access token authorizes only some of those phone numbers
    And the query parameter "deviceId" is set to that deviceId
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an array whose items comply with the OAS schema at "#/components/schemas/RegSessionResponse"
    And every item property "$.regInfo.phoneNumber" in the response body is a phone number authorized by the access token

############################ Error Scenarios #################################################

  @webrtc_registration_getRegistrationsByDeviceId_400.01_missing_device_id
  Scenario: Missing query parameter "deviceId"
    Given the query parameter "deviceId" is not included
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_400.02_invalid_device_id
  Scenario: Query parameter "deviceId" not in UUID format
    Given the query parameter "deviceId" is set to a value not compliant with the uuid format
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_400.03_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-registration:sessions:read"
    When the request "getRegistrationsByDeviceId" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
