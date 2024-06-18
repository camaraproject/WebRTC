# Overview

Bring your own number (BYON) service aims to provide consumers with the ability to use their phone number (MSISDN) for outgoing and incoming calls from non-SIM card devices. To access the service, users are required to authenticate using their digital credentials associated with their MNO account, in example their operator app credentials. As registration from a web endpoint is necessary to enable the service on non-SIM card devices.

Outgoing calls made through the service will display the user's MSISDN as the caller number, ensuring that the recipient recognizes the user's phone number on their caller ID.

Incoming calls introduce a unique functionality whereby multiple devices will ring simultaneously. This includes the user's smartphone and the web endpoint they have registered from. This design enables users to conveniently answer calls from any of these devices, depending on their preference or accessibility. The service is compatible with various devices that support web browsing environments, such as laptops, PCs, and XR immersive glasses.

The service specification emphasises the accessibility and flexibility of utilising one's phone number across different non-SIM card devices. By leveraging this web-based service, users can extend their communication capabilities beyond traditional SIM-based devices, enhancing their overall communication experience.

## Introduction

This service brings new functionalities for the WebRTC services whose idea is to integrate BYON API to maintain the client number in out-bound and in-bound calls from web comms service.

**Out-bound calls:**

- Recipient receives call as if it was from User's normal phone number.
- Maintains common number through web communication service and standard subscription.
- Facilitates number recognition and call-back for co-workers, partners and/or clients.

**In-bound calls:**

- Receive phone calls simultaneously on phone subscription and web communication service.
- Presents 'Occupied user' info to caller user is already in phone call.
- Facilitates common multi-channel contact with co-workers, partners and/or clients.

## API Spec

### Roles, Actors and Scope

Roles: Customer-user

Actors: Application service providers, hyperscalers, application developers.

Scope:

1. Register to Network – Register the client endpoint instance to MNO's IMS Network.
2. Create Notification Channel – Create Notification channel of specified type to receive notifications from the network (e.g. incoming call).  
3. Place an Out Call – Place an outbound voice call request to the MNO's IMS Network.
4. Receive an Incoming Call - Receive an incoming call request from the MNO's IMS network. 

### Authentication and Authorization

The defined APIs uses OAUTH 2.0 client credentials and uses the Access Token granted by the CSP's IDP for its usage. This must be the initial procedure to be completed before invoking any of the service APIs.

### Pre-Conditions

The preconditions are listed below:

- The customer-user must have operator/MNO (provider of the native MSISDN) provided credentials to login to the web app. 

### Activities/Steps

- Starts when: The customer-user logs into the communication application in the browser.
- Ends when: The customer-user logs out of the communication application in the browser or closes the browser.

### Post-Conditions

The customer-user places an outgoing voice call or accepts an incoming voice call.

### Exceptions

Several exceptions might occur during the API operations,

- Unauthorized: Invalid credentials.
- \<additional ones to be added\>

### API Endpoint details

**Registration and Connection Management (RACM)**

| Endpoint | Operation | Description |
| --- | --- | --- |
| POST /session | Create a RACM session | Registers the client instance into MNO's IMS Network via the WebRTC Gateway. This request will include the Access Token received from the MNO's IDP (auth server).On successful RACM session creation, the client endpoint reusing the device's MSISDN will be successfully registered in MNO's IMS network, ready to accept any call origination or termination request. |
| PUT /session/{sessionId} | Modify a RACM session | This modification request is to share refreshed Access Token received from MNO's IDP (auth server). |
| DELETE /session/{sessionId} | Delete a RACM session | When the customer-user gracefully logs out of the application, the RACM session will be deleted, resulting in de-registration from the MNO's IMS network. |

**Notification Channel Management**

| Endpoint | Operation | Description |
| --- | --- | --- |
| POST /channels | Create a Notification channel | Creates a notification channel of specified type (e.g. Websocket, PNS, webhook) in order to receive notifications from the network. These notification channels will be used to send following notifications from the network,
- Incoming call (network -\> client)
- Any other notifications from the network such as call setup status, call modification status, etc.
 |

**OneToOne Call (outgoing)**

| Endpoint | Operation | Description |
| --- | --- | --- |
| POST /session | Create a Voice session | Create an Outbound (1-1) Voice session. This request when received at the WebRTC GW triggers an outgoing call request into the MNO's IMS network. The call setup status (inprogress, ringing, connected, release) is sent over the websocket notification channel. |
| PUT /session/{sessionId}/status | Modify a Voice session | This modification request is to modify the call object attributes such as media properties included in the SDP (e.g. call placed on hold). |
| DELETE /session/{sessionId} | Delete a Voice session | When the call is released from the client's end, the corresponding Voice session object is deleted, which will trigger the WebRTC GW to initiate a Call release into the CSP's IMS network. |
| | | When the call is released from the network's end, the call release notification is sent over the websocket notification channel, which will result in deleting of the Voice session object. |

**OneToOne Call (incoming)**

| Endpoint | Operation | Description |
| --- | --- | --- |
| | | Notification for inbound call is received via the websocket notification channel. The Voice session object is created by default prior to sending this inbound call notification. |
| PUT /session/{sessionId}/status | Modify a Voice session | This modification request is to modify the call object attributes such as media properties included in the SDP (e.g. call placed on hold). |
| DELETE /session/{sessionId} | Delete a Voice session | When the call is terminated from the client's end, the corresponding Voice session object is deleted, which will trigger the WebRTC GW to initiate a Call release into the MNO's IMS network. |
| | | When the call is released from the network's end, the call release notification is sent over the websocket notification channel, which will result in deleting of the Voice session object. |
