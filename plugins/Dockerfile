# Copyright 2024 Defense Unicorns
# SPDX-License-Identifier: AGPL-3.0-or-later OR LicenseRef-Defense-Unicorns-Commercial

# Stage 1: Pull the image and prepare the registry layout
FROM alpine:3.20.3@sha256:beefdbd8a1da6d2915566fde36db9db0b524eb737fc57cd1367effd16dc0d06d AS prep

ARG TARGETARCH

# Install skopeo and necessary tools
RUN apk add --no-cache skopeo tar gzip coreutils

# Create directories for storing and processing images
RUN mkdir -p /tmp/image /registry_data/docker/registry/v2/blobs/sha256

ARG REGISTRY="registry.gitlab.com"
ARG PLUGINS="gitlab-org/fleeting/plugins/aws:1.0.0 gitlab-org/fleeting/plugins/azure:0.3.0 gitlab-org/fleeting/plugins/googlecloud:1.0.0"

# Move the layer blobs into the blobs directory
RUN <<EXE
    for plugin in $PLUGINS; do
        # Extract the name and tag
        name=$(echo $plugin | cut -d':' -f1)
        tag=$(echo $plugin | cut -d':' -f2)

        # Pull the image into a temporary directory
        skopeo --override-os linux --override-arch "${TARGETARCH}" copy "docker://${REGISTRY}/${name}:${tag}" dir:/tmp/image

        for file in /tmp/image/*; do
            # Get the basename of the file
            sha256=$(basename "$file")

            # Check if the basename is 64 characters long
            if [ ${#sha256} -eq 64 ]; then
                # Create directories based on the first two characters of the SHA256 hash
                dir=$(echo "${sha256}" | cut -c1-2)
                mkdir -p /registry_data/docker/registry/v2/blobs/sha256/${dir}/${sha256}

                # Move the file to the appropriate directory
                mv "$file" /registry_data/docker/registry/v2/blobs/sha256/${dir}/${sha256}/data

                # Create a directory for the layer and link file
                mkdir -p /registry_data/docker/registry/v2/repositories/${name}/_layers/sha256/${sha256}
                echo -n "sha256:${sha256}" > /registry_data/docker/registry/v2/repositories/${name}/_layers/sha256/${sha256}/link

            elif [ "${sha256}" = "manifest.json" ]; then
                # Calculate SHA256 checksum of the manifest file
                manifest_sha256=$(sha256sum "$file" | awk '{ print $1 }')

                echo '{
    "schemaVersion": 2,
    "mediaType": "application/vnd.oci.image.index.v1+json",
    "manifests": [
        {
            "mediaType": "application/vnd.oci.image.manifest.v1+json",
            "size": '"$(stat --printf="%s" $file)"',
            "digest": "sha256:'"${manifest_sha256}"'",
            "annotations": {
                "org.opencontainers.image.base.name": "scratch",
                "org.opencontainers.image.version": "'"${tag}"'"
            },
            "platform": {
                "architecture": "'"${TARGETARCH}"'",
                "os": "linux"
            }
        }
    ]
}' > /tmp/image/index.json

                # determine directory for manifest blob
                dir=$(echo "${manifest_sha256}" | cut -c1-2)

                # Move the manifest file
                mkdir -p /registry_data/docker/registry/v2/blobs/sha256/${dir}/${manifest_sha256}
                mv "$file" /registry_data/docker/registry/v2/blobs/sha256/${dir}/${manifest_sha256}/data

                # Calculate SHA256 checksum of the index file
                index_sha256=$(sha256sum /tmp/image/index.json | awk '{ print $1 }')

                # determine directory for index blob
                dir=$(echo "${index_sha256}" | cut -c1-2)

                # Move the index file
                mkdir -p /registry_data/docker/registry/v2/blobs/sha256/${dir}/${index_sha256}
                mv /tmp/image/index.json /registry_data/docker/registry/v2/blobs/sha256/${dir}/${index_sha256}/data

                # Create directories for revisions and links
                mkdir -p /registry_data/docker/registry/v2/repositories/${name}/_manifests/revisions/sha256/${manifest_sha256}
                echo -n "sha256:${manifest_sha256}" > /registry_data/docker/registry/v2/repositories/${name}/_manifests/revisions/sha256/${manifest_sha256}/link
                mkdir -p /registry_data/docker/registry/v2/repositories/${name}/_manifests/revisions/sha256/${index_sha256}
                echo -n "sha256:${index_sha256}" > /registry_data/docker/registry/v2/repositories/${name}/_manifests/revisions/sha256/${index_sha256}/link

                mkdir -p /registry_data/docker/registry/v2/repositories/${name}/_manifests/tags/${tag}/current
                echo -n "sha256:${index_sha256}" > /registry_data/docker/registry/v2/repositories/${name}/_manifests/tags/${tag}/current/link

                mkdir -p /registry_data/docker/registry/v2/repositories/${name}/_manifests/tags/${tag}/index/sha256/${index_sha256}
                echo -n "sha256:${index_sha256}" > /registry_data/docker/registry/v2/repositories/${name}/_manifests/tags/${tag}/index/sha256/${index_sha256}/link
            fi
        done

        # Cleanup once we are done
        rm -rf /tmp/image/*
    done
EXE

# Stage 2: Build the final registry image
FROM registry:2.8.3@sha256:ac0192b549007e22998eb74e8d8488dcfe70f1489520c3b144a6047ac5efbe90

# Copy the prepared registry layout from the build stage
COPY --from=prep /registry_data/docker/registry/v2/ /var/lib/registry/docker/registry/v2/

# Expose the registry port
EXPOSE 5000

# Start the registry
ENTRYPOINT ["/entrypoint.sh"]
CMD ["serve", "/etc/docker/registry/config.yml"]
