#!/bin/bash

for release in trusty xenial bionic stretch jessie; do
    sudo sed -i "s|trusty|$release|" /sd-agent*/debian/changelog
    sudo dpkg-source -b /sd-agent
    sudo sed -i "s|$release|trusty|" /sd-agent*/debian/changelog
done
ubuntu=(bionic xenial trusty)

for release in jessie bionic; do
    if [[ ${ubuntu[*]} =~ "$release" ]]
    then
        distro="ubuntu"
    else
        distro="debian"
    fi
    for arch in amd64 i386; do
        if [ ! -d /packages/"$distro"/"$release" ]; then
            sudo mkdir /packages/"$distro"/"$release"
        fi
        if [ ! -d /packages/"$distro"/"$release"/"$arch" ]; then
            sudo mkdir /packages/"$distro"/"$release"/"$arch"
        fi
        pbuilder-dist $release $arch build \
        --buildresult /packages/"$distro"/"$release"/"$arch" *"$release"*.dsc
    done;
done

for release in xenial stretch trusty; do
    sudo cp -a /sd-agent/debian/distros/"$release"/. /sd-agent/debian
    if [[ ${ubuntu[*]} =~ "$release" ]]
    then
        distro="ubuntu"
    else
        distro="debian"
    fi
    for arch in amd64 i386; do
        if [ ! -d /packages/"$distro"/"$release" ]; then
            sudo mkdir /packages/"$distro"/"$release"
        fi
        if [ ! -d /packages/"$distro"/"$release"/"$arch" ]; then
            sudo mkdir /packages/"$distro"/"$release"/"$arch"
        fi
        pbuilder-dist $release $arch build \
        --buildresult /packages/"$distro"/"$release"/"$arch" *"$release"*.dsc
    done;
done
