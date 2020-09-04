#! /bin/bash

set -eo pipefail

realsense_dir=$(pwd)

echo "Uninstalling any existing realsense libraries..."
sudo apt-get remove -y librealsense2 librealsense2-dev librealsense2-dkms
{ sudo apt-get remove -y ros-melodic-realsense2-camera ros-melodic-realsense2-description ros-melodic-librealsense2; } || { echo; }

echo "Download up-to-date librealsense2..."
{ echo "removing old ./artifacts..." && rm -rf ./artifacts; } || { echo "./artifacts/ does not exist... creating."; }
mkdir artifacts
cd artifacts
sudo apt-get download librealsense2 librealsense2-dkms librealsense2-udev-rules librealsense2-dev

echo "Installing up-to-date librealsense2..."
sudo apt-get install -y ./librealsense2-udev-rules_*.deb
sudo apt-get install -y ./librealsense2-dkms_*.deb
sudo apt-get install -y ./librealsense2_*.deb
sudo apt-get install -y ./librealsense2-dev_*.deb
cd $realsense_dir

build_dir=$(mktemp -d)
echo "Building realsense in $build_dir..."
source /opt/ros/melodic/setup.bash
cd $build_dir
cp -r $realsense_dir .
cd ./$(basename $realsense_dir)
export DEB_BUILD_OPTIONS="parallel=$(nproc) noddebs"
debuild --no-tgz-check -b --no-sign --lintian-opts --suppress-tags dir-or-file-in-opt -rfakeroot

echo "Building complete. Exporting artifacts..."
cd $realsense_dir
cp $build_dir/*.deb artifacts
rm -rf $build_dir

echo "Building RealSense tarball..."
cd artifacts
ls
tar -cvf ./alldebs.tar *.deb
mv alldebs.tar ..
cd ..

echo "alldebs.tar with realsense files created."
