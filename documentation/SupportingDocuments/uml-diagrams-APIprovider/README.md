# WebRTC API call flows

## 1. General

This document provides example call flows and messages based on WebRTC API user story for implementers of a WebRTC Gateway that exposes WebRTC APIs and interworks with telco network.

## 2. Actors

The involved actors in the call flows are as follows:

- **Device Application**：A native application or web application running on the user’s device.

- **Application Server**: Acts as a WebRTC API Invoker.

- **Auth Server**: Performs auth for API usage in accordance with the CAMARA ICM specification.

- **WebRTC Gateway**: Acts as a WebRTC API provider, and also interworks with telco network.

- **Telco Network**： Acts as signalling (SIP) & media servers.

- **Remote Endpoint**：The peer in the call using the WebRTC API.


## 3. List of call flow examples

The following links provide call flow diagrams and message examples.

- 3.1. [Subscription for WebRTC events](./subscription_for_webrtc_events.md)
- 3.2. WebRTC registration
- 3.3. Call orignation and disconnection (TBD)
- 3.4. Call termination and disconnection (TBD)

The message examples illustrate the fields necessary for implementing a WebRTC Gateway, including all defined optional fields where applicable.  
Although the API specification defines fields for [API-design-guidline](https://github.com/camaraproject/Commonalities/blob/main/documentation/API-design-guidelines.md) consistency, those not applicable in the WebRTC API are excluded from the message examples.
