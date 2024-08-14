# 3. Autoscaling Runner Provisioner

Date: 2024-08-14

## Status

Pending

## Context

We need to choose a method to better support runners in larger environments with more complex requirements than Kubernetes runners alone can safely provide.   These use cases include:

1. Running container workloads in CI (specifically things like k3d for testing UDS packages)
2. Building complex docker containers without needing to swap out tooling (i.e. to buildah)
3. Interacting with lower level concepts like shared memory or other kernel capabilities that are not exposed to the container in K8s

In order to enable this there are two potential paths:

1. Make use of the [instance executor and fleeting plugins](https://docs.gitlab.com/runner/executors/instance.html).

**Pros:**

-

**Cons:**

-

2. Make use of the [docker autoscaler executor and fleeting plugins](https://docs.gitlab.com/runner/executors/docker_autoscaler.html).

**Pros:**

-

**Cons:**

-

3. Make use of the [virtualbox executor](https://docs.gitlab.com/runner/executors/virtualbox.html).

**Pros:**

-

**Cons:**

-

4. Create a custom [shell executor](https://docs.gitlab.com/runner/executors/shell.html) wrapper that handles autoscaling.

**Pros:**

-

**Cons:**

-

## Decision

We decided to 

## Consequences


