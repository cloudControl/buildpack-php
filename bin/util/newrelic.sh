
install_newrelic() {
  NEWRELIC_VERSION="4.22.0.99"
  NEWRELIC_VERSION_FULL=newrelic-php5-${NEWRELIC_VERSION}-linux
  if [[ $PHP_VERSION == php-5.4.* ]]; then
    NEWRELIC_EXTENSION="newrelic-20100525.so"
  elif [[ $PHP_VERSION == php-5.5.* ]]; then
    NEWRELIC_EXTENSION="newrelic-20121212.so"
  elif [[ $PHP_VERSION == php-5.6.* ]]; then
    NEWRELIC_EXTENSION="newrelic-20131226.so"
  else
    echo "WARN: No newrelic extension available for ${PHP_VERSION}" | indent_head
    return
  fi

  curl --silent --show-error --location https://download.newrelic.com/php_agent/archive/${NEWRELIC_VERSION}/${NEWRELIC_VERSION_FULL}.tar.gz  | tar zx
  cp ${NEWRELIC_VERSION_FULL}/daemon/newrelic-daemon.x64 /app/${PHP_VERSION}/bin
  cp ${NEWRELIC_VERSION_FULL}/agent/x64/${NEWRELIC_EXTENSION} /app/${PHP_VERSION}/lib/php/extensions/newrelic.so
  rm -r ${NEWRELIC_VERSION_FULL}

  echo "newrelic.logfile = /dev/null" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini

  echo "echo \"newrelic.license = \$(/app/bin/jq '.NEWRELIC.NEWRELIC_LICENSE' /srv/creds/creds.json)\" >> /app/${PHP_VERSION}/etc/conf.d/buildpack-newrelic.ini" >> .profile.d/newrelic.sh
  echo "echo \"newrelic.appname = \$(/app/bin/jq '.NEWRELIC.NEWRELIC_APPNAME' /srv/creds/creds.json)\" >> /app/${PHP_VERSION}/etc/conf.d/buildpack-newrelic.ini" >> .profile.d/newrelic.sh
}

finalize_newrelic() {
  echo "newrelic.logfile = stdout" > ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.loglevel = info" > ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.dont_launch = 0" > ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.location = /app/${PHP_VERSION}/bin/newrelic-daemon.x64" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.logfile = stdout" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.loglevel = info" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.pidfile = /app/newrelic-daemon.pid" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
  echo "newrelic.daemon.port = /app/newrelic.sock" >> ${PHP_CONFIGS_PATH}/buildpack-newrelic.ini
}
