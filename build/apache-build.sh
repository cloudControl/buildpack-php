#!/bin/bash
# Fail fast and fail hard.
set -eo pipefail

APACHE_VERSION=httpd-2.2.31

APACHE_DIR=/srv/www/${APACHE_VERSION}

mkdir -p ${APACHE_DIR}
cd /tmp

if [ ! -d ${APACHE_VERSION} ]; then
	curl --silent --show-error --location http://mirror.arcor-online.net/www.apache.org/httpd/${APACHE_VERSION}.tar.bz2 | tar -jx
fi

cd ${APACHE_VERSION}/

./configure --prefix=/srv/www/${APACHE_VERSION}
make
make install

cd ${APACHE_DIR}/..
tar cjf /vagrant/buildpack-php/${APACHE_VERSION}.tar.bz2 ${APACHE_VERSION}