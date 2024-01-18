# The version of Zarf to use. To keep this repo as portable as possible the Zarf binary will be downloaded and added to
# the build folder.
# renovate: datasource=github-tags depName=defenseunicorns/zarf
ZARF_VERSION := v0.31.4

# The version of the build harness container to use
BUILD_HARNESS_REPO := ghcr.io/defenseunicorns/build-harness/build-harness
# renovate: datasource=docker depName=ghcr.io/defenseunicorns/build-harness/build-harness
BUILD_HARNESS_VERSION := 1.14.8
# renovate: datasource=docker depName=ghcr.io/defenseunicorns/packages/dubbd-k3d extractVersion=^(?<version>\d+\.\d+\.\d+)
DUBBD_K3D_VERSION := 0.15.0

# Figure out which Zarf binary we should use based on the operating system we are on
ZARF_BIN := zarf
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)
ifeq ($(UNAME_M),x86_64)
    ARCH := amd64
else ifeq ($(UNAME_M),amd64)
    ARCH := amd64
else ifeq ($(UNAME_M),arm64)
    ARCH := arm64
else
    $(error Unsupported architecture: $(UNAME_M))
endif

# Silent mode by default. Run `make VERBOSE=1` to turn off silent mode.
ifndef VERBOSE
.SILENT:
endif

# Optionally add the "-it" flag for docker run commands if the env var "CI" is not set (meaning we are on a local machine and not in github actions)
TTY_ARG :=
ifndef CI
	TTY_ARG := -it
endif

.DEFAULT_GOAL := help

# Idiomatic way to force a target to always run, by having it depend on this dummy target
FORCE:

.PHONY: help
help: ## Show a list of all targets
	grep -E '^\S*:.*##.*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1:\3/p' \
	| column -t -s ":"

########################################################################
# Utility Section
########################################################################

.PHONY: docker-save-build-harness
docker-save-build-harness: ## Pulls the build harness docker image and saves it to a tarball
	mkdir -p .cache/docker
	docker pull $(BUILD_HARNESS_REPO):$(BUILD_HARNESS_VERSION)
	docker save -o .cache/docker/build-harness.tar $(BUILD_HARNESS_REPO):$(BUILD_HARNESS_VERSION)

.PHONY: docker-load-build-harness
docker-load-build-harness: ## Loads the saved build harness docker image
	docker load -i .cache/docker/build-harness.tar

.PHONY: run-pre-commit-hooks
run-pre-commit-hooks: ## Run all pre-commit hooks. Returns nonzero exit code if any hooks fail. Uses Docker for maximum compatibility
	mkdir -p .cache/pre-commit
	docker run --rm -v "${PWD}:/app" --workdir "/app" -e "PRE_COMMIT_HOME=/app/.cache/pre-commit" $(BUILD_HARNESS_REPO):$(BUILD_HARNESS_VERSION) bash -c 'git config --global --add safe.directory /app && asdf install && pre-commit run -a'

.PHONY: fix-cache-permissions
fix-cache-permissions: ## Fixes the permissions on the pre-commit cache
	docker run --rm -v "${PWD}:/app" --workdir "/app" -e "PRE_COMMIT_HOME=/app/.cache/pre-commit" $(BUILD_HARNESS_REPO):$(BUILD_HARNESS_VERSION) chmod -R a+rx .cache

########################################################################
# Test Section
########################################################################

.PHONY: test
test: ## Run all automated tests. Requires access to an AWS account. Costs money. Requires env vars "REPO_URL", "GIT_BRANCH", "REGISTRY1_USERNAME", "REGISTRY1_PASSWORD", "GHCR_USERNAME", "GHCR_PASSWORD" and standard AWS env vars.
	mkdir -p .cache/go
	mkdir -p .cache/go-build
	echo "Running automated tests. This will take several minutes. At times it does not log anything to the console. If you interrupt the test run you will need to log into AWS console and manually delete any orphaned infrastructure."
	docker run $(TTY_ARG) --rm \
	-v "${PWD}:/app" \
	-v "${PWD}/.cache/go:/root/go" \
	-v "${PWD}/.cache/go-build:/root/.cache/go-build" \
	--workdir "/app/test/e2e" \
	-e GOPATH=/root/go \
	-e GOCACHE=/root/.cache/go-build \
	-e REPO_URL \
	-e GIT_BRANCH \
	-e REGISTRY1_USERNAME \
	-e REGISTRY1_PASSWORD \
	-e AWS_REGION \
	-e AWS_DEFAULT_REGION \
	-e AWS_ACCESS_KEY_ID \
	-e AWS_SECRET_ACCESS_KEY \
	-e AWS_SESSION_TOKEN \
	-e AWS_SECURITY_TOKEN \
	-e AWS_SESSION_EXPIRATION \
	-e SKIP_SETUP -e SKIP_TEST \
	-e SKIP_TEARDOWN \
	-e AWS_AVAILABILITY_ZONE \
	$(BUILD_HARNESS_REPO):$(BUILD_HARNESS_VERSION) \
	bash -c 'asdf install && go test -v -timeout 2h -p 1 ./...'

