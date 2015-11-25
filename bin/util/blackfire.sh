#!/usr/bin/env bash

install_blackfire() {
  echo "Installing blackfire ..."

  # fail hard
  set -eo pipefail

  bin_dir=${BUILD_DIR}/bin

  # Download the probe
  probe_version=`curl --show-error -A "cloudControl" -o probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/${PHP_MAJOR_VERSION:=5}${PHP_MINOR_VERSION:=4} | grep 'X-Blackfire-Release-Version: ' | sed "s%X-Blackfire-Release-Version: %%" | sed s%.$%%`
  echo "Packaging ext/blackfire ${probe_version} (for Zend module API version ${ZEND_MODULE_API_VERSION})..." | indent_head

  mkdir -p ${ext_dir}
  tar -zxf probe.tar.gz
  cp blackfire-${ZEND_MODULE_API_VERSION}.so ${ext_dir}/blackfire.so
  rm probe.tar.gz blackfire-${ZEND_MODULE_API_VERSION}.so blackfire-${ZEND_MODULE_API_VERSION}.sha

  echo "Done." | indent

  # Download the agent
  agent_version=`curl -A "cloudControl" -o agent.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/agent/linux/amd64 | grep 'X-Blackfire-Release-Version: ' | sed "s%X-Blackfire-Release-Version: %%" | sed s%.$%%`
  echo "Packaging bin/blackfire-agent ${agent_version}..." | indent_head

  mkdir -p ${bin_dir}
  tar -zxf agent.tar.gz
  chmod +x agent
  cp agent ${bin_dir}/blackfire-agent
  rm agent.tar.gz agent agent.sha1

  echo "Done." | indent

  if [[ -n ${PHP_VERSION} ]]; then
    CONFIGS_PATH="/app/${PHP_VERSION}/etc/conf.d/"
  else
    CONFIGS_PATH=/app/php/conf/
  fi

   # Create the .profile.d script
  cat > $BUILD_DIR/.profile.d/blackfire.sh <<EOF
BLACKFIRE_SERVER_ID=\$(jq -r 'if .BLACKFIRE|has("BLACKFIRE_SERVER_ID") then .BLACKFIRE.BLACKFIRE_SERVER_ID else "" end' /srv/creds/creds.json)
BLACKFIRE_SERVER_TOKEN=\$(jq -r 'if .BLACKFIRE|has("BLACKFIRE_SERVER_TOKEN") then .BLACKFIRE.BLACKFIRE_SERVER_TOKEN else "" end' /srv/creds/creds.json)

if [[ -n "\${BLACKFIRE_SERVER_ID}" && -n "\${BLACKFIRE_SERVER_TOKEN}" ]]; then
  echo "Blackfire credentials available - extension enabled"

  # Configure the agent
  mkdir -p /app/var/blackfire/run
  mkdir -p /app/etc/blackfire
  echo -e "[blackfire]\nserver-id=2dcacfa8-9618-421c-8a3e-fdc5cca4ed45\nserver-token=3e96b0848ec67171c370255fe22edd051a372593f26c3cf472b247fdb14ba401" > /app/etc/blackfire/agent.ini

  # Configure and enable the probe
  cat >> ${CONFIGS_PATH}/ext-blackfire.ini <<EOT
blackfire.log_level = 1
blackfire.server_token = \${BLACKFIRE_SERVER_TOKEN}
blackfire.server_id = \${BLACKFIRE_SERVER_ID}
blackfire.agent_socket = "unix:///app/var/blackfire/run/agent.sock"
EOT

  # Launch the agent
  touch /app/var/blackfire/run/agent.sock
  /app/bin/blackfire-agent --collector "https://blackfire.io" --config /app/etc/blackfire/agent.ini --socket "unix:///app/var/blackfire/run/agent.sock" &
else
  echo "Blackfire credentials unavailable - extension disabled"
fi
EOF

  if [[ -z "${PHP_VERSION}" ]]; then
    echo 'extension = /app/usr/lib/php5/20100525/blackfire.so' >> "${PHP_CONFIGS_PATH}/ext-blackfire.ini"
  fi
  # We have to ignore the platform requirements otherwise composer will fail
  COMPOSER_INSTALL_ARGS="$COMPOSER_INSTALL_ARGS --ignore-platform-reqs"
}
