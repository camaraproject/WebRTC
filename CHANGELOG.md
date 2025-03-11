# Changelog WebRTC


## Table of contents

- **[r1.2](#r12)**
- **[r1.1](#r11)**
- **[v0.1.1](#v011)**
- **[v0.1.0](#v010)**

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the [latest](https://github.com/camaraproject/WebRTC/releases/latest) published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r1.2

## Release Notes

This public release contains the definition and documentation of

* webrtc-registration v0.2.0
* webrtc-call-handling v0.2.0
* webrtc-events v0.1.0

The API definition(s) are based on

* Commonalities r2.3
* Identity and Consent Management r2.3

Changelog since latest public v0.1.1

* Full Changelog with the list of PRs and contributors: https://github.com/camaraproject/WebRTC/compare/v0.1.1...r1.2

## WebRTC Registration v0.2.0

**There are breaking changes compared to v0.1.1.**: the API use has been simplified for API consumers using a three-legged access token to invoke the API. In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token. In this context also some error response codes have been renamed or replaced to comply with latests Commonalities.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-registration.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-registration.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/WebRTC/blob/r1.2/code/API_definitions/webrtc-registration.yaml)

### Added
* YAML inline documentation at PR #67
* Commonalites aligment 0.5 at PR #65
* Included base testing scenarios at PR #69
* Included basic error testing at PR #71

### Changed
* API naming to WebRTC Registarion and filename `webrtc-registration.yaml` PR #59
* Server `url` based on Commonalities 0.5 at PR #59
* Security schema `openId` based on Commonalities 0.5 at PR #65
* Response code based on Commonalities 0.5 at PR #65
* Term `RACM` is replaced by `Registration` or `reg` suffix
* TransactionId header (required) was replaced by x-correlator header (optional)

### Fixed
* Descriptions and relevant information for all documentation and schemas
* Descriptions updates and references
* Commonalities alignment with r2.3 (Responses and documentation)
* Responses review : 400, 401, 403 included
* PUT registration responds with 204 No content instead of 200

### Removed
* `BYON` terminology and API naming
* `notificationChannel` API related paramter `channelId` at PR #67
* `BearerAuth` in favor of `openId` as security schema at PR #65
* Removed generic 5xx reponses

## WebRTC Call Handling v0.2.0

**There are breaking changes compared to v0.1.1.**: the API use has been simplified for API consumers using a three-legged access token to invoke the API. In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token. In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-call-handling.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-call-handling.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/WebRTC/blob/r1.2/code/API_definitions/webrtc-call-handling.yaml)

### Added
* YAML inline documentation at PR #68
* Commonalites aligment 0.5 at PR #65
* Included base testing scenarios at PR #69
* Included basic error testing

### Changed
* API naming to WebRTC Call Handling and filename `webrtc-call-handling.yaml` PR #59
* Server `url` based on Commonalities 0.5 at PR #59
* Security schema `openId` based on Commonalities 0.5 at PR #65
* Response code based on Commonalities 0.5 at PR #65
* `MediaSessionInformation` schema expanded, to include all fields used related to a single voice-video session at PR #56
* `SessionNotification` schema updated at PR #56
  * It aligns this API with the WebRTC Event notification service. So `SessionNotification` schema, now, its just a wrapper for `MediaSessionInformation` schema. This way, the developer only need to use one object for notification and voice-video session updates (POST / PUT operations).
* Term `RACM` is replaced by `Registration` or `reg` suffix
* Suffix `vvoip` is replaced by `media` to identify media sessions, like calls, video-calls or any media session
* TransactionId header (required) was replaced by x-correlator header (optional)

### Fixed
* Descriptions and relevant information for all documentation and schemas
* Descriptions updates and references
* Commonalities alignment with r2.3 (Responses and documentation)
* Responses review : 400, 401, 403 included

### Removed
* `BYON` terminology and API naming
* `BearerAuth` in favor of `openId` as security schema at PR #65
* `SessionNotification` schema updated at PR #56
  * `SessionInvitationNotification` - Became part of `SessionNotification` 
  * `SessionStatusNotification` - Became part of `SessionNotification` 
* Removed generic 5xx reponses

## WebRTC Events v0.1.0

**This version defines a new API:**

Initial version covering the following functionality and related endpoints:

* API to subscribe to call events. Bringing server-side updates about a voice video session in progress or during negotiation.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-events.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.2/code/API_definitions/webrtc-events.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/WebRTC/blob/r1.2/code/API_definitions/webrtc-events.yaml)

### Added
* YAML inline documentation at PR #53
* Commonalites aligment 0.5 at PR #66
* Included `subscriptions` endpoint to create CloudEvents subscrition at PR #53
  * Endpoints can now define a callback and receive server-side events using CloudEvents
  * Endpoints can now receive callback events regarding new available audio-video sessions (call incomming)
  * Endpoints can now receive callback events regarding session establishment updates like network changes and remote session termination (call progress and call hangup)
* Included base testing scenarios at PR #69
* Included basic error testing

### Changed
* Term `RACM` is replaced by `Registration` or `reg` suffix
* Suffix `vvoip` is replaced by `media` to identify media sessions, like calls, video-calls or any media session

### Fixed
* Commonalities alignment with r2.3 (Responses and documentation)

# r1.1

## Release Notes

This pre-release contains the definition and documentation of

* webrtc-registration v0.2.0-rc.1
* webrtc-call-handling v0.2.0-rc.1
* webrtc-events v0.1.0-rc.1

The API definition(s) are based on

* Commonalities r2.1 (v0.5.0-rc.1)
* Identity and Consent Management r2.1 (v0.3.0-rc.1)
  
## WebRTC Registration v0.2.0-rc.1

webrtc-registration v0.2.0-rc.1 is the release candidate of the version 0.2.0 of the API

**There are breaking changes compared to v0.1.1.**: the API use has been simplified for API consumers using a three-legged access token to invoke the API. In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token. In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.1/code/API_definitions/webrtc-registration.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.1/code/API_definitions/webrtc-registration.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/WebRTC/blob/r1.1/code/API_definitions/webrtc-registration.yaml)

### Added
* YAML inline documentation at PR #67
* Commonalites aligment 0.5 at PR #65
* Included base testing scenarios at PR #69

### Changed
* API naming to WebRTC Registarion and filename `webrtc-registration.yaml` PR #59
* Server `url` based on Commonalities 0.5 at PR #59
* Security schema `openId` based on Commonalities 0.5 at PR #65
* Response code based on Commonalities 0.5 at PR #65

### Fixed
* Descriptions and relevant information for all documentation and schemas

### Removed
* `BYON` terminology and API naming
* `notificationChannel` API related paramter `channelId` at PR #67
* `BearerAuth` in favor of `openId` as security schema at PR #65

## WebRTC Call Handling v0.2.0-rc.1

webrtc-call-handling v0.2.0-rc.1 is the release candidate of the version 0.2.0 of the API

**There are breaking changes compared to v0.1.1.**: the API use has been simplified for API consumers using a three-legged access token to invoke the API. In these cases the optional `device` parameter MUST NOT be provided, as the subject will be uniquely identified from the access token. In this context also some error response codes have been renamed or replaced to comply with Commonalities 0.5.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.1/code/API_definitions/webrtc-call-handling.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.1/code/API_definitions/webrtc-call-handling.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/WebRTC/blob/r1.1/code/API_definitions/webrtc-call-handling.yaml)

