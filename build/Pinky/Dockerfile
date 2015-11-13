FROM localhost:5000/cloudcontrol/ccpinky

MAINTAINER cloudControl

# Install packages required to build PHP that are not in the runtime stack
RUN apt-get update && apt-get install -y \
    autoconf \
    freetds-dev \
    libbison-dev \
    libicu-dev \
    libmcrypt-dev \
    libreadline-dev \
    re2c

# Set symlinks for libsybdb so the PHP build can find it
RUN ln -f -s /usr/lib/x86_64-linux-gnu/libsybdb.a /usr/lib/libsybdb.a \
    && ln -f -s /usr/lib/x86_64-linux-gnu/libsybdb.so /usr/lib/libsybdb.so

CMD ["/bin/bash"]
