#!/usr/bin/env bash

function install_newrelic() {
  NEWRELIC_VERSION="newrelic-php5-4.20.2.95-linux"
  NEWRELIC_EXTENSION="newrelic-20100525.so"
  if [[ $PHP_VERSION == php-5.5.* ]]; then
    NEWRELIC_EXTENSION="newrelic-20121212.so"
  fi

  curl --silent --location https://download.newrelic.com/php_agent/release/${NEWRELIC_VERSION}.tar.gz  | tar zx
  cp ${NEWRELIC_VERSION}/daemon/newrelic-daemon.x64 /srv/www/${PHP_VERSION}/bin
  cp ${NEWRELIC_VERSION}/agent/x64/${NEWRELIC_EXTENSION} /srv/www/${PHP_VERSION}/lib/php/extensions/newrelic.so
  rm -r ${NEWRELIC_VERSION}

  echo "newrelic.logfile = /dev/null" >> ${PHP_CONFIGS_PATH}/newrelic.ini

  echo "echo \"newrelic.license = \$(/srv/www/bin/jq '.NEWRELIC.NEWRELIC_LICENSE' /srv/creds/creds.json)\" >> /srv/www/${PHP_VERSION}/etc/conf.d/newrelic.ini" >> .profile.d/newrelic.sh
  echo "echo \"newrelic.appname = \$(/srv/www/bin/jq '.NEWRELIC.NEWRELIC_APPNAME' /srv/creds/creds.json)\" >> /srv/www/${PHP_VERSION}/etc/conf.d/newrelic.ini" >> .profile.d/newrelic.sh

}

function finalize_newrelic() {
  echo "newrelic.logfile = stdout" > ${PHP_CONFIGS_PATH}/newrelic.ini
  echo "newrelic.daemon.location = /srv/www/${PHP_VERSION}/bin/newrelic-daemon.x64" >> ${PHP_CONFIGS_PATH}/newrelic.ini
  echo "newrelic.daemon.logfile = stdout" >> ${PHP_CONFIGS_PATH}/newrelic.ini
  echo "newrelic.daemon.loglevel = error" >> ${PHP_CONFIGS_PATH}/newrelic.ini
  echo "newrelic.daemon.pidfile = ${TMPDIR}/newrelic-daemon.pid" >> ${PHP_CONFIGS_PATH}/newrelic.ini
}
