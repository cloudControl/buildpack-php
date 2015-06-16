# Fail fast and fail hard.
set -eo pipefail

PHP_VERSION=php-5.4.42

source /vagrant/prepare-vm.sh
/vagrant/php-build.sh ${PHP_VERSION}
