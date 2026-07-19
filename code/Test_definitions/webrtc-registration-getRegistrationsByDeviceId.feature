Feature: CAMARA WebRTC Registration, v0.4.0-rc.1 - Operation getRegistrationsByDeviceId

  Background: Common getRegistrationsByDeviceId setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-registration/v0.4rc1/sessions"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the query parameter "deviceId" is set by default to a existing device identifier

  @webrtc_registration_getRegistrationsByDeviceId_01_generic_success_scenario
  Scenario: Retrieve active registrations for a device
    Given an existing registration session with "deviceId" as "7d444840-9dc0-11d1-b245-5ffdce74fad2"
    And the query parameter "deviceId" is set to that device identifier
    When the client sends a GET request to "/sessions?deviceId=7d444840-9dc0-11d1-b245-5ffdce74fad2"
    Then the response status code should be 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the response array, if any, complies with the OAS schema at "/components/schemas/RegSessionResponse"

  @webrtc_registration_getRegistrationsByDeviceId_02_no_registrations_for_device
  Scenario: Device has no active registrations
    Given the query parameter "deviceId" identifies a device with no active registrations
    When the HTTP "GET" request is sent
    Then the response status code should be 200
    And the response body is an empty array

  # Error scenarios

  # Generic 400 errors

  @webrtc_registration_getRegistrationsByDeviceId_400.1_no_deviceId
  Scenario: Missing deviceId query parameter
    Given the query parameter "deviceId" is not included
    When the HTTP "GET" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_400.2_empty_deviceId
  Scenario: Empty deviceId query parameter
    Given the query parameter "deviceId" is set to ""
    When the HTTP "GET" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_registration_getRegistrationsByDeviceId_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the query parameter "deviceId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the query parameter "deviceId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_registration_getRegistrationsByDeviceId_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the query parameter "deviceId" is valid
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text
