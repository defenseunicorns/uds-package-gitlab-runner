# 🏭 UDS Gitlab Runner Package

[<img alt="Made for UDS" src="https://raw.githubusercontent.com/defenseunicorns/uds-common/refs/heads/main/docs/assets/made-for-uds-silver.svg" height="20px"/>](https://github.com/defenseunicorns/uds-core)
[![Latest Release](https://img.shields.io/github/v/release/defenseunicorns/uds-package-gitlab-runner)](https://github.com/defenseunicorns/uds-package-gitlab-runner/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/defenseunicorns/uds-package-gitlab-runner/release.yaml)](https://github.com/defenseunicorns/uds-package-gitlab-runner/actions/workflows/release.yaml)
[![Nightly Test Status](https://img.shields.io/github/actions/workflow/status/defenseunicorns/uds-package-gitlab-runner/nightly-testing.yaml?label=nightly)](https://github.com/defenseunicorns/uds-package-gitlab-runner/actions/workflows/nightly-testing.yaml)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-gitlab-runner/badge)](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-gitlab-runner)

This package is designed for use as part of a [UDS Software Factory](https://github.com/defenseunicorns/uds-software-factory) bundle deployed on [UDS Core](https://github.com/defenseunicorns/uds-core)

## Pre-requisites

Gitlab-Runner has one dependency, Gitlab.

- Utilizing [uds-package-gitlab](https://github.com/defenseunicorns/uds-package-gitlab) is the quickest and easiest solution for meeting this dependency. 

- If choosing not to use `uds-package-gitlab` be aware that the Gitlab-Runner needs to be connected properly to Gitlab for registering itself and running pipelines as expected. 

## Flavors

 Flavor | Description | Example Creation |
| ------ | ----------- | ---------------- |
| upstream | Uses upstream images within the package. | `zarf package create . -f upstream` |
| registry1 | Uses images from registry1.dso.mil within the package. | `zarf package create . -f registry1` |

## Releases

The released packages can be found in [ghcr](https://github.com/defenseunicorns/uds-package-gitlab-runner/pkgs/container/packages%2Fuds%2Fgitlab-runner).

## General

- `Upstream` flavor is the default
  - To set a different flavor, use the following flag:
    - `--set FLAVOR=registry1`

- For proper registration of a Gitlab-Runner with a Gitlab instance, a secret is created in the `gitlab-runner` namespace called `gitlab-gitlab-runner-secret` which uses the `runner-registration-token` field from the `gitlab` namespace secret called `gitlab-gitlab-runner-secret` to register a runner with a returned [runner authentication token](https://docs.gitlab.com/ee/api/runners.html#create-an-instance-runner).

---

## Deploying

Utilizes [UDS-CLI task runners](https://github.com/defenseunicorns/uds-cli)
- Which means `uds run --list` is available for cli descriptions.

## UDS Tasks (for local dev and CI)

*For local dev, this requires you install [uds-cli](https://github.com/defenseunicorns/uds-cli?tab=readme-ov-file#install)

> :white_check_mark: **Tip:** To get a list of tasks to run you can use `uds run --list`!

## Contributing

Please see the [CONTRIBUTING.md](./CONTRIBUTING.md)

## Development

When developing this package it is ideal to utilize the json schemas for UDS Bundles, Zarf Packages and Maru Tasks. This involves configuring your IDE to provide schema validation for the respective files used by each application. For guidance on how to set up this schema validation, please refer to the [guide](https://github.com/defenseunicorns/uds-common/blob/main/docs/development-ide-configuration.md) in uds-common.
