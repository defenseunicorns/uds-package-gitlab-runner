# Configuration

GitLab Runners in this package are configured through the upstream [GitLab Runner chart](https://docs.gitlab.com/runner/install/kubernetes.html) as well as a UDS configuration chart that supports the following:

## Networking

<!-- TODO: (@WSTARR) Link practices into the common repo once https://github.com/defenseunicorns/uds-software-factory/pull/62 is merged -->
Network policies are controlled via the `uds-gitlab-runner-config` chart in accordance with the [common patterns for networking within UDS Software Factory]().  Because GitLab runners do not interact with external resources like databases or object storage they only implement `custom` networking for both the runner namespace and the runner sandbox namespace:

- `custom`: sets custom network policies for the GitLab runner namespace - note this is _not_ where jobs run and is the orchestration side of the GitLab runner deployment.
- `customSandbox`: sets custom network policies for the GitLab runner sandbox namespace - this is where jobs will execute and can be used to allow them to access external services.

## Runner

Additional runner configuration can be achieved by setting the following Zarf variables or helm values across the `uds-gitlab-runner-config` chart and the `gitlab-runner` chart.

### Change Sandbox Namespace

The sandbox namespace name that jobs run within can be configured to be a different name by setting the Zarf variable `JOB_RUNNER_NAMESPACE` or by overriding the `sandboxNamespace` value in the `uds-gitlab-runner-config` chart along with the `runners.job.namespace` value in the `gitlab-runner` chart.

### Allow Zarf Mutation in Sandbox

By default the sandbox is excluded from being mutated by Zarf to allow external images to be used in Zarf.  If you would like to change this behavior you can do so by overriding the `sandboxZarfIgnore` value in the `uds-gitlab-runner-config` chart to `false` along with overriding the `runners.job.registry` and `runners.helper.registry` to the registry corresponding to your package flavor (`docker.io` and `registry1.dso.mil` respectively for `upstream` and `registry1.dso.mil` and `registry1.dso.mil` respectively for `registry1`)

> :warning: **NOTE**: By default images pulled from private registries will need to follow the [GitLab documentation](https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#access-an-image-from-a-private-container-registry) in order to setup login information to pull from these private registries.  The `kubelet` will also need network access to these registries.  If Zarf is configured to mutate images, however, it will add this information on its own, but you will _only_ be able to pull images that are available in the Zarf registry.

### Change the Runner Service Account

By default the chart will create a service account named `gitlab-runner`.  You can change the name of this service account by by overriding the `serviceAccountName` value in the `uds-gitlab-runner-config` chart along with the `rbac.generatedServiceAccountName` value in the `gitlab-runner` chart.
