#!/bin/bash

for name in `ls -1 /vagrant/.s3cfg-*`; do
	DOMAIN=$(echo $name | cut -d '-' -f 2-)
	echo $DOMAIN
	/home/vagrant/s3cmd/s3cmd -c $name sync /vagrant/buildpack-php/ s3://packages.${DOMAIN}/buildpack-php/
	/home/vagrant/s3cmd/s3cmd -c $name modify --add-header='Content-Type: text/plain' s3://packages.${DOMAIN}/buildpack-php/versions
done