### Added
* YAML inline documentation at PR #68
* Commonalites aligment 0.5 at PR #65
* Included base testing scenarios at PR #69

### Changed
* API naming to WebRTC Call Handling and filename `webrtc-call-handling.yaml` PR #59
* Server `url` based on Commonalities 0.5 at PR #59
* Security schema `openId` based on Commonalities 0.5 at PR #65
* Response code based on Commonalities 0.5 at PR #65
* `MediaSessionInformation` schema expanded, to include all fields used related to a single voice-video session at PR #56
* `SessionNotification` schema updated at PR #56
  * It aligns this API with the WebRTC Event notification service. So `SessionNotification` schema, now, its just a wrapper for `MediaSessionInformation` schema. This way, the developer only need to use one object for notification and voice-video session updates (POST / PUT operations).

### Fixed
* Descriptions and relevant information for all documentation and schemas

### Removed
* `BYON` terminology and API naming
* `BearerAuth` in favor of `openId` as security schema at PR #65
* `SessionNotification` schema updated at PR #56
  * `SessionInvitationNotification` - Became part of `SessionNotification` 
  * `SessionStatusNotification` - Became part of `SessionNotification` 

## WebRTC Events v0.1.0-rc.1

webrtc-events v0.1.0-rc.1 is the release candidate of the version 0.1.0 of the API

