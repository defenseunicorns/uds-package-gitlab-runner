# 1. Record architecture decisions

Date: 2024-02-27

## Status

Accepted

## Context

When using GitLab runner there is often a desire for a developer to create and manage their own images for a pipeline or to simply be able to use images that are already within their environment somewhere within their CI pipeline (this may include proprietary scanners and other software that is not managed / maintained through Zarf or by the same SRE team that manages a Zarf / UDS installation).

In order to enable this there are two potential paths:

1. Mark the GitLab runner sandbox namespace with the `zarf.dev/agent=ignore` label (configurably) and manually mutate any remaining images (i.e. GitLab runner helper / istio)

**Pros:**

- Allows on-prem delivery personas (Ezra) to configure the k8s runner to their needs (even in a separate cluster) while still getting benefit from `uds-core` (netpols, istio, etc)
- Allows on-prem developer personas (Kay) to manage their images more closely to the development lifecycle without having to wait on a Change Management process to change a dev image
- Can be easily disabled if a given environment / customer requires all images on the runner to exist in Zarf

**Cons:**

- Requires more care when configuring egress policies for the cluster to ensure images can't be pulled from anywhere (especially in non-true-airgaps)


2. Force the creation of runners outside of our `uds-package-gitlab-runner` Package for this use case (even if it was in a separate cluster)

**Pros:**

- Ensures Zarf handles all images in the cluster meaning they have been SBOMed and have likely have gone through a formal Change Management process.

**Cons:**

- Requires on-prem delivery personas (Ezra) to create a secondary solution (without `uds-core`) if they want runners that pull from other registries in the environment.
- Requires on-prem developer personas (Kay) to wait for a Change Management process if Ezra has not yet configured a secondary solution.

> [!NOTE]
> The Software Factory team does intend to support the [`fleeting` plugin](https://docs.gitlab.com/runner/fleet_scaling/fleeting.html) from GitLab as another alternative to K8s runners though this will only be supported for cloud environments.  Local environments would likely still fall back to a K8s based solution, in a separate cluster if possible.

## Decision

We decided to allow the sandbox namespace Zarf agent ignore label to be configured (being on by default) and for the runner package to be installable separate from the cluster that GitLab runs within.

## Consequences

Delivery personas (Ezra) will need to ensure that the egress rules for a cluster are configured correctly so that only expected image registries can be pulled from or will need to intentionally disable this feature and work with their customers for alternatives.  `uds-core` will also need to implement features to allow Istio proxy injection in ignored namespaces and likely want/need to provide image validation features within the pepr operator to help Ezra protect image pull egress / images that run within the cluster.
