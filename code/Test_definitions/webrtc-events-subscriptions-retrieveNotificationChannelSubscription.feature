Feature: CAMARA WebRTC Events Subscriptions, vwip - Operation retrieveNotificationChannelSubscription
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Access token type (2-legged or 3-legged) agreed during onboarding
  #
  # Testing assets:
  # * A subscription created by operation "createNotificationChannelSubscription"
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-events-subscriptions.yaml

  Background: Common retrieveNotificationChannelSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events-subscriptions/vwip/subscriptions/{subscriptionId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "subscriptionId" is set by default to the identifier of an existing subscription

############################ Happy Path Scenarios #############################################

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_01_generic_success_scenario
  Scenario: Retrieve an existing subscription
    Given an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"
    And the response property "$.id" is the value of the path parameter "subscriptionId"
    And the response properties "$.types", "$.sink" and "$.config.subscriptionDetail" have the values of the subscription creation request

############################ Error Scenarios #############################################

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_400.01_invalid_path_parameter
  Scenario: Path parameter subscriptionId not compliant with the schema
    Given the path parameter "subscriptionId" is set to a value not compliant with the schema at "#/components/schemas/SubscriptionId"
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_400.02_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-events-subscriptions:read"
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_403.02_api_client_token_mismatch
  Scenario: Subscription not created by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to an API client which did not create the subscription
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscription_404.01_not_found
  Scenario: Non-existing subscriptionId
    Given the path parameter "subscriptionId" is set to a value compliant with the schema that does not identify an existing subscription
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
