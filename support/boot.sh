#!/usr/bin/env bash

# Copyright 2012 cloudControl GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# for documentation of the directives see http://httpd.apache.org/docs/2.2/mod/directives.html

clean(){
    if [[ "$phppid" ]]; then
        kill -TERM -$phppid
        unset phppid
    fi
    if [[ "$apachepid" ]]; then
        kill -TERM -$apachepid
        unset apachepid
    fi
    kill -TERM 0
}
trap clean INT TERM EXIT

if [[ "$PAAS_VENDOR" = "cloudControl" ]]; then
    let serverlimit=SIZE+1
    let threads=8
    MPM_CONF=/app/apache/conf/local/worker-mpm.conf
    mkdir -p $(dirname $MPM_CONF)

    cat > $MPM_CONF <<EOF
<IfModule worker.c>
    ServerLimit $serverlimit
    StartServers 1
    MaxClients $(( serverlimit*threads ))
    MinSpareThreads 2
    MaxSpareThreads $threads
    ThreadsPerChild $threads
</IfModule>
EOF
fi

# FIXME detect abnormal php-fpm exit
php5-fpm --fpm-config /app/php/php-fpm.ini &
phppid=$!
apache2 -f /app/apache/conf/httpd.conf -D FOREGROUND &
#/srv/www/httpd-2.2.31/bin/apachectl -f /app/apache/conf/httpd.conf -D FOREGROUND &
apachepid=$!
wait $apachepid

