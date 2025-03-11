Feature: CAMARA WebRTC Events, v0.1.0 - Operation getListSubscriptions

  Background: Common getListSubscriptions setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events/v0.1/subscriptions"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema

  @webrtc_events_getListSubscriptions_01_generic_success_scenario
  Scenario: Retrieve a list of webrtc-events event subscription
    When the client sends a GET request to "/subscriptions"
    Then the response status code should be 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the the response array, if any, complies with the OAS schema at "/components/schemas/Subscription"
  
  # Error scenarios

  # Generic 401 errors

  @webrtc_events_getListSubscriptions_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_getListSubscriptions_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_getListSubscriptions_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the HTTP "GET" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text