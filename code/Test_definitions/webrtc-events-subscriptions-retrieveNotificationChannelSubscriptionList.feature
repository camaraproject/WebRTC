Feature: CAMARA WebRTC Events Subscriptions, vwip - Operation retrieveNotificationChannelSubscriptionList
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Access token type (2-legged or 3-legged) agreed during onboarding
  #
  # Testing assets:
  # * An API client able to create subscriptions with operation "createNotificationChannelSubscription"
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-events-subscriptions.yaml

  Background: Common retrieveNotificationChannelSubscriptionList setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events-subscriptions/vwip/subscriptions"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"

############################ Happy Path Scenarios #############################################

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_01_generic_success_scenario
  Scenario: Retrieve the list of existing subscriptions
    Given at least an existing subscription created by operation "createNotificationChannelSubscription"
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an array whose items comply with the OAS schema at "#/components/schemas/Subscription"
    And the response body includes an item whose property "$.id" is the identifier of that subscription

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_02_empty_response
  Scenario: No existing subscriptions
    Given no subscriptions have been created by operation "createNotificationChannelSubscription" for the API client
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is an empty array "[]"

############################ Error Scenarios #############################################

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_400.01_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-events-subscriptions:read"
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text
