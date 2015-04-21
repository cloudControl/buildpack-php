
cd /tmp

export DEBIAN_FRONTEND=noninteractive

echo "LC_ALL=en_US.UTF-8" > /etc/default/locale
echo "LANG=en_US.UTF-8" >> /etc/default/locale
. /etc/default/locale

apt-get update -qq
apt-get upgrade -y -qq

apt-get install -y -qq libxml2-dev libpng-dev libicu-dev libxslt-dev libcurl4-openssl-dev pkg-config libjpeg-dev libfreetype6-dev libmcrypt-dev freetds-dev libbz2-dev libpq-dev libreadline-dev autoconf imagemagick git libtool s3cmd libmagickwand-dev libsasl2-dev libbison-dev re2c

# configure: error: Could not find /usr/lib/libsybdb.a|so
ln -f -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a
ln -f -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so

curl --silent --location https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz | tar zx
cd libmemcached-1.0.18
# patch unfixed libmemcached bug causing "No worthy mechs found" log lines
patch -p1 < "/vagrant/libmemcached_sasl_memset.patch"
./configure -q
make -s
make -s install
cd ..

git clone https://github.com/alanxz/rabbitmq-c.git
cd rabbitmq-c
git checkout v0.5.2
git submodule update --init
autoreconf -i
./configure -q
make -s
make -s install
cd ..

ldconfig

pip install python-dateutil
git clone https://github.com/s3tools/s3cmd.git /home/vagrant/s3cmd
