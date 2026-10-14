Feature: CAMARA WebRTC Events Subscriptions, vwip - Operation createNotificationChannelSubscription
  # Input to be provided by the implementation to the tester
  #
  # Implementation indications:
  # * apiRoot: API root of the server URL
  # * Whether subscriptions are created synchronously (201), asynchronously (202) or both
  # * Whether multi-event subscriptions are supported
  # * Access token type (2-legged or 3-legged) agreed during onboarding
  #
  # Testing assets:
  # * A sink URL identified as "callbackUrl", which receives notifications
  # * A deviceId with an active WebRTC registration created by operation "createRegistration" of webrtc-registration
  #
  # References to OAS spec schemas refer to schemas specified in webrtc-events-subscriptions.yaml

  Background: Common createNotificationChannelSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events-subscriptions/vwip/subscriptions"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    And the request body is set by default to a request body compliant with the schema at "#/components/schemas/SubscriptionRequest"
    And the request body property "$.sink" is set to "callbackUrl"
    And the request body property "$.config.subscriptionDetail.deviceId" is set to the testing asset deviceId
    And the request body properties "$.config.initialEvent" and "$.config.subscriptionMaxEvents" are not included

############################ Happy Path Scenarios #############################################

  @webrtc_events_subscriptions_createNotificationChannelSubscription_01_sync_creation
  Scenario Outline: Create a subscription synchronously for event type <event_type>
    Given that subscriptions are created synchronously
    And the request body property "$.types" is set to ["<event_type>"]
    And the request body property "$.config.subscriptionExpireTime" is set to a date-time in the future
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"
    And the response property "$.types[0]" is "<event_type>"
    And the response property "$.config.subscriptionDetail.deviceId" is the testing asset deviceId

    Examples:
      | event_type                                                          |
      | org.camaraproject.webrtc-events-subscriptions.v0.session-invitation |
      | org.camaraproject.webrtc-events-subscriptions.v0.session-status     |
      | org.camaraproject.webrtc-events-subscriptions.v0.registration-ends  |

  @webrtc_events_subscriptions_createNotificationChannelSubscription_02_async_creation
  Scenario: Create a subscription asynchronously
    Given that subscriptions are created asynchronously
    And the request body property "$.types" is set to ["org.camaraproject.webrtc-events-subscriptions.v0.session-invitation"]
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 202
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionAsync"

  @webrtc_events_subscriptions_createNotificationChannelSubscription_03_accesstoken_sink_credential
  Scenario: Create a subscription synchronously with ACCESSTOKEN sinkCredential
    Given that subscriptions are created synchronously
    And the request body property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request body property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request body property "$.sinkCredential.accessToken" is set to a valid access token
    And the request body property "$.sinkCredential.accessTokenExpiresUtc" is set to a date-time in the future
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/Subscription"

  @webrtc_events_subscriptions_createNotificationChannelSubscription_04_subscription_ended_on_expiry
  Scenario: Receive subscription-ended notification on expiry
    Given an existing subscription created by operation "createNotificationChannelSubscription" with "$.config.subscriptionExpireTime" set in the near future
    When the subscription expire time is reached
    Then the event notification "org.camaraproject.webrtc-events-subscriptions.v0.subscription-ended" is received on "callbackUrl"
    And the notification body complies with the OAS schema at "#/components/schemas/EventSubscriptionEnded"
    And the notification property "$.data.terminationReason" is "SUBSCRIPTION_EXPIRED"

