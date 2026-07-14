Feature: CAMARA WebRTC Events Subscriptions, vwip - Operation updateNotificationChannelSubscription

  Background: Common updateNotificationChannelSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events-subscriptions/vwip/subscriptions/{subscriptionId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "subscriptionId" is set by default to a existing register session
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/SubscriptionUpdateRequest"
    # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema

  @webrtc_events_updateNotificationChannelSubscription_01_generic_success_scenario
  Scenario: Update a webrtc-events-subscriptions event subscription
    Given an existing events subscription with "subscriptionId" as "qs15-h556-rt89-1298"
    And the path parameter "subscriptionId" is set to the value for that voice-video session
    When the client sends a PUT request to "/subscriptions/qs15-h556-rt89-1298" with the following payload:
      """
      {
        "sinkCredential": {
          "credentialType": "ACCESSTOKEN",
          "accessToken": "c400a020eda54c37a54ea578f8d94748",
          "accessTokenExpiresUtc": "2026-01-16T15:16:00.000Z",
          "accessTokenType": "bearer"
        }
      }
      """
    Then the response status code should be 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"

  # Error scenarios

  @webrtc_events_updateNotificationChannelSubscription_404_subscription_not_found
  Scenario: Identifier cannot be matched to a subscription
    Given the path parameter "subscriptionId" is compliant with the parameter schema but does not identify a valid session
    When the HTTP "PUT" request is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  # Generic 400 errors

  @webrtc_events_updateNotificationChannelSubscription_400.1_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the HTTP "PUT" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_updateNotificationChannelSubscription_400.2_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to "{}"
    When the HTTP "PUT" request is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  # Generic 401 errors

  @webrtc_events_updateNotificationChannelSubscription_401.1_no_authorization_header
  Scenario: No Authorization header
    Given the header "Authorization" is removed
    And the path parameter "subscriptionId" is valid
    And the request body is set to a valid request body
    When the HTTP "PUT" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_updateNotificationChannelSubscription_401.2_expired_access_token
  Scenario: Expired access token
    Given the header "Authorization" is set to an expired access token
    And the path parameter "subscriptionId" is valid
    And the request body is set to a valid request body
    When the HTTP "PUT" request is sent
    Then the response status code is 401
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_updateNotificationChannelSubscription_401.3_invalid_access_token
  Scenario: Invalid access token
    Given the header "Authorization" is set to an invalid access token
    And the path parameter "subscriptionId" is valid
    And the request body is set to a valid request body
    When the HTTP "PUT" request is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  # Generic 422 errors

  @webrtc_events_updateNotificationChannelSubscription_422_unprocessable_entity
  Scenario: Update conflicts with the subscribed event type or config
    Given the request body contains an update that cannot be processed for this subscription
    When the HTTP "PUT" request is sent
    Then the response status code is 422
    And the response property "$.status" is 422
    And the response property "$.message" contains a user friendly text
