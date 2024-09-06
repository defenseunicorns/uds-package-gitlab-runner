# 3. Autoscaling Runner Provisioner

Date: 2024-08-16

## Status

Pending

## Context

We need to choose a method to better support runners in larger environments with more complex requirements than Kubernetes runners alone can safely provide.   These use cases include:

1. Running container workloads in CI (specifically things like k3d for testing UDS packages)
2. Building complex docker containers without needing to swap out tooling (i.e. to buildah)
3. Interacting with lower level concepts like shared memory or other kernel capabilities that are not exposed to the container in K8s

In order to enable this there are four potential paths:

1. Make use of the [instance executor and fleeting plugins](https://docs.gitlab.com/runner/executors/instance.html).

**Pros:**

- Allows full access to the underlying operating system

**Cons:**

- Requires being in a cloud provider, only AWS and GoogleCloud are 1.0 as of Aug 15
- Depending on configuration can have the slowest job start time

2. Make use of the [docker autoscaler executor and fleeting plugins](https://docs.gitlab.com/runner/executors/docker_autoscaler.html).

**Pros:**

- Allows opening up some security controls around running Docker container runners since they can be isolated better
- Can provide a more balanced job start time compared to instance runners

**Cons:**

- Requires being in a cloud provider, only AWS and GoogleCloud are 1.0 as of Aug 15

3. Make use of the [virtualbox executor](https://docs.gitlab.com/runner/executors/virtualbox.html).

**Pros:**

- Allows full access to the underlying operating system

**Cons:**

- Only works in smaller environments, and likely only makes sense on-prem

4. Create a [custom executor](https://docs.gitlab.com/runner/executors/custom.html) wrapper that handles autoscaling.

**Pros:**

- Allows full access to the underlying operating system

**Cons:**

- Would require significant engineering time to create a system that can be run everywhere we need it to

## Decision

We decided to implement the **instance executor and fleeting plugins** to solve the immediate needs since it is one of the more mature options that will work for folks in cloud environments.

## Consequences

Runner start times could be compromised with this solution and this does not support on-prem environments. For the runner start times we can explore the docker autoscaler though we will lose OS access and will need to work through / around that.  On-prem environments can fallback to the existing k8s runners and in the future we may look to explore VirtualBox or custom runners as a third option.
