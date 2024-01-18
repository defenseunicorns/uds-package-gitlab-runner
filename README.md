# uds-package-gitlab-runner

UDS Gitlab Runner Zarf Package

## Prerequisites

### General

- [Gitlab](https://github.com/defenseunicorns/uds-capability-gitlab-runner) is deployed and running in the cluster
- Create `gitlab-runner-sandbox` namespace
- Label `gitlab-runner-sandbox` namespace with `istio-injection: enabled` & `zarf.dev/agent: ignore`
- Create an `rbac` file for the `gitlab-runner` service account
- Replace zarf-created `ImagePullSecret` - See below

### ImagePullSecret

By default Zarf will create an `ImagePullSecret` in any new namespace in the cluster called `private-registry`. Since
we have specified that the `gitlab-runner-sandbox` namespace will not be using the zarf registry that secret must be deleted.
However, the CI job pods will still require one that has the required credentials for where you expect your users to want to pull
CI images from.

- Delete the `secret` called `private-registry` in the `gitlab-runner-sandbox` namespace
- Create an `ImagePullSecret` type `secret` called `private-registry` in the `gitlab-runner-sandbox` with the credentials required
  - Example using kubectl:

```bash
kubectl create secret generic private-registry \
  --from-file=.dockerconfigjson=$HOME/.docker/config.json \
  --type=kubernetes.io/dockerconfigjson \
  -n gitlab-runner-sandbox
```

### RBAC file

- The `rbac.yaml` should create a `ClusterRole` with the name `gitlab-runner-sandbox` and the following values:

```yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: gitlab-runner-sandbox
rules:
  - apiGroups: [""]
    resources: ["configmaps", "pods", "pods/attach", "secrets", "services"]
    verbs: ["get", "list", "watch", "create", "patch", "update", "delete"]
  - apiGroups: [""]
    resources: ["pods/exec"]
    verbs: ["create", "patch", "delete"]
```

- The `ClusterRole` should then be bound using a `RoleBinding` in the `gitlab-runner-sandbox` namespace to the service account that `gitlab-runner` uses
example:

```yaml
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: gitlab-runner-sandbox
  namespace: gitlab-runner-sandbox
subjects:
- kind: ServiceAccount
  name: default
  namespace: gitlab-runner
roleRef:
  apiGroup: ""
  kind: ClusterRole
  name: gitlab-runner-sandbox
```

## Deploy

### Use zarf to login to the needed registries i.e. registry1.dso.mil and ghcr.io

```bash
# Download Zarf
make build/zarf

# Login to the registry
set +o history

# registry1.dso.mil (To access registry1 images needed during build time)
export REGISTRY1_USERNAME="YOUR-USERNAME-HERE"
export REGISTRY1_TOKEN="YOUR-TOKEN-HERE"
echo $REGISTRY1_TOKEN | build/zarf tools registry login registry1.dso.mil --username $REGISTRY1_USERNAME --password-stdin

set -o history
```

### Build and Deploy Everything via Makefile and local package

```bash
# This will run make build/all, make cluster/reset, and make deploy/all. Follow the breadcrumbs in the Makefile to see what and how its doing it.
make all
```

## Declare This Package In Your UDS Bundle
Below is an example of how to use this projects zarf package in your UDS Bundle

```yaml
kind: UDSBundle
metadata:
  name: example-bundle
  description: An Example UDS Bundle
  version: 0.0.1
  architecture: amd64

zarf-packages:
  # Gitlab Runner
  - name: gitlab-runner
    repository: ghcr.io/defenseunicorns/uds-capability/gitlab-runner
    ref: x.x.x
```