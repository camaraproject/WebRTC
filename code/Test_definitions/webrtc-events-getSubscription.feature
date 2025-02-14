Feature: CAMARA WebRTC Events, v0.1.0-rc.1 - Operation getSubscription

  Background: Common getSubscription setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-call-handling/v0.1rc1/subscriptions/{subscriptionId}"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema

  @webrtc_call_handling_getSusbcription_01_generic_success_scenario
  Scenario: Retrieve a webrtc-events event subscription
    Given an existing events subscription with "subscriptionId" as "qs15-h556-rt89-1298"
    And the path parameter "subscriptionId" is set to the value for that voice-video session
    When the client sends a GET request to "/subscriptions/qs15-h556-rt89-1298"
    Then the response status code should be 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Subscription"
