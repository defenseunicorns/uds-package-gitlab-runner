# 🏭 UDS Gitlab Runner Package

[<img alt="Made for UDS" src="https://raw.githubusercontent.com/defenseunicorns/uds-common/refs/heads/main/docs/assets/made-for-uds-silver.svg" height="20px"/>](https://github.com/defenseunicorns/uds-core)
[![Latest Release](https://img.shields.io/github/v/release/defenseunicorns/uds-package-gitlab-runner)](https://github.com/defenseunicorns/uds-package-gitlab-runner/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/defenseunicorns/uds-package-gitlab-runner/release.yaml)](https://github.com/defenseunicorns/uds-package-gitlab-runner/actions/workflows/release.yaml)
[![Nightly Test Status](https://img.shields.io/github/actions/workflow/status/defenseunicorns/uds-package-gitlab-runner/nightly-testing.yaml?label=nightly)](https://github.com/defenseunicorns/uds-package-gitlab-runner/actions/workflows/nightly-testing.yaml)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-gitlab-runner/badge)](https://api.securityscorecards.dev/projects/github.com/defenseunicorns/uds-package-gitlab-runner)

This package is designed for use as part of a [UDS Software Factory](https://github.com/defenseunicorns/uds-software-factory) bundle deployed on [UDS Core](https://github.com/defenseunicorns/uds-core)
> GitLab Runner is a software application that executes CI/CD jobs defined in a GitLab project, automating tasks like building, testing, and deploying code. It can run jobs on various platforms, including local machines, virtual machines, and cloud-based environments.

## Pre-requisites

Gitlab-Runner has one dependency, Gitlab, and using [uds-package-gitlab](https://github.com/defenseunicorns/uds-package-gitlab) is the quickest and easiest solution for meeting this dependency.  You can learn more about configuring GitLab in various deployment scenarios in the [configuration documentation](./docs/configuration.md)

## Releases

The released packages can be found in [ghcr](https://github.com/defenseunicorns/uds-package-gitlab-runner/pkgs/container/packages%2Fuds%2Fgitlab-runner).

## UDS Tasks (for local dev and CI)

*For local dev, this requires you install [uds-cli](https://github.com/defenseunicorns/uds-cli?tab=readme-ov-file#install)

> :white_check_mark: **Tip:** To get a list of tasks to run you can use `uds run --list`!

## Contributing

Please see the [CONTRIBUTING.md](./CONTRIBUTING.md)

## Development

When developing this package it is ideal to utilize the json schemas for UDS Bundles, Zarf Packages and Maru Tasks. This involves configuring your IDE to provide schema validation for the respective files used by each application. For guidance on how to set up this schema validation, please refer to the [guide](https://github.com/defenseunicorns/uds-common/blob/main/docs/uds-packages/development/development-ide-configuration.md) in uds-common.
