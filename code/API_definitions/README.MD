# WebRTC APIs definitions

This folder contain the OpenAPI definitions of the WebRTC subgroup

## APIs included

* `webrtc-registration` [Registration and Authentication management](webrtc-registration.yaml)
  * This API definition provides functionality for a REST client, browser or native application to manage Registration and Connectivity (RACM) towards Internet Multimedia Subsystem (IMS) Network.
    * [View main on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/webrtc-registration.yaml&nocors)
    * [View main on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/webrtc-registration.yaml)

* `webrtc-call-handling` [Call handling service](webrtc-call-handling.yaml)
  * This API definition provides functionality for REST clients, browser or native application, to create and manage 1-1 calling. Both incoming and outgoing.
    * [View main on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/webrtc-call-handling.yaml&nocors)
    * [View main on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/webrtc-call-handling.yaml)

* `webrtc-events` [WebRTC Event Subscription](webrtc-events.yaml)
  * This API definition provides functionality for REST clients, browser or native application, to track session events. This will allow the client to receive server side updates about new incoming calls and other needed updates regarding the media negotiation and session progress (ringing, hangup, etc).
    * [View main on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/webrtc-events.yaml&nocors)
    * [View main on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/webrtc-events.yaml)

Detailed descriptions, diagrams and more information could be found at [API documentation](../../documentation/API_documentation/) section

## Check APIs online

Use the previous links to check the DEV main version of the API. Copy & paste any raw file to check them:

* ReDoc: https://redocly.github.io/redoc/
* Swagger: https://editor.swagger.io/
* CAMARA dedicated swagger instance: https://camaraproject.github.io/swagger-ui/


## Build HTML from sources

Build an HTML from sources using a local build OpenAPI v3 compatible like Node `redocly/cli`

Execute redocly for each API document, use -o to
```
$ npx @redocly/cli build-docs API_description_file.yaml
```

Or install the tool globaly and then build it
```
$ npm install @redocly/cli -g

$ redocly build-docs API_description_file.yaml
```