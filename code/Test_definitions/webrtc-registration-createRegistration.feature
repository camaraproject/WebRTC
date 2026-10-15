Feature: CAMARA WebRTC Registration, vwip - Operation createRegistration

  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Access token type: the API accepts 3-legged access tokens, identifying a single phone number, and 2-legged access tokens, which do not identify a single phone number.
  #   Unless a scenario states otherwise, the Background access token is a 3-legged access token and the request body does not include "$.phoneNumber".
  #   Scenarios using a 2-legged access token include "$.phoneNumber" in the request body unless stated otherwise.
  # * Operator allowed minimum and maximum for "registrationExpireTime".
  # * Per user, per MSISDN and per user device registration limits.
  #
  # Testing assets:
  # * A 3-legged access token identifying a phone number enabled for the service.
  # * A 2-legged access token and at least two phone numbers the API client is allowed to register.
  # * A valid phone number the API client is not allowed to register with a 2-legged access token.
  # * Users and phone numbers that have reached each registration limit, if the limits are enforced by the implementation.
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-registration.yaml

  Background: Common "createRegistration" setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/vwip/sessions"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "#/components/schemas/RegSessionRequest"

############################ Happy Path Scenarios #############################################

  @webrtc_registration_createRegistration_01_3legged_token_without_phone_number
  Scenario: Successful registration with a 3-legged access token and no phoneNumber in the request body
    Given the header "Authorization" is set to a valid access token identifying a phone number
    And the request body property "$.deviceId" is set to a valid UUID not used in any active registration
    And the request body property "$.phoneNumber" is not included
    When the request "createRegistration" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.regInfo.regStatus" is "Registered"
    And the response property "$.expiresAt" is present
    And the response property "$.regInfo.phoneNumber" is the phone number identified by the access token
    And a subsequent request "getRegistrationById" with the path parameter "registrationId" set to the value of the response property "$.registrationId" responds with status code 200 and the same response body

  @webrtc_registration_createRegistration_02_2legged_token_with_phone_number
  Scenario: Successful registration with a 2-legged access token and phoneNumber in the request body
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And the request body property "$.deviceId" is set to a valid UUID not used in any active registration
    And the request body property "$.phoneNumber" is set to a phone number the API client is allowed to register
    When the request "createRegistration" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.regInfo.regStatus" is "Registered"
    And the response property "$.expiresAt" is present
    And the response property "$.regInfo.phoneNumber" is equal to the request body property "$.phoneNumber"
    And a subsequent request "getRegistrationById" with the path parameter "registrationId" set to the value of the response property "$.registrationId" responds with status code 200 and the same response body

  @webrtc_registration_createRegistration_03_expire_time_within_range
  Scenario: Successful registration with registrationExpireTime within the operator allowed range
    Given the request body property "$.registrationExpireTime" is set to a value within the operator allowed range
    When the request "createRegistration" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.regInfo.regStatus" is "Registered"
    And the response property "$.expiresAt" is present
    And the response property "$.expiresAt" represents the same instant as the request body property "$.registrationExpireTime"

  @webrtc_registration_createRegistration_04_expire_time_above_maximum
  Scenario: Successful registration with registrationExpireTime above the operator allowed maximum
    Given the request body property "$.registrationExpireTime" is set to a value later than the operator allowed maximum
    When the request "createRegistration" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.regInfo.regStatus" is "Registered"
    And the response property "$.expiresAt" is present
    And the response property "$.expiresAt" is earlier than the request body property "$.registrationExpireTime"

  @webrtc_registration_createRegistration_05_same_device_different_phone_number
  Scenario: Successful registration of an already registered deviceId bound to a different phone number
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And an existing registration created by operation "createRegistration" for a deviceId and a phone number
    And the request body property "$.deviceId" is set to the deviceId of that registration
    And the request body property "$.phoneNumber" is set to a different phone number the API client is allowed to register
    When the request "createRegistration" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/RegSessionResponse"
    And the response property "$.regInfo.regStatus" is "Registered"
    And the response property "$.expiresAt" is present
    And the response property "$.regInfo.phoneNumber" is equal to the request body property "$.phoneNumber"
    And the response property "$.registrationId" is different from the identifier of the existing registration

############################ Error Scenarios #################################################

  @webrtc_registration_createRegistration_400.01_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "#/components/schemas/RegSessionRequest"
    When the request "createRegistration" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "createRegistration" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_400.03_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to {}
    When the request "createRegistration" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_400.04_missing_required_property
  Scenario Outline: Error response for missing required property in request body
    Given the request body property "<required_property>" is not included
    When the request "createRegistration" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | required_property |
      | $.deviceId        |

  @webrtc_registration_createRegistration_C02.01_phone_number_not_schema_compliant
  Scenario: Phone number value does not comply with the schema
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And the request body property "$.phoneNumber" does not comply with the OAS schema at "#/components/schemas/PhoneNumber"
    When the request "createRegistration" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_400.05_expire_time_below_minimum
  Scenario: Out of range registrationExpireTime below the operator allowed minimum
    Given the request body property "$.registrationExpireTime" is set to a value earlier than the operator allowed minimum
    When the request "createRegistration" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_400.06_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "createRegistration" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "createRegistration" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "createRegistration" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "createRegistration" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-registration:sessions:create"
    When the request "createRegistration" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_403.02_phone_number_not_allowed
  Scenario: Phone number not allowed for the API client with a 2-legged access token
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And the request body property "$.phoneNumber" is set to a valid phone number the API client is not allowed to register
    When the request "createRegistration" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_403.03_max_registration_per_user
  Scenario: Maximum number of registrations per user reached
    Given the user owning the target phone number already has the maximum number of active registrations allowed per user
    When the request "createRegistration" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "WEBRTC_REGISTRATION.MAX_REGISTRATION_PER_USER"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_403.04_max_registration_per_msisdn
  Scenario: Maximum number of registrations per MSISDN reached
    Given the target phone number already has the maximum number of active registrations allowed per MSISDN
    When the request "createRegistration" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "WEBRTC_REGISTRATION.MAX_REGISTRATION_PER_MSISDN"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_403.05_max_devices_per_user
  Scenario: Maximum number of devices per user reached
    Given the user owning the target phone number already has the maximum number of registered devices allowed per user
    And the request body property "$.deviceId" is set to a valid UUID not used in any registration of that user
    When the request "createRegistration" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "WEBRTC_REGISTRATION.MAX_DEVICES_PER_USER"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_409.01_duplicated_registration
  Scenario: Conflict due to an existing registration for the same deviceId and phoneNumber
    Given an existing registration created by operation "createRegistration" for a deviceId and a phone number
    And the request body property "$.deviceId" is set to the deviceId of that registration
    And the request targets the phone number of that registration, identified by the access token or provided in the request body
    When the request "createRegistration" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "ALREADY_EXISTS"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_C02.04_missing_phone_number
  Scenario: Phone number not included and cannot be deduced from the access token
    Given the header "Authorization" is set to a valid access token which does not identify a single phone number
    And the request body property "$.phoneNumber" is not included
    When the request "createRegistration" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MISSING_IDENTIFIER"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_createRegistration_C02.03_unnecessary_phone_number
  Scenario: Phone number not to be included when it can be deduced from the access token
    Given the header "Authorization" is set to a valid access token identifying a phone number
    And the request body property "$.phoneNumber" is set to a valid phone number
    When the request "createRegistration" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "UNNECESSARY_IDENTIFIER"
    And the response property "$.message" contains a user friendly text
