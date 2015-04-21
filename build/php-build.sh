# Fail fast and fail hard.
set -eo pipefail

PHP_VERSION=$1

PHP_MIRROR=de1.php.net
PHP_DIR=/srv/www/${PHP_VERSION}

mkdir -p ${PHP_DIR}
cd /tmp

if [ ! -d ${PHP_VERSION} ]; then
	curl --silent --location http://${PHP_MIRROR}/get/${PHP_VERSION}.tar.bz2/from/this/mirror | tar -jx
fi

cd ${PHP_VERSION}/
export EXTENSION_DIR=${PHP_DIR}/lib/php/extensions
export LD_LIBRARY_PATH=${PHP_DIR}
./configure -q \
--prefix=${PHP_DIR} \
--disable-debug \
--disable-rpath \
--disable-static \
--enable-bcmath=shared \
--enable-calendar=shared \
--enable-dba=shared \
--enable-exif=shared \
--enable-ftp=shared \
--enable-fpm=shared \
--enable-gd-native-ttf=shared \
--enable-intl=shared \
--enable-mbstring=shared \
--enable-mysqlnd=shared \
--enable-opcache=shared \
--enable-pdo=shared \
--enable-shmop=shared \
--enable-soap=shared \
--enable-sockets=shared \
--enable-sysvmsg=shared \
--enable-sysvsem=shared \
--enable-sysvshm=shared \
--enable-wddx=shared \
--enable-zip=shared \
--with-bz2=shared \
--with-config-file-path=${PHP_DIR}/etc \
--with-config-file-scan-dir=${PHP_DIR}/etc/conf.d \
--with-curl=shared \
--with-freetype-dir=shared \
--with-gd=shared \
--with-gettext=shared \
--with-jpeg-dir=shared \
--with-mcrypt=shared \
--with-mhash \
--with-mssql=shared \
--with-mysql=shared \
--with-mysqli=shared \
--with-openssl \
--with-pdo-dblib=shared \
--with-pdo-mysql=shared \
--with-pdo-pgsql=shared \
--with-pdo-sqlite=shared \
--with-pgsql=shared \
--with-png-dir=shared \
--with-readline=shared \
--with-regex=php \
--with-sqlite3=shared \
--with-xmlrpc=shared \
--with-xsl=shared \
--with-zlib=shared

make -s
make -s install

mkdir -p ${PHP_DIR}/etc/conf.d

cd ..

/srv/www/${PHP_VERSION}/bin/pear channel-update pear.php.net
/srv/www/${PHP_VERSION}/bin/pear install channel://pear.php.net/Net_URL2-0.3.1 || true
/srv/www/${PHP_VERSION}/bin/pear install channel://pear.php.net/HTTP_Request2-0.5.2 || true

printf "\n" | /srv/www/${PHP_VERSION}/bin/pecl install mongo || true
/srv/www/${PHP_VERSION}/bin/pecl install oauth || true
printf "\n" | /srv/www/${PHP_VERSION}/bin/pecl install imagick || true
/srv/www/${PHP_VERSION}/bin/pecl install amqp || true
printf "\n\n\n\n\n\n" | /srv/www/${PHP_VERSION}/bin/pecl install apc || true

git clone https://github.com/php-memcached-dev/php-memcached.git || true
cd php-memcached
git checkout 2.2.0
/srv/www/${PHP_VERSION}/bin/phpize
./configure -q --with-php-config=/srv/www/${PHP_VERSION}/bin/php-config
make -s
make -s install
cd ..

cd ${PHP_DIR}
cd ..
tar cjf /vagrant/${PHP_VERSION}.tar.bz2 ${PHP_VERSION}
