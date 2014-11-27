FROM jolicode/php53
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN cd /tmp/ && \
     wget http://pecl.php.net/get/memcache-2.2.7.tgz && \
    tar zxvf memcache-2.2.7.tgz && \
    cd memcache-2.2.7 && \
    /home/.phpenv/versions/5.3.29/bin/phpize && \
    ./configure --with-php-config=/home/.phpenv/versions/5.3.29/bin/php-config --enable-memcache && \
    PREFIX=/home/.phpenv/versions/5.3.29/ make && \
    cp modules/* /home/.phpenv/versions/5.3.29/lib/ && \
    touch /home/.phpenv/versions/5.3.29/etc/conf.d/memcache.ini && \
    echo 'extension=/home/.phpenv/versions/5.3.29/lib/memcache.so' > /home/.phpenv/versions/5.3.29/etc/conf.d/memcache.ini

COPY xdebug.ini /home/.phpenv/versions/5.3.29/etc/conf.d/
COPY php-fpm.conf /home/.phpenv/versions/5.3.29/etc/
COPY php.ini /home/.phpenv/versions/5.3.29/etc/

RUN cd /tmp/ && \
     wget http://pecl.php.net/get/APC-3.1.13.tgz && \
    tar zxvf APC-3.1.13.tgz && \
    cd APC-3.1.13 && \
    /home/.phpenv/versions/5.3.29/bin/phpize && \
    ./configure --with-php-config=/home/.phpenv/versions/5.3.29/bin/php-config && \
    PREFIX=/home/.phpenv/versions/5.3.29/ make && \
    cp modules/* /home/.phpenv/versions/5.3.29/lib/ && \
    touch /home/.phpenv/versions/5.3.29/etc/conf.d/apc.ini && \
    echo 'extension=/home/.phpenv/versions/5.3.29/lib/apc.so' > /home/.phpenv/versions/5.3.29/etc/conf.d/apc.ini

RUN cd /tmp/ && \
    wget http://downloads.zend.com/guard/5.5.0/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz && \
    tar -zxvf ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz && \
    cd ZendGuardLoader-php-5.3-linux-glibc23-x86_64 && \
    cp php-5.3.x/* /home/.phpenv/versions/5.3.29/lib/ && \
    touch /home/.phpenv/versions/5.3.29/etc/conf.d/zend_guard_loader.ini && \
    echo 'zend_extension=/home/.phpenv/versions/5.3.29/lib/ZendGuardLoader.so' > /home/.phpenv/versions/5.3.29/etc/conf.d/zend_guard_loader.ini

EXPOSE 9000
EXPOSE 9900

CMD ["/home/.phpenv/versions/5.3.29/sbin/php-fpm", "-F"]
