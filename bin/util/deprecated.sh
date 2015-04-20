function check_ccconfig() {
  # Disable .ccconfig.yaml for new builds
  if [[ $PAAS_VENDOR = "cloudControl" ]]; then
    PROJECT_CCCONFIG=$PROJECT_ROOT/.ccconfig.yaml

    TMP=$(grep -E -o 'WebContent.*[^[:space:]]' $PROJECT_CCCONFIG 2>/dev/null | sed 's/WebContent *: *//' || echo "")
    if [[ TMP ]]; then
      WEBCONTENT="$TMP"
    fi
  fi
}

function check_luigi() {
  if [[ $PAAS_VENDOR = "cloudControl" ]]; then
    # compatibility for luigi stack
    if [[ ! -f "$PROJECT_CCCONFIG" ]]; then
      echo -e "BaseConfig:\n  WebContent: /$WEBCONTENT" > $PROJECT_CCCONFIG
    fi
  fi
}

function copy_default_config() {
  for f in /etc/php5/conf.d/*.ini; do
    cp $f $PHP_PATH/conf/000_`basename $f`;
  done
}

function configure_apc() {
  if [[ $PAAS_VENDOR = "cloudControl" ]]; then
    echo "[APC]" > $PHP_PATH/conf/cctrl_apc.ini
    grep -E -o 'apc.*[^[:space:]]' $PROJECT_CCCONFIG | sed 's/apcEnabled/apc.enabled/;s/apcShmSize/apc.shm_size/;s/apcStat/apc.stat/;s/:/ =/' >> $PHP_PATH/conf/cctrl_apc.ini || rm $PHP_PATH/conf/cctrl_apc.ini
  fi
}
