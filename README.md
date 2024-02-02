# uds-package-gitlab-runner

UDS Gitlab Runner Package

---

## Flavors

Two flavors of this package are produced at this time:
- `upstream`: This flavor uses the upstream images (except for the helper image because defualt root security context) and is intended for a quick and seamless development experience

- `registry1`: This flavor uses hardened images from [Ironbank](https://p1.dso.mil/services/iron-bank) and is intended for production environments

---

## Dependencies

Gitlab-Runner has one dependency, Gitlab.

- Utilizing [uds-package-gitlab](https://github.com/defenseunicorns/uds-package-gitlab) is the quickest and easiest solution for meeting this dependency. 

- If choosing not to use `uds-package-gitlab` be aware that the Gitlab-Runner needs to be connected properly to Gitlab for registering itself and running pipelines as expected. 

---

## General

- `Upstream` flavor is the default
  - To set a different flavor, use the following flag:
    - `--set FLAVOR=registry1`

- For proper registration of a Gitlab-Runner with a Gitlab instance, a secret is created in the `gitlab-runner` namespace called `gitlab-gitlab-runner-secret` which copies the `runner-registration-token` field from the `gitlab` namespace secret called `gitlab-gitlab-runner-secret`. This is done [here](./tasks/create.yaml#12)

---

## Deploying

Utilizes [UDS-CLI task runners](https://github.com/defenseunicorns/uds-cli)
- Which means `uds run --list` is available for cli descriptions.

#### Using the UDS CLI targets:
```
uds run cluster-full
```

#### Available UDS CLI Targets
| UDS CLI Target | Description |
| - | - |
| [cluster-full](./tasks.yaml#9) | Setup a k3d cluster, deploy `uds-package-gitlab`, deploy Gitlab Runner |
| [create-package](./tasks.yaml#15) |  Create the Gitlab Runner Package based on the [zarf.yaml](./zarf.yaml) which defaults to `upstream` flavor |
| [gitlab](./tasks.yaml#20) | Setup a k3d cluster and deploy [uds-package-gitlab](https://github.com/defenseunicorns/uds-package-gitlab) |
| [gitlab-runner](./tasks.yaml#27) | Deploy Gitlab Runner only |
| [test-package](./tasks.yaml#37) | Tests the health of a clusters Gitlab and Gitlab Runner |
| [cleanup-gitlab-runner](./tasks.yaml#42) | Remove Gitlab Runner package only from cluster |
| [cleanup-cluster](./tasks.yaml#48) | Remove the k3d cluster and everything in it |

---

## Tests

Basic tests have been implemented [here](./tasks/test.yaml). 

#### Gitlab Specific Tests
| Test Link | Test Description |
| [Gitlab Gitaly](./tasks/test.yaml#7) | Check the health of Gitlab - Gitaly StatefulSet |
| [Gitlab Postgres](./tasks/test.yaml#13) | Check the health of Gitlab - Postgres StatefulSet |
| [Gitlab Redis](./tasks/test.yaml#19) | Check the health of Gitlab - Redis StatefulSet |
| [Gitlab Webservice](./tasks/test.yaml#25) | Check the health of Gitlab - Webserivce Deployment|
| [Gitlab Secret](./tasks/test.yaml#31) | Check that Gitlab's Runner Secret is created |

#### Gitlab Runner Specific Tests
| Test Link | Test Description |
| [Runner Secret](./tasks/test.yaml#39) | Check that Gitlab Runner's Runner secret is created |
| [Runner Deployment](./tasks/test.yaml#45) | Check the health of the Gitlab Runner's Deployment |
| [Runner Registration](./tasks/test.yaml#51) | Check that Gitlab Runner was able to register with Gitlab |

---