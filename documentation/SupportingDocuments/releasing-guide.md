# Releasing guide

A short, practical summary of how this repository is released. The authoritative documentation lives in [ReleaseManagement](https://github.com/camaraproject/ReleaseManagement/tree/main/documentation) and on the [CAMARA wiki](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/14551399/Meta-release+Process). If this guide and those sources disagree, they win.

## Key concepts

* **Meta-release**: a coordinated CAMARA release cycle (e.g. `Sync26`). It sets the calendar and the Commonalities / ICM versions APIs must align with.
* **Release tag `rX.Y`**: `X` identifies the release cycle, `Y` increments with every release inside that cycle (alpha, rc or public). Tags are never reused.
* **Release types**: `pre-release-alpha`, `pre-release-rc`, `public-release`, `maintenance-release`. Every API in the release must have at least the matching status (`alpha`, `rc`, `public`).
* **Releases are automated.** Codeowners never create tags or GitHub releases manually; they drive the process with comments on the Release Issue.

## Milestones that matter for API repositories

| Milestone | Meaning |
|-----------|---------|
| M3 | API release candidate published |
| M4 | API public release published |
| M5 | Meta-release published (Release Management) |
| M6 | Meta-release retrospective |

Milestone dates are set per meta-release on its wiki page, linked from the [Meta-release Process](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/14551399/Meta-release+Process) page (e.g. [Sync26 meta-release](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/268533761/Sync26+meta-release+ex-Fall26)). Changes to dates are announced in [Announcements by Release Management](https://lf-camaraproject.atlassian.net/wiki/spaces/CAM/pages/14550614).

## Release steps

1. **Plan**
   1. Update [`release-plan.yaml`](../../release-plan.yaml) on `main` with `target_release_tag`, `target_release_type`, the Commonalities / ICM dependencies and, per API, `target_api_version` and `target_api_status`.
   2. Once merged, a **Release Issue** is created automatically (state `PLANNED`).
2. **Develop**
   1. Merge all intended changes to `main`, keep API versions as `wip`, and keep CI checks green.
3. **Snapshot**
   1. Comment `/create-snapshot` on the Release Issue.
   2. Automation validates the repository and opens a **Release PR** (state `SNAPSHOT ACTIVE`).
4. **Review**
   1. Complete `CHANGELOG-rX.md` directly on the release-review branch of the Release PR (fill Breaking changes / Added / Changed / Fixed / Removed per API from the generated PR list).
   2. Get codeowner and release reviewer approvals, then merge the Release PR (state `DRAFT READY`).
5. **Publish**
   1. Check the draft in GitHub Releases, then comment `/publish-release --confirm rX.Y`.
   2. Automation creates the tag, the `release/rX.Y` or `pre-release/rX.Y` branch, and a post-release sync PR, and closes the Release Issue.
6. **Sync**
   1. Merge the `pr-to-main/rX.Y` PR and delete its branch.
   2. After merge, `main` now carries the CHANGELOG and README of the release.

## When something is wrong

Only the CHANGELOG can be edited during review. A problem anywhere else (API definitions, test definitions, README) means cancelling the current attempt and starting a new snapshot.

The command to cancel depends only on whether the Release PR has been merged:

| Release PR | State | Command | What it removes |
|------------|-------|---------|-----------------|
| Still open | `SNAPSHOT ACTIVE` | `/discard-snapshot <reason>` | Release PR, snapshot and release-review branches |
| Already merged | `DRAFT READY` | `/delete-draft <reason>` | Draft GitHub release |

In both cases the release goes back to `PLANNED`. Then:

1. Fix the problem on `main` through a regular PR and merge it.
2. Comment `/create-snapshot` again.

Once `/publish-release` has run there is nothing to cancel: the release is public and the fix goes into the next `rX.Y`.

To drop a planned release, set `target_release_type: none` in `release-plan.yaml`.

## Typical sequence in a meta-release

1. `rX.1` as `pre-release-rc` (M3), aligned with the meta-release Commonalities / ICM versions.
2. Further `rX.2`, `rX.3`… release candidates if API changes are needed after review.
3. Final `rX.Y` as `public-release` (M4), with all APIs set to `public` and the [API readiness checklist](https://github.com/camaraproject/ReleaseManagement/blob/main/documentation/readiness/api-readiness-checklist.md) completed (notably test definitions covering the API operations).
