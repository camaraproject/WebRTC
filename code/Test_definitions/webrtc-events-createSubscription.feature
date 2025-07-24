Feature: CAMARA WebRTC Events, v0.2.0-rc.1 - Operation createSubscription

  Background: Common createSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events/v0.2rc1/subscriptions"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/SubscriptionRequest"
    # Properties not explicitly overwritten in the Scenarios can take any values compliant with the schema


  @webrtc_events_createSubscription_01_generic_success_scenario
  Scenario: Create a webrtc-events event subscription
    When the client sends a POST request to "/sessions" with the following payload:
      """
      {
        "protocol": "HTTP",
        "sink": "https://notificationServer.opentelco.com",
        "types": [
          "org.camaraproject.webrtc-events.v0.session-invitation"
        ],
        "config": {
          "subscriptionDetail": {
            "deviceId": "1qazxsw23edc",
            "registrationId": "xsmcaum3z4zw4l0cu4w115m0"
          },
          "initialEvent": true,
          "subscriptionMaxEvents": 50,
          "subscriptionExpireTime": "2024-11-17T13:18:23.682Z"
        }
      }
      """
    Then the response status code should be 201 or 202
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  # Error scenarios

  # Generic 400 errors

  @webrtc_events_createSubscription_400.1_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_createSubscription_400.2_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to "{}"
    When the HTTP "POST" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_events_createSubscription_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_createSubscription_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_createSubscription_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the request body is set to a valid request body
    When the HTTP "POST" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text