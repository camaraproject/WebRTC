Feature: CAMARA WebRTC Events Subscriptions, vwip - Operation deleteNotificationChannelSubscription
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Whether subscriptions are deleted synchronously (204), asynchronously (202) or both
  # * Access token type (2-legged or 3-legged) agreed during onboarding
  #
  # Testing assets:
  # * A sink URL identified as "callbackUrl", which receives notifications
  # * A subscription created by operation "createNotificationChannelSubscription" with "$.sink" set to "callbackUrl"
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-events-subscriptions.yaml

  Background: Common deleteNotificationChannelSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events-subscriptions/vwip/subscriptions/{subscriptionId}"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the path parameter "subscriptionId" is set by default to the identifier of an existing subscription

############################ Happy Path Scenarios #############################################

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_01_sync_deletion
  Scenario: Delete an existing subscription synchronously
    Given that subscriptions are deleted synchronously
    And an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 204
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body is not available

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_02_async_deletion
  Scenario: Delete an existing subscription asynchronously
    Given that subscriptions are deleted asynchronously
    And an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_03_not_found_after_deletion
  Scenario: Deleted subscription cannot be retrieved
    Given an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    And the request "deleteNotificationChannelSubscription" has been sent and the deletion has been completed
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 404
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_04_subscription_ended_on_deletion
  Scenario: Receive subscription-ended notification on deletion
    Given an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 202 or 204
    And the event notification "org.camaraproject.webrtc-events-subscriptions.v0.subscription-ended" is received on "callbackUrl"
    And the notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And the notification property "$.data.terminationReason" is "SUBSCRIPTION_DELETED"

############################ Error Scenarios #############################################

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_400.01_invalid_path_parameter
  Scenario: Path parameter subscriptionId not compliant with the schema
    Given the path parameter "subscriptionId" is set to a value not compliant with the schema at "#/components/schemas/SubscriptionId"
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_400.02_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-events-subscriptions:delete"
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_403.02_api_client_token_mismatch
  Scenario: Subscription not created by the API client given in the access token
    Given the header "Authorization" is set to a valid access token emitted to an API client which did not create the subscription
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_deleteNotificationChannelSubscription_404.01_not_found
  Scenario: Non-existing subscriptionId
    Given the path parameter "subscriptionId" is set to a value compliant with the schema that does not identify an existing subscription
    When the request "deleteNotificationChannelSubscription" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text
