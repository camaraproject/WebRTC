<a href="https://github.com/camaraproject/WebRTC/commits/" title="Last Commit"><img src="https://img.shields.io/github/last-commit/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/issues" title="Open Issues"><img src="https://img.shields.io/github/issues/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/pulls" title="Open Pull Requests"><img src="https://img.shields.io/github/issues-pr/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/graphs/contributors" title="Contributors"><img src="https://img.shields.io/github/contributors/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC" title="Repo Size"><img src="https://img.shields.io/github/repo-size/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/blob/main/LICENSE" title="License"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg?style=plastic"></a>
<a href="https://github.com/camaraproject/WebRTC/releases/latest" title="Latest Release"><img src="https://img.shields.io/github/release/camaraproject/WebRTC?style=plastic"></a>
<a href="https://github.com/camaraproject/Governance/blob/main/ProjectStructureAndRoles.md" title="Sandbox API Repository"><img src="https://img.shields.io/badge/Sandbox%20API%20Repository-yellow?style=plastic"></a>

# WebRTC

Sandbox API Repository to describe, develop, document, and test the WebRTC Service API(s). The repository does not yet belong to a CAMARA Sub Project.

* API Repository [wiki page](https://lf-camaraproject.atlassian.net/wiki/x/MS7e)

## Scope
* Service APIs for “WebRTC” (see APIBacklog.md)  
* It provides the API consumer with the ability to:  
  * Add real-time communication capabilities to their applications like video, voice, and generic data.
  * Enable an API consumer to register for communication services through a network using Oauth 2.0 and OIDC.
  * Create subscriptions to receive call notifications using CloudEvents: Ability to follow the call establishment process and to receive new incoming calls.
  * Make and receive calls from the API consumer (client) side establishing a realiable media session to securely exchange media.
* Describe, develop, document and test the APIs (with 1-2 Telcos)  
* Started: September 2023

<!-- CAMARA:RELEASE-INFO:START -->
<!-- The following section is automatically maintained by the CAMARA project-administration tooling: https://github.com/camaraproject/project-administration -->

## Release Information

> [!NOTE]
> Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until a new release is created. For example, changes may be reverted before a release is created. **For best results, use the latest available release**.

* **NEW**: The latest public release is [r2.2](https://github.com/camaraproject/WebRTC/releases/tag/r2.2) (Fall25), with the following API versions:
  * **webrtc-call-handling v0.3.0**
  [[YAML]](https://github.com/camaraproject/WebRTC/blob/r2.2/code/API_definitions/webrtc-call-handling.yaml)
  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r2.2/code/API_definitions/webrtc-call-handling.yaml&nocors)
  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r2.2/code/API_definitions/webrtc-call-handling.yaml)
  * **webrtc-events v0.2.0**
  [[YAML]](https://github.com/camaraproject/WebRTC/blob/r2.2/code/API_definitions/webrtc-events.yaml)
  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r2.2/code/API_definitions/webrtc-events.yaml&nocors)
  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r2.2/code/API_definitions/webrtc-events.yaml)
  * **webrtc-registration v0.3.0**
  [[YAML]](https://github.com/camaraproject/WebRTC/blob/r2.2/code/API_definitions/webrtc-registration.yaml)
  [[ReDoc]](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r2.2/code/API_definitions/webrtc-registration.yaml&nocors)
  [[Swagger]](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r2.2/code/API_definitions/webrtc-registration.yaml)
* The latest public release is always available here: https://github.com/camaraproject/WebRTC/releases/latest
* Other releases of this repository are available in https://github.com/camaraproject/WebRTC/releases
* For changes see [CHANGELOG.md](https://github.com/camaraproject/WebRTC/blob/main/CHANGELOG.md)

_The above section is automatically synchronized by CAMARA project-administration._
<!-- CAMARA:RELEASE-INFO:END -->

## API Extra documentation

* Find API reference documentation at folder: [code/API_definitions](code/API_definitions/)
* Find API testing documentation at folder: [code/Test_definitions](code/Test_definitions/)
* Find release status documentation at folder: [documentation/API_documentation](documentation/API_documentation)
* Find UML and complementary documentation at folder: [documentation/SupportingDocuments](documentation/SupportingDocuments)
* For other information refer to [Confluence CAMARA project wiki](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/14560817/WebRTC)

## Meetings
* Meetings are held virtually
  * Find meeting notes at https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/14564608/Minutes+-+WebRTC
* Schedule:
  * Tuesdays 4pm CEST (Madrid, Paris, Berlin, Rome), each 15 days
  
## Contributorship and mailing list

* To subscribe / unsubscribe to the mailing list of this Sub Project and thus be / resign as Contributor please visit <https://lists.camaraproject.org/g/sp-rtc>.
* A message to all Contributors of this Sub Project can be sent using <sp-rtc@lists.camaraproject.org>.
