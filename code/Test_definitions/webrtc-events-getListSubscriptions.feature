Feature: CAMARA WebRTC Events, v0.1.0-rc.1 - Operation getListSubscriptions

  Background: Common getListSubscriptions setup
    Given an environment at "apiRoot"
    And the resource "/webrtc-events/v0.1rc1/subscriptions"                                                              |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a UUID value
    # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema

  @webrtc_call_handling_getListSubscriptions_01_generic_success_scenario
  Scenario: Retrieve a list of webrtc-events event subscription
    When the client sends a GET request to "/subscriptions"
    Then the response status code should be 200
    And the response header "x-correlator" has same value as the request header "x-correlator"
    And each item of the the response array, if any, complies with the OAS schema at "/components/schemas/Subscription"
