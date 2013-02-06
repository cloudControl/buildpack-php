# PHP buildpack
This is the [cloudControl PaaS](https://www.cloudcontrol.com) PHP buildpack conforming to the [Heroku buildpack api](https://devcenter.heroku.com/articles/buildpack-api). It runs PHP applications using Apache and PHP-FPM.

## Composer - dependency management
[Composer](https://getcomposer.org/) is used to manage the dependencies. There should be a 'composer.json' file in the top directory of the project.

For example the 'composer.json' file, for a project that uses the Zend
framework, would look like this:
~~~json

{
    "name": "application-name",
    "description": "Application's description",
    "license": "the-licence",
    "keywords": [
        "keyword1",
        "keyword2"
    ],
    "homepage": "http://example.com/",
    "require": {
        "php": ">=5.3.3",
        "zendframework/zendframework": "2.*"
    }
}
~~~

It is also possible to include composer executable (composer.phar) in the top directory of the project. In this case provided composer executable will be used instead of platform default one.

## Frameworks
The following frameworks are currently supported:

* [Symfony 1](http://symfony.com/legacy)
* [Symfony 2](http://symfony.com/)
* [Zend 1](http://framework.zend.com/)
* [Zend 2](http://framework.zend.com/)
* [Yii](http://www.yiiframework.com/)
* [Kohana](http://kohanaframework.org/)
* [CakePhp](http://www.cakephp.de/)

Other frameworks might work if you just
[specify the DocumentRoot](#manually-setting-the-documentroot) manually.

## Configuration
### Buildpack

You can place buildpack configuration in the `.buildpack` directory of your repository. Some influential variables can be set in the file `.buildpack/envrc`.

Currently supported variables are:

`COMPOSER_INSTALL_ARGS` to set additional arguments you want to pass to the composer install command.

Example .buildpack/envrc:

~~~bash
export COMPOSER_INSTALL_ARGS="--prefer-source --optimize-autoloader"
~~~

### Apache
For normal deployments the buildpack's default settings should work out of the
box. If you want to pass additional options to Apache, place them in files under
.buildpack/apache/conf directory. All files in this directory ending in .conf get included
at the end of Apache's httpd.conf.

#### Manually Setting the DocumentRoot
By default the document root of the web application is '/app/code'. This can be modified in custom Apache configuration files too. Below is the example of the Apache configuration file (e.g. `.buildpack/apache/conf/custom_document_root.conf`) specifying a custom [DocumentRoot](http://httpd.apache.org/docs/current/mod/core.html#documentroot) and [Directory](http://httpd.apache.org/docs/current/mod/core.html#directory):

    # If the webroot is /page/public in your project, the DocumentRoot will be
    # /app/code/page/public
    DocumentRoot /app/code/page/public
    # allow access to this directory (required)
    <Directory /app/code/page/public>
        AllowOverride All
        Options SymlinksIfOwnerMatch
        Order Deny,Allow
        Allow from All
        DirectoryIndex index.php index.html index.htm
    </Directory>

#### Create Alias
Whenever need to map between URLs and file system paths not being under DocumentRoot specify [alias](http://httpd.apache.org/docs/2.2/mod/mod_alias.html#alias) and pass it in custom configuration file, e.g `.buildpack/apache/conf/sf_alias.conf`:

    #Create alias for symfony resources
    Alias /sf /app/code/lib/vendor/symfony/data/web/sf
    <Directory /app/code/lib/vendor/symfony/data/web/sf>
        AllowOverride All
        Options SymlinksIfOwnerMatch
        Order Deny,Allow
        Allow from All
    </Directory>

#### Supported Apache Modules:

The following Apache Modules are available as part of the Pinky stack:

* [mod_actions](http://httpd.apache.org/docs/2.2/mod/mod_actions.html)
* [mod_alias](http://httpd.apache.org/docs/2.2/mod/mod_alias.html)
* [mod_auth_basic](http://httpd.apache.org/docs/2.2/mod/mod_auth_basic.html)
* [mod_authn_file](http://httpd.apache.org/docs/2.2/mod/mod_authn_file.html)
* [mod_authz_default](http://httpd.apache.org/docs/2.2/mod/mod_authz_default.html)
* [mod_authz_groupfile](http://httpd.apache.org/docs/2.2/mod/mod_authz_groupfile.html)
* [mod_authz_host](http://httpd.apache.org/docs/2.2/mod/mod_authz_host.html)
* [mod_authz_user](http://httpd.apache.org/docs/2.2/mod/mod_authz_user.html)
* [mod_autoindex](http://httpd.apache.org/docs/2.2/mod/mod_autoindex.html)
* [mod_deflate](http://httpd.apache.org/docs/2.2/mod/mod_deflate.html)
* [mod_dir](http://httpd.apache.org/docs/2.2/mod/mod_dir.html)
* [mod_env](http://httpd.apache.org/docs/2.2/mod/mod_env.html)
* [mod_expires](http://httpd.apache.org/docs/2.2/mod/mod_expires.html)
* [mod_headers](http://httpd.apache.org/docs/2.2/mod/mod_headers.html)
* [mod_mime](http://httpd.apache.org/docs/2.2/mod/mod_mime.html)
* [mod_negotiation](http://httpd.apache.org/docs/2.2/mod/mod_negotiation.html)
* [mod_reqtimeout](http://httpd.apache.org/docs/2.2/mod/mod_reqtimeout.html)
* [mod_rewrite](http://httpd.apache.org/docs/2.2/mod/mod_rewrite.html)
* [mod_setenvif](http://httpd.apache.org/docs/2.2/mod/mod_setenvif.html)
* [mod_status](http://httpd.apache.org/docs/2.2/mod/mod_status.html)

### PHP
Similarly, the default PHP configuration can be overridden or extended by specifying custom configuration files in .buildpack/php/conf directory. They should follow the PHP config syntax and should have an '.ini' extension, e.g:

	[MySQL]
	mysql.allow_persistent = On
	mysql.max_persistent = -1
	mysql.max_links = -1
	mysql.connect_timeout = 60
	mysql.trace_mode = Off

	[MySQLi]
	mysqli.max_links = -1
	mysqli.default_port = 3306
	mysqli.default_host = 127.0.0.1
	mysqli.reconnect = Off

	[APC]
	apc.stat = 1
	apc.enabled = 0
	apc.shm_size = 27M
