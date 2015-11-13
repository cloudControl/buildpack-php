# Build php

Building PHP requires a working Docker setup with the latest stack images
available. The Makefile does take care of building the docker container and
run the PHP buildscript.

## Build all Stacks

```
make version=VERSION  # e.g. php-5.6.12
```

## Build a specific stack

```
make STACK version=VERSION  # e.g. trinity
```

## Cleanup

```
make clean
```

## Builds

 - php-5.4.39
 - php-5.4.40
 - php-5.4.41
 - php-5.4.42
 - php-5.4.43
 - php-5.4.44
 - php-5.5.23
 - php-5.5.24
 - php-5.5.25
 - php-5.5.26
 - php-5.5.27
 - php-5.5.28
 - php-5.6.10
 - php-5.6.11
 - php-5.6.12