**This version defines a new API:**

Initial version covering the following functionality and related endpoints:

* API to subscribe to call events. Bringing server-side updates about a voice video session in progress or during negotiation.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.1/code/API_definitions/webrtc-events.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/WebRTC/r1.1/code/API_definitions/webrtc-events.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/WebRTC/blob/r1.1/code/API_definitions/webrtc-events.yaml)

### Added
* YAML inline documentation at PR #53
* Commonalites aligment 0.5 at PR #66
* Included `subscriptions` endpoint to create CloudEvents subscrition at PR #53
  * Endpoints can now define a callback and receive server-side events using CloudEvents
  * Endpoints can now receive callback events regarding new available audio-video sessions (call incomming)
  * Endpoints can now receive callback events regarding session establishment updates like network changes and remote session termination (call progress and call hangup)
* Included base testing scenarios at PR #69
  
### Changed
* n/a

### Fixed
* n/a

### Removed
* n/a

# v0.1.1

## Release Notes

This release contains the definition and documentation of
* BYON API v0.1.1
<!--* API-name2 vx.y.z - unchanged-->
<!--In case the repository (and hence its release) contains multiple APIs, list them all here. Also mention if an API in the repository is unchanged. Note: There shall be no "wip" API version in the repository at the time of release.-->

<!--For any API version, if known, and for public API versions, include the references to the related Commonalities and ICM versions as follows:-->
The API definition(s) are based on
* Commonalities v0.2.0
* Identity and Consent Management v0.1.0

<!--In case the repository contains multiple APIs, for each API version that changed in this release, create additional sections by copying and filling the below template (level 2 and 3 sections), replacing the API-name and API-version-x.y.z with actual API name and version.-->

## BYON API v0.1.1

**BYON API v0.1.1 is a pre-relese version**

- [API definition](https://github.com/camaraproject/WebRTC/tree/v0.1.1/code/API_definitions) 
- [API Documentation](https://github.com/camaraproject/WebRTC/blob/v0.1.1/documentation/API_documentation/webrtc%20voice%20api.md)

### Please note
This is a pre-release version, and should be considered as a draft for further development
There are bug fixes and breaking changes to be expected in later versions
The release is suitable for test implementations, but it is not recommended for use in production environments

### Added
- Update BYON-CallHandling-Service.yaml - 201 session created, 200 session updated, 204 session updated & examples (check [PR44](https://github.com/camaraproject/WebRTC/pull/44))

### Changed
- Update BYON-Calling, BYON-RACM, BYON-Notification: resourceURL to sessionId/channelId (check [PR29](https://github.com/camaraproject/WebRTC/pull/29))
- Documentation is extended and flows diagrams are added (check [PR42](https://github.com/camaraproject/WebRTC/pull/42))

### Fixed
NA.

### Removed
NA.

# v0.1.0

## Release Notes

This release contains the definition and documentation of
* BYON API v0.1.0
<!--* API-name2 vx.y.z - unchanged-->
<!--In case the repository (and hence its release) contains multiple APIs, list them all here. Also mention if an API in the repository is unchanged. Note: There shall be no "wip" API version in the repository at the time of release.-->

<!--For any API version, if known, and for public API versions, include the references to the related Commonalities and ICM versions as follows:-->
The API definition(s) are based on
* Commonalities v0.2.0
* Identity and Consent Management v0.1.0

<!--In case the repository contains multiple APIs, for each API version that changed in this release, create additional sections by copying and filling the below template (level 2 and 3 sections), replacing the API-name and API-version-x.y.z with actual API name and version.-->

## BYON API v0.1.0

**BYON API v0.1.0 is a pre-relese version**

- [API definition](https://github.com/camaraproject/WebRTC/tree/v0.1.0/code/API_definitions) 
- [API Documentation](https://github.com/camaraproject/WebRTC/blob/v0.1.0/documentation/API_documentation/webrtc%20voice%20api.md)

### Please note
This is a pre-release version, and should be considered as a draft for further development
There are bug fixes and breaking changes to be expected in later versions
The release is suitable for test implementations, but it is not recommended for use in production environments

### Added
Initial contribution of API spec WebRTC BYON including:

- Registration and Authentication Management
- Notification Handling
- One to One Calling

### Changed
NA. This is the first pre-release

### Fixed
NA. This is the first pre-release

### Removed
NA. This is the first pre-release