.PHONY: test-ssh
test-ssh: ## Run this if you set SKIP_TEARDOWN=1 and want to SSH into the still-running test server. Don't forget to unset SKIP_TEARDOWN when you're done
	cd test/tf/public-ec2-instance && terraform init
	cd test/tf/public-ec2-instance/.test-data && cat Ec2KeyPair.json | jq -r .PrivateKey > privatekey.pem && chmod 600 privatekey.pem
	cd test/tf/public-ec2-instance && ssh -i .test-data/privatekey.pem ubuntu@$$(terraform output public_instance_ip | tr -d '"')

########################################################################
# Cluster Section
########################################################################

cluster/reset: cluster/destroy cluster/create ## This will destroy any existing cluster and then create a new one

cluster/create: ## Create a k3d cluster with metallb installed
	K3D_FIX_MOUNTS=1 k3d cluster create k3d-test-cluster --config utils/k3d/k3d-config.yaml
	k3d kubeconfig merge k3d-test-cluster -o /home/${USER}/cluster-kubeconfig.yaml
	echo "Installing Calico..."
	kubectl apply --wait=true -f utils/calico/calico.yaml 2>&1 >/dev/null
	echo "Waiting for Calico to be ready..."
	kubectl rollout status deployment/calico-kube-controllers -n kube-system --watch --timeout=90s 2>&1 >/dev/null
	kubectl rollout status daemonset/calico-node -n kube-system --watch --timeout=90s 2>&1 >/dev/null
	kubectl wait --for=condition=Ready pods --all --all-namespaces 2>&1 >/dev/null
	echo
	utils/metallb/install.sh
	echo "Cluster is ready!"

cluster/destroy: ## Destroy the k3d cluster
	k3d cluster delete k3d-test-cluster

########################################################################
# Build Section
########################################################################

build/all: build build/zarf build/zarf-init build/dubbd-k3d build/test-pkg-deps build/uds-package-gitlab-runner

build: ## Create build directory
	mkdir -p build

.PHONY: clean
clean: ## Clean up build files
	rm -rf ./build

.PHONY: build/zarf
build/zarf: | build ## Download the Zarf to the build dir
	if [ -f build/zarf ] && [ "$$(build/zarf version)" = "$(ZARF_VERSION)" ] ; then exit 0; fi && \
	echo "Downloading zarf" && \
	curl -sL https://github.com/defenseunicorns/zarf/releases/download/$(ZARF_VERSION)/zarf_$(ZARF_VERSION)_$(UNAME_S)_$(ARCH) -o build/zarf && \
	chmod +x build/zarf

.PHONY: build/zarf-init
build/zarf-init: | build ## Download the init package
	if [ -f build/zarf-init-amd64-$(ZARF_VERSION).tar.zst ] ; then exit 0; fi && \
	echo "Downloading zarf-init-amd64-$(ZARF_VERSION).tar.zst" && \
	curl -sL https://github.com/defenseunicorns/zarf/releases/download/$(ZARF_VERSION)/zarf-init-amd64-$(ZARF_VERSION).tar.zst -o build/zarf-init-amd64-$(ZARF_VERSION).tar.zst

.PHONY: build/dubbd-k3d
build/dubbd-k3d: | build/zarf ## Download dubbd k3d oci package
	if [ -f build/zarf-package-dubbd-k3d-amd64-$(DUBBD_K3D_VERSION).tar.zst ] ; then exit 0; fi && \
	cd build && ./zarf package pull oci://ghcr.io/defenseunicorns/packages/dubbd-k3d:$(DUBBD_K3D_VERSION)-amd64 --oci-concurrency 12

build/test-pkg-deps: | build/zarf ## Build package dependencies for testing
	cd build && ./zarf package create ../utils/pkg-deps/namespaces/ --skip-sbom --confirm
	cd build && ./zarf package create ../utils/pkg-deps/gitlab/ --skip-sbom --confirm
	cd build && ./zarf package create ../utils/pkg-deps/rbac/ --skip-sbom --confirm

build/uds-package-gitlab-runner: | build/zarf ## Build the gitlab-runner package
	cd build && ./zarf package create ../ --skip-sbom --confirm

########################################################################
# Deploy Section
########################################################################

deploy/all: deploy/init deploy/dubbd-k3d deploy/test-pkg-deps deploy/uds-package-gitlab-runner ##

deploy/init: | build/zarf ## Deploy the zarf init package
	cd build && ./zarf init --confirm --components=git-server

deploy/dubbd-k3d: | build/zarf ## Deploy the k3d flavor of DUBBD
	cd build && ./zarf package deploy zarf-package-dubbd-k3d-amd64-$(DUBBD_K3D_VERSION).tar.zst --confirm

deploy/test-pkg-deps: | build/zarf ## Deploy the package dependencies needed for testing the gitlab-runner package
	cd build && ./zarf package deploy zarf-package-gitlab-runner-namespaces-* --confirm
	cd build && ./zarf package deploy zarf-package-gitlab-runner-gitlab* --confirm
	cd build && ./zarf package deploy zarf-package-gitlab-runner-rbac* --confirm

deploy/uds-package-gitlab-runner: | build/zarf ## Deploy the gitlab-runner package
	cd build && ./zarf package deploy zarf-package-gitlab-runner-amd*.tar.zst --confirm --set GITLAB_RUNNER_DEPENDS_ON="[]"

########################################################################
# Macro Section
########################################################################

.PHONY: all
all: build/all cluster/reset deploy/all ## Build and deploy gitlab-runner locally

.PHONY: rebuild
rebuild: clean build/all