############################ Error Scenarios #############################################

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.01_schema_not_compliant
  Scenario: Invalid Argument. Generic Syntax Exception
    Given the request body is included but is not compliant with the schema at "#/components/schemas/SubscriptionRequest"
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.02_no_request_body
  Scenario: Missing request body
    Given the request body is not included
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.03_empty_request_body
  Scenario: Empty object as request body
    Given the request body is set to {}
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.04_missing_required_property
  Scenario Outline: Error response for missing required property in request body
    Given the request body property "<required_property>" is not included
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

    Examples:
      | required_property                    |
      | $.protocol                           |
      | $.sink                               |
      | $.types                              |
      | $.config                             |
      | $.config.subscriptionDetail          |
      | $.config.subscriptionDetail.deviceId |

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.05_invalid_event_type
  Scenario: Subscription creation with invalid event type
    Given the request body property "$.types" is set to ["org.camaraproject.webrtc-events-subscriptions.v0.unknown-event"]
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.06_expire_time_in_past
  Scenario: Subscription creation with expire time in the past
    Given the request body property "$.config.subscriptionExpireTime" is set to a date-time in the past
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.07_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.08_out_of_range
  Scenario: Subscription creation with expire time beyond the allowed range
    Given the request body property "$.config.subscriptionExpireTime" is set to a date-time beyond the maximum subscription duration allowed by the implementation
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "OUT_OF_RANGE"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.09_invalid_protocol
  Scenario: Subscription creation with invalid protocol
    Given the request body property "$.protocol" is not set to "HTTP"
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_PROTOCOL"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.10_invalid_credential
  Scenario: Subscription creation with invalid credential type
    Given the request body property "$.sinkCredential.credentialType" is not set to "ACCESSTOKEN"
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_CREDENTIAL"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.11_invalid_token
  Scenario: Subscription creation with invalid sink credential token
    Given the request body property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request body property "$.sinkCredential.accessTokenType" is not set to "bearer"
    And the request body property "$.sinkCredential.accessToken" is set to a valid access token
    And the request body property "$.sinkCredential.accessTokenExpiresUtc" is set to a date-time in the future
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_TOKEN"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_400.12_invalid_sink
  Scenario: Subscription creation with invalid sink
    Given the request body property "$.sink" is set to a URL not valid for the specified protocol
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_SINK"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_401.01_no_authorization_header
  Scenario: Error response for no header "Authorization"
    Given the header "Authorization" is not sent
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_401.02_expired_access_token
  Scenario: Error response for expired access token
    Given the header "Authorization" is set to an expired access token
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_401.03_invalid_access_token
  Scenario: Error response for invalid access token
    Given the header "Authorization" is set to an invalid access token
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 401
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_403.01_missing_access_token_scope
  Scenario Outline: Missing access token scope for event type <event_type>
    Given the request body property "$.types" is set to ["org.camaraproject.webrtc-events-subscriptions.v0.<event_type>"]
    And the header "Authorization" is set to an access token that does not include scope "webrtc-events-subscriptions:org.camaraproject.webrtc-events-subscriptions.v0.<event_type>:create"
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 403
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"
    And the response property "$.message" contains a user friendly text

    Examples:
      | event_type         |
      | session-invitation |
      | session-status     |
      | registration-ends  |

  @webrtc_events_subscriptions_createNotificationChannelSubscription_409.01_already_exists
  Scenario: Conflict due to an existing subscription
    Given an existing subscription with the same "$.types", "$.sink" and "$.config.subscriptionDetail.deviceId" as the request body
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "ALREADY_EXISTS"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_409.02_aborted
  Scenario: Conflict due to a subscription being modified
    Given a subscription with the same "$.types" and "$.config.subscriptionDetail.deviceId" as the request body is being modified by another request
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 409
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 409
    And the response property "$.code" is "ABORTED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_422.01_service_not_applicable
  Scenario: Service not applicable for the provided deviceId
    Given the request body property "$.config.subscriptionDetail.deviceId" is set to a deviceId without an active WebRTC registration
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "SERVICE_NOT_APPLICABLE"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_422.02_multievent_not_supported
  Scenario: Multi-event subscription not supported
    Given the implementation only allows one event type per subscription
    And the request body property "$.types" is set to an array with 2 valid event types
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MULTIEVENT_SUBSCRIPTION_NOT_SUPPORTED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_422.03_multievent_combination_not_supported
  Scenario: Multi-event combination temporarily not supported
    Given the implementation supports multi-event subscriptions
    And the request body property "$.types" is set to a combination of event types temporarily not supported by the implementation
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 422
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 422
    And the response property "$.code" is "MULTIEVENT_COMBINATION_TEMPORARILY_NOT_SUPPORTED"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_createNotificationChannelSubscription_429.01_too_many_requests
  Scenario: Request is rejected due to threshold policy
    Given the threshold of requests has been reached
    When the request "createNotificationChannelSubscription" is sent
    Then the response status code is 429
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "Content-Type" is "application/json"
    And the response property "$.status" is 429
    And the response property "$.code" is "TOO_MANY_REQUESTS"
    And the response property "$.message" contains a user friendly text
