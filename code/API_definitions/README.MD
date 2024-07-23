# WebRTC API definitions

This folder contain the OpenAPI v3 definition of the WebRTC API

## APIs included

* [Registration and Authentication management](BYON-RACM-Service.yaml)
  * This API definition provides functionality for a REST client, browser or native application to manage Registration and Connectivity (RACM) towards Internet Multimedia Subsystem (IMS) Network.
    * [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/BYON-RACM-Service.yaml&nocors)
    * [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/BYON-RACM-Service.yaml)
  
* [Notification Channel management](BYON-Notification-Channel.yaml)
  * This API definition provides functionality for a REST client, browser or native application, to establish notification channel to receive asynchronous notifications from MNO's IMS Network.
    * [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/BYON-Notification-Channel.yaml&nocors)
    * [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/BYON-Notification-Channel.yaml) 

* [CallHandling service](BYON-CallHandling-Service.yaml)
  * This API definition provides functionality for REST clients, browser or native application, to create and manage 1-1 calling. Both incoming and outgoing.
    * [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/BYON-CallHandling-Service.yaml&nocors)
    * [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/main/code/API_definitions/BYON-CallHandling-Service.yaml)

Detailed descriptions, diagrams and more information could be found at [API documentation](../../documentation/API_documentation/) section

## Check APIs online

Use the previous links to check the DEV main version of the API. Copy & paste any raw file to check them:

* ReDoc: https://redocly.github.io/redoc/
* Swagger: https://editor.swagger.io/


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