#!/usr/bin/env bash

function install_newrelic() {
  NEWRELIC_VERSION="4.22.0.99"
  NEWRELIC_VERSION_FULL=newrelic-php5-${NEWRELIC_VERSION}-linux
  NEWRELIC_EXTENSION="newrelic-20100525.so"
  if [[ $PHP_VERSION == php-5.5.* ]]; then
    NEWRELIC_EXTENSION="newrelic-20121212.so"
  elif [[ $PHP_VERSION == php-5.6.* ]]; then
    NEWRELIC_EXTENSION="newrelic-20131226.so"
  fi

  curl --silent --location https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/${NEWRELIC_VERSION_FULL}.tar.gz  | tar zx
  cp ${NEWRELIC_VERSION_FULL}/daemon/newrelic-daemon.x64 /srv/www/${PHP_VERSION}/bin
  cp ${NEWRELIC_VERSION_FULL}/agent/x64/${NEWRELIC_EXTENSION} /srv/www/${PHP_VERSION}/lib/php/extensions/newrelic.so
  rm -r ${NEWRELIC_VERSION_FULL}

  echo "newrelic.logfile = /dev/null" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini

  echo "echo \"newrelic.license = \$(/srv/www/bin/jq '.NEWRELIC.NEWRELIC_LICENSE' /srv/creds/creds.json)\" >> /srv/www/${PHP_VERSION}/etc/conf.d/buildpack-newrelic.ini" >> .profile.d/newrelic.sh
  echo "echo \"newrelic.appname = \$(/srv/www/bin/jq '.NEWRELIC.NEWRELIC_APPNAME' /srv/creds/creds.json)\" >> /srv/www/${PHP_VERSION}/etc/conf.d/buildpack-newrelic.ini" >> .profile.d/newrelic.sh
}

function finalize_newrelic() {
  echo "newrelic.logfile = stdout" > ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.loglevel = info" > ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.dont_launch = 0" > ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.location = /srv/www/${PHP_VERSION}/bin/newrelic-daemon.x64" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.logfile = stdout" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.loglevel = info" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.pidfile = /app/newrelic-daemon.pid" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.port = /app/newrelic.sock" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
}
