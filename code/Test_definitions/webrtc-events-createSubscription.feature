Feature: CAMARA WebRTC Events, v0.1.0-rc.1 - Operation createSubscription

  Background: Common createSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events/v0.1rc1/subscriptions"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/SubscriptionRequest"


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
            "racmSessionId": "xsmcaum3z4zw4l0cu4w115m0"
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
