Feature: CAMARA WebRTC Events Subscriptions, vwip - Operation updateNotificationChannelSubscription
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

  Background: Common updateNotificationChannelSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events-subscriptions/vwip/subscriptions/{subscriptionId}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "#/components/schemas/SubscriptionUpdateRequest"
    And the path parameter "subscriptionId" is set by default to the identifier of an existing subscription

############################ Happy Path Scenarios #############################################

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_01_update_expire_time
  Scenario: Update the subscription expire time
    Given an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    And the request body property "$.config.subscriptionExpireTime" is set to a date-time in the future different from the current one
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"
    And the response property "$.id" is the value of the path parameter "subscriptionId"
    And the response property "$.config.subscriptionExpireTime" is the value of the request body property "$.config.subscriptionExpireTime"
    And the response properties "$.types", "$.sink" and "$.config.subscriptionDetail" are unchanged

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_02_update_sink_credential
  Scenario: Update the subscription sinkCredential
    Given an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    And the request body property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request body property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request body property "$.sinkCredential.accessToken" is set to a valid access token
    And the request body property "$.sinkCredential.accessTokenExpiresUtc" is set to a date-time in the future
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_03_update_reflected_on_retrieval
  Scenario: Updated subscription is returned by retrieval
    Given an existing subscription created by operation "createNotificationChannelSubscription"
    And the path parameter "subscriptionId" is set to the value of "$.id" for that subscription
    And the request "updateNotificationChannelSubscription" has been sent with "$.config.subscriptionExpireTime" set to a date-time in the future and the response status code is 200
    When the request "retrieveNotificationChannelSubscription" is sent
    Then the response status code is 200
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"
    And the response property "$.config.subscriptionExpireTime" is the value sent in the update request

############################ Error Scenarios #############################################

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.01_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "#/components/schemas/SubscriptionUpdateRequest"
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.03_non_updatable_property
  Scenario Outline: Request body with a property that cannot be updated
    Given the request body property "<property>" is set to a value compliant with the schema at "#/components/schemas/SubscriptionRequest"
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | property                    |
      | $.sink                      |
      | $.types                     |
      | $.config.subscriptionDetail |

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.04_expire_time_in_past
  Scenario: Update with expire time in the past
    Given the request body property "$.config.subscriptionExpireTime" is set to a date-time in the past
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.05_invalid_path_parameter
  Scenario: Path parameter subscriptionId not compliant with the schema
    Given the path parameter "subscriptionId" is set to a value not compliant with the schema at "#/components/schemas/SubscriptionId"
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.06_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.07_out_of_range
  Scenario: Update with expire time beyond the allowed range
    Given the request body property "$.config.subscriptionExpireTime" is set to a date-time beyond the maximum subscription duration allowed by the implementation
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.08_invalid_credential
  Scenario: Update with invalid credential type
    Given the request body property "$.sinkCredential.credentialType" is not set to "ACCESSTOKEN"
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_400.09_invalid_token
  Scenario: Update with invalid sink credential token
    Given the request body property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request body property "$.sinkCredential.accessTokenType" is not set to "bearer"
    And the request body property "$.sinkCredential.accessToken" is set to a valid access token
    And the request body property "$.sinkCredential.accessTokenExpiresUtc" is set to a date-time in the future
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_403.01_missing_access_token_scope
  Scenario: Missing access token scope
    Given the header "Authorization" is set to an access token that does not include scope "webrtc-events-subscriptions:update"
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_404.01_not_found
  Scenario: Non-existing subscriptionId
    Given the path parameter "subscriptionId" is set to a value compliant with the schema that does not identify an existing subscription
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 404
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_updateNotificationChannelSubscription_429.01_too_many_requests
  Scenario: Request is rejected due to threshold policy
    Given the threshold of requests has been reached
    When the request "updateNotificationChannelSubscription" is sent
    Then the response status code is 429
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 429
    And the response property "$.code" is "TOO_MANY_REQUESTS"
    And the response property "$.message" contains a user friendly text
