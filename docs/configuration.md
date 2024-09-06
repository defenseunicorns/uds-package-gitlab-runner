# Configuration

GitLab Runners in this package are configured through the upstream [GitLab Runner chart](https://docs.gitlab.com/runner/install/kubernetes.html) as well as a UDS configuration chart that supports the following:

## Node Configuration

> [!IMPORTANT]
> Any kubernetes node that will run GitLab Runner pods to use tooling like [Buildah](https://buildah.io/) must set sysctl `user.max_user_namespaces` to a nonzero value. This is required to run these container builds inside Linux containers from the runner pods.
>
> This is a [STIG finding](https://www.stigviewer.com/stig/red_hat_enterprise_linux_9/2023-09-13/finding/V-257816) but is `Not Applicable` when running Linux containers.

Example:
```bash
sysctl -w user.max_user_namespaces=30110
```

## Networking

Network policies are controlled via the `uds-gitlab-runner-config` chart in accordance with the [common patterns for networking within UDS Software Factory](https://github.com/defenseunicorns/uds-software-factory/blob/main/docs/networking.md).  Because GitLab runners do not interact with external resources like databases or object storage they only implement `custom` networking for both the runner namespace and the runner sandbox namespace:

- `custom`: sets custom network policies for the GitLab runner namespace - note this is _not_ where jobs run and is the orchestration side of the GitLab runner deployment.
- `customSandbox`: sets custom network policies for the GitLab runner sandbox namespace - this is where jobs will execute and can be used to allow them to access external services.

## Runner

Additional runner configuration can be achieved by setting the following Zarf variables or helm values across the `uds-gitlab-runner-config` chart and the `gitlab-runner` chart.

### Change Sandbox Namespace

The sandbox namespace name that jobs run within can be configured to be a different name by setting the `RUNNER_SANDBOX_NAMESPACE` variable in the package.

> [!CAUTION]
> Do not use chart overrides to set the namespace, there is a Zarf wait action that needs to know the namespace to wait for UDS Package reconciliation.

### Set Runner Authentication Token

If you would like to setup a different kind of runner or add your own information to the runner deployed via this package you can create one manually via the GitLab API or UI and then set the `RUNNER_AUTH_TOKEN` variable in the package to wire it up.

> [!NOTE]
> You can only deploy one runner package to one cluster today - you can however use this to configure the runner in another cluster that is linked back to your primary cluster to have multiple runner kinds deployed via this package.

### Allow Zarf Mutation in Sandbox

By default the sandbox is excluded from being mutated by Zarf to allow external images to be used in Zarf.  If you would like to change this behavior you can do so by overriding the `sandboxZarfIgnore` value in the `uds-gitlab-runner-config` chart to `false` along with overriding the `runners.job.registry` and `runners.helper.registry` to the registry corresponding to your package flavor (`docker.io` and `registry1.dso.mil` respectively for `upstream` and `registry1.dso.mil` and `registry1.dso.mil` respectively for `registry1`)

> [!NOTE]
> By default images pulled from private registries will need to follow the [GitLab documentation](https://docs.gitlab.com/ee/ci/docker/using_docker_images.html#access-an-image-from-a-private-container-registry) in order to setup login information to pull from private registries.  The `kubelet` will also need network access to these registries.  If you change the configuration for Zarf to mutate images, instead, it will add this information on its own, _but_ you will _only_ be able to pull images that are available in the Zarf registry.

> [!TIP]
> The default registry behavior relies on the `###ZARF_REGISTRY###` internal value as outlined in the [Zarf documentation](https://docs.zarf.dev/ref/values/#internal-values-zarf).  This value is applied during Zarf deploy so cannot be used by GitLab when spawning pods.  If you do know the address of the Zarf registry (`127.0.0.1:31999` by default) you can still pull from the Zarf registry however.

### Allow SETUID and SETGID security capabilities

By default, runner build containers do not have `SETUID` and `SETGID` capabilities enabled. This limits the functionality of tools like [Buildah](https://buildah.io/) and [Podman](https://podman.io/). Podman cannot build container images, and Buildah can only create very basic images. Any actions that involve user or group modifications (e.g., using useradd or groupadd in a Dockerfile) will fail.

To enable `SETUID` and `SETGID` capabilities in the build containers, set the `ENABLE_SECURITY_CAPABILITIES` Zarf variable to `true`. This will [apply a security policy for the build container](https://docs.gitlab.com/runner/executors/kubernetes/#set-a-security-policy-for-the-container) to add SETUID and SETGID capabilities. Additionally, it will [add a UDS Policy Exemption](https://uds.defenseunicorns.com/core/configuration/uds-configure-policy-exemptions/) to permit these capabilities.

### Change the Runner Service Account

By default the chart will create a service account named `gitlab-runner`.  You can change the name of this service account by by overriding the `serviceAccountName` value in the `uds-gitlab-runner-config` chart along with the `rbac.generatedServiceAccountName` value in the `gitlab-runner` chart.

### Change the Runner Executor

This package supports both the Kubernetes executor and the instance fleeting executor for running CI jobs.  The Kubernetes executor is default, but to swap to the fleeting executor change the following:

#### `uds-gitlab-runner-config` chart:

- `executor` - set this to `instance` to flip the executor to use fleeting instances

#### `gitlab-runner` chart:

- `runners.executor` - set this to `instance` as well to flip the executor to use fleeting instances
- `preEntrypointScript` - set this to `gitlab-runner fleeting install` (or if you are already using this value add that line)
- `runners.fleeting.pluginConfig` - set this for your chosen plugin to configure it for the correct autoscaler (i.e. `name: "my-linux-asg"` for the aws plugin)
- `runners.fleeting.connectorConfig` - set this for your chosen plugin to be able to connect to instances (i.e. `username: "ubuntu"` for the aws plugin)
- `runners.fleeting.policy` - set the policy for how the fleeting runners are managed (i.e. 
      `idle_count: 1`)
- `serviceAccount.annotations.irsa/role-arn` - if you are connecting through IRSA this must be set to the role ARN with access to the autoscaling group.
- `extraEnv` - set any extra environment variables that may be needed (i.e. `AWS_REGION: us-gov-west-1` for the aws plugin)

> [!TIP]
> You can see an example of this configuration for AWS in a bundle under [`bundle/fleeting/uds-bundle.yaml`](./bundle/fleeting/uds-bundle.yaml) in this repository.  Associated terraform (used for testing this repo) can be found under [`.github/test-infra/asg-iac`](./.github/test-infra/asg-iac) to set things up with an ASG configured through IRSA.

> [!NOTE]
> To learn more about configuring instance runners see: https://docs.gitlab.com/runner/executors/instance.html  The `runners.fleeting` config values are YAML objects that are templated to their toml equivalents within the Helm chart.

> [!NOTE]
> This package defaults to AWS for fleeting runners but can use other fleeting runner types by overriding the `fleeting.repository` and `fleeting.tag` values in the `gitlab-runner` chart to another plugin included in that package version. The documentation for each fleeting type can be found in their repositories for [`aws`](https://gitlab.com/gitlab-org/fleeting/plugins/aws#fleeting-plugin-aws), [`azure`](https://gitlab.com/gitlab-org/fleeting/plugins/azure#fleeting-plugin-azure), and [`googlecloud`](https://gitlab.com/gitlab-org/fleeting/plugins/googlecloud#fleeting-plugin-for-google-cloud-platform-gcp).  You can see which versions are included in the package by looking at the Dockerfile under [`plugins/Dockerfile`](./plugins/Dockerfile).
