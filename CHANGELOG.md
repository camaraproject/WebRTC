# Changelog WebRTC


## Table of contents

- **[v0.1.1](#v011)**
- **[v0.1.0](#v010)**

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for each first alpha or release-candidate API version, all changes since the release of the previous public API version
* for subsequent alpha or release-candidate API versions, the delta with respect to the previous pre-release
* for a public API version, the consolidated changes since the release of the previous public API version

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
