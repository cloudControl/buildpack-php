# Fail fast and fail hard.
set -eo pipefail

PHP_VERSION=php-5.5.26

source /vagrant/prepare-vm.sh
/vagrant/php-build.sh ${PHP_VERSION}
