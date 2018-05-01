#!/bin/bash

DEFAULT_DOCKERFILE_DIR=".travis/dockerfiles/"
if [[ "$TRAVIS_TAG" ]]; then
    PACKAGES_DIR="/${TRAVIS_REPO_SLUG}/${TRAVIS_TAG}/"
else
    PACKAGES_DIR="/${TRAVIS_REPO_SLUG}/${TRAVIS_BUILD_ID}/"
fi

set -ev
cd "${1:-$DEFAULT_DOCKERFILE_DIR}"

#Create required folders if they do not already exist
if [ ! -d "$PACKAGES_DIR" ]; then
    sudo mkdir -p "$PACKAGES_DIR"
fi
if [ ! -d "$CACHE_DIR" ]; then
    sudo mkdir "$CACHE_DIR"
fi

# Load the containers from cache
for distro in *;
do
    echo -en "travis_fold:start:build_${distro}_container\\r"
    CACHE_FILE_VAR="CACHE_FILE_${distro}"
    DOCKER_CACHE=${!CACHE_FILE_VAR}
    gunzip -c "$DOCKER_CACHE" | docker load;
    echo -en "travis_fold:end:build_${distro}_container\\r"
done

# Run the containers, if container name is bionic run with --privileged
for d in * ;
do
    echo "$d"
    if [[ "$d" == "bionic" ]]; then
        echo -en "travis_fold:start:run_${d}_container\\r"
        sudo docker run --volume="${TRAVIS_BUILD_DIR}":/sd-agent:rw --volume="${PACKAGES_DIR}":/packages:rw --privileged serverdensity:"${d}"
        echo -en "travis_fold:end:run_${d}_container\\r"
    else
        echo -en "travis_fold:start:run_${d}_container\\r"
        sudo docker run --volume="${TRAVIS_BUILD_DIR}":/sd-agent:rw --volume="${PACKAGES_DIR}":/packages:rw serverdensity:"${d}"
        echo -en "travis_fold:end:run_${d}_container\\r"
    fi
done

sudo find "$PACKAGES_DIR"
