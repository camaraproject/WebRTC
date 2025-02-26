<a href="https://github.com/camaraproject/WebRTC/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>

# WebRTC
Repository to describe, develop, document and test the WebRTC APIs

## Scope
* Service APIs for “WebRTC” (see APIBacklog.md)  
* It provides the API consumer with the ability to:  
  * Add real-time communication capabilities to their applications like video, voice, and generic data.
  * Enable a web endpoint to register for telco services (IMS) through a WebRTC Gateway using Oauth 2.0 and the Operator provided Identity Provider (IDP)
  * Create subscriptions to receive telco call events using CloudEvents: Ability to follow call estalishment process and to receive new incoming calls.
  * Make and receive calls from the endpoint (client) side establishing a realiable media WebSocket channel to exchange secure media.
* Describe, develop, document and test the APIs (with 1-2 Telcos)  
* Started: September 2023
* Location: virtually  

## Release Information

* The latest public release is available here: https://github.com/camaraproject/WebRTC/releases/latest
* For changes see [CHANGELOG.md](CHANGELOG.md)
* Note: Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest public release**.

* The latest release is **[r1.2](https://github.com/camaraproject/WebRTC/tree/r1.2) (Spring25 meta-release)** with the following API definitions:
  
  * **webrtc-registration v0.2.0**
  [[YAML]](https://github.com/camaraproject/WebRTC/blob/r1.2/code/API_definitions/webrtc-registration.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-registration.yaml&nocors)
  [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-registration.yaml)

  * **webrtc-call-handling v0.2.0**
  [[YAML]](https://github.com/camaraproject/WebRTC/blob/r1.2/code/API_definitions/webrtc-call-handling.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-call-handling.yaml&nocors)
  [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-call-handling.yaml)

  * **webrtc-events v0.1.0**
  [[YAML]](https://github.com/camaraproject/WebRTC/blob/r1.2/code/API_definitions/webrtc-events.yaml)
  [[View it on ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-events.yaml&nocors)
  [[View it on Swagger Editor]](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-events.yaml)

* Previous releases and pre-releases are available here: https://github.com/camaraproject/WebRTC/releases
* For changes see [CHANGELOG.md](https://github.com/camaraproject/WebRTC/blob/main/CHANGELOG.md)

## API Extra documentation

* Find API reference documentation at folder: [code/API_definitions](code/API_definitions/)
* Find API testing documentation at folder: [code/Test_definitions](code/Test_definitions/)
* Find detailed detailed API explanations at folder: [documentation/API_documentation](documentation/API_documentation)
* Find other complementary documentation at folder: [documentation/SupportingDocuments](documentation/SupportingDocuments)
* For other information refer to [Confluence CAMARA project wiki](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/14560817/WebRTC)

## Meetings
* Meetings are held virtually
  * Find meeting notes at https://wiki.camaraproject.org/display/CAM/WebRTC+Meeting+Minutes
* Schedule:
  * Tuesdays 4pm CEST (Madrid, Paris, Berlin, Rome), each 15 days
  
## Contributorship and mailing list

* To subscribe / unsubscribe to the mailing list of this Sub Project and thus be / resign as Contributor please visit <https://lists.camaraproject.org/g/sp-rtc>.
* A message to all Contributors of this Sub Project can be sent using <sp-rtc@lists.camaraproject.org>.
