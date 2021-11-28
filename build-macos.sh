#!/bin/sh

ROOT=$( cd $(dirname "$0"); pwd )
SRC_DIR=${ROOT}/src
BUILD_DIR=${ROOT}/build
INSTALL_DIR=${ROOT}/macos

mkdir -p ${SRC_DIR}
mkdir -p ${BUILD_DIR}
mkdir -p ${INSTALL_DIR}

# gcc
GCC_FILE=gcc-arm-none-eabi-10.3-2021.10-mac.tar.bz2
GCC_BASE_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10

wget ${GCC_BASE_URL}/${GCC_FILE} -P ${SRC_DIR}
tar -xjf ${SRC_DIR}/${GCC_FILE} -C ${INSTALL_DIR} --strip-components=1 

# openocd
OPENOCD_GIT=https://github.com/openocd-org/openocd.git
OPENOCD_TAG=v0.10.0
OPENOCD_OPTIONS="--enable-maintainer-mode --prefix=${INSTALL_DIR} --enable-stlink --enable-ftdi"

git clone ${OPENOCD_GIT} --branch=${OPENOCD_TAG} ${SRC_DIR}/openocd
( cd ${SRC_DIR}/openocd; ./bootstrap; ./configure ${OPENOCD_OPTIONS}; make -j install; )

# package
tar -cjf arm-toolchain-macos.tar.bz -C ${INSTALL_DIR} .
