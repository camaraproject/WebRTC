# WebRTC API Call Flow

## 1. Purpose

This document provides example call flows for implementers of a WebRTC gateway that exposes WebRTC APIs and interworks with the telco network.

## 2. Assumptions

There are two cases for a WebRTC API Invoker:

- The API Invoker is an application on the end-user device

- The API Invoker is a server of a third-party application service provider

Depending on the above cases, the entities involved in the call flow, the deployment of endpoints receiving event notifications, and the sequence of the call flow will differ.  

This call flow illustrates the former case.

## 3. Entities

The main entities involved in the call flow are as follows:

- **Device Application**：Acts as the WebRTC API Invoker. When the API Invoker is the end user, this is a native application or web application running on the user’s device.

- **API Exposure Function**：Acts as the WebRTC API Provider, and also performs SIP message interworking with the telco network. 

- **Notification Service**：Works with the API Exposure Function to deliver event notifications to the Device Application. 

- **Telco Network**：SIP Proxy/Registrar belonging to the operator's telco network.

- **Remote Endpoint**：The peer in the call using the WebRTC API, which is a SIP application running on a remote device.

The **WebRTC Gateway** consists of the API Exposure Function and the Notification Service.

Since the API Invoker is an end user and the Device Application is not itself an HTTP endpoint for receiving event notifications directly, the following entity is included:

- **Notification Relay**：Receives event notifications from the Notification Service and relays them to the Device Application. In its WebRTC event subscription, the Device Application configures this entity’s HTTP endpoint as the sink. To do so, the Device Application first obtains information about this entity and establishes a connection to receive the relayed notifications. The Notification Relay is considered to be associated with the Device Application, and may be provided either by the Telco Operator or by a third-party application provider. In this flow, the example is given in a way that does not depend on either case.

This call flow also illustrates the authorization procedure involved in using the WebRTC API. Therefore, the following entity is included:

- **OAuth Server**：Performs authentication and authorization of API usage in accordance with the CAMARA ICM specification. Since authorization in the WebRTC API is based on subscriber information, the OAuth Server is assumed to be deployed in the Telco network.


## 4. Call flow diagrams and message examples

The following links show the call flow and major message examples. Message exchanges defined by the WebRTC API are indicated with red arrows. The call flow also explicitly illustrates the sequence for obtaining access tokens associated with WebRTC API requests and for validating those tokens.

- [4.1. Subscription for call-related events](./subscription_for_call-related_events.md)

- [4.2. Registration and expiration subscription](./registration_and_expiration_subscription.md)

- 4.3. Call orignation and disconnection (TBD)

- 4.4. Call termination and disconnection (TBD)

- 4.5. Registration refresh (TBD)

- 4.6. De-registration and unsubscribe notifications (TBD)

