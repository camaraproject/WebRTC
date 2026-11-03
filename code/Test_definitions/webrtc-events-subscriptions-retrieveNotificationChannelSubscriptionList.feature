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
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionList"
    And the response property "$.subscriptions" includes an item whose property "$.id" is the identifier of that subscription
    And the response property "$.pagination" complies with the OAS schema at "#/components/schemas/Pagination"

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_02_empty_response
  Scenario: No existing subscriptions
    Given no subscriptions have been created by operation "createNotificationChannelSubscription" for the API client
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionList"
    And the response property "$.subscriptions" is an empty array "[]"
    And the response property "$.pagination" complies with the OAS schema at "#/components/schemas/Pagination"

  # Pagination scenarios: only applicable if the implementation supports pagination (OPTIONAL per CAMARA API Design Guide).
  # Page size 20 is used as an example; adapt to the implementation default.

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_03_pagination_default_values
  Scenario: Pagination with default values for page and perPage
    Given the implementation supports pagination
    And more than 20 subscriptions created by operation "createNotificationChannelSubscription" for the API client
    When the request "retrieveNotificationChannelSubscriptionList" is sent without query parameters "page" and "perPage"
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "link" contains a link to the next page with rel="next"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionList"
    And the response property "$.subscriptions" has 20 items
    And the response property "$.pagination.page" is 1
    And the response property "$.pagination.perPage" is 20

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_04_pagination_middle_page
  Scenario: Pagination fetching a middle page of the list
    Given the implementation supports pagination
    And more than 40 subscriptions created by operation "createNotificationChannelSubscription" for the API client
    When the request "retrieveNotificationChannelSubscriptionList" is sent with query parameters "page" set to 2 and "perPage" set to 20
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "link" contains a link to the previous page with rel="prev" and a link to the next page with rel="next"
    And the response header "x-total-pages", if present, is equal to the response property "$.pagination.totalPages"
    And the response header "x-total-count", if present, is equal to the response property "$.pagination.totalCount"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionList"
    And the response property "$.subscriptions" has 20 items
    And the response property "$.pagination.page" is 2
    And the response property "$.pagination.perPage" is 20

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_05_pagination_last_page
  Scenario: Pagination fetching the last page of the list
    Given the implementation supports pagination
    And more than 40 and less than 60 subscriptions created by operation "createNotificationChannelSubscription" for the API client
    When the request "retrieveNotificationChannelSubscriptionList" is sent with query parameters "page" set to 3 and "perPage" set to 20
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response header "link" contains a link to the previous page with rel="prev"
    And the response body complies with the OAS schema at "#/components/schemas/SubscriptionList"
    And the response property "$.subscriptions" has between 1 and 20 items
    And the response property "$.pagination.page" is 3
    And the response property "$.pagination.totalPages", if present, is 3

############################ Error Scenarios #############################################

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_400.01_invalid_x-correlator
  Scenario: Invalid x-correlator header
    Given the header "x-correlator" does not comply with the schema at "#/components/schemas/XCorrelator"
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 400
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_400.02_invalid_page
  Scenario: Invalid value for query parameter page
    Given the implementation supports pagination
    And the query parameter "page" is set to a value less than 1
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
    And the response property "$.message" contains a user friendly text

  @webrtc_events_subscriptions_retrieveNotificationChannelSubscriptionList_400.03_invalid_perPage
  Scenario: Invalid value for query parameter perPage
    Given the implementation supports pagination
    And the query parameter "perPage" is set to a value outside the range [1-100]
    When the request "retrieveNotificationChannelSubscriptionList" is sent
    Then the response status code is 400
    And the response header "x-correlator" has same value as the request header "x-correlator"
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
