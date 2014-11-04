FROM jolicode/php53
MAINTAINER Sascha Marcel Schmidt <docker@saschaschmidt.net>

RUN cd /tmp/ && \
	wget http://pecl.php.net/get/memcache-2.2.7.tgz && \
	tar zxvf memcache-2.2.7.tgz && \
	cd memcache-2.2.7 && \
	/home/.phpenv/versions/5.3.28/bin/phpize && \
	./configure --with-php-config=/home/.phpenv/versions/5.3.28/bin/php-config --enable-memcache && \
	PREFIX=/home/.phpenv/versions/5.3.28/ make && \
	cp modules/* /home/.phpenv/versions/5.3.28/lib/ && \
	touch /home/.phpenv/versions/5.3.28/etc/conf.d/memcache.ini && \
	echo 'extension=/home/.phpenv/versions/5.3.28/lib/memcache.so' > /home/.phpenv/versions/5.3.28/etc/conf.d/memcache.ini

COPY xdebug.ini /home/.phpenv/versions/5.3.28/etc/conf.d/
COPY php-fpm.conf /home/.phpenv/versions/5.3.28/etc/
COPY php.ini /home/.phpenv/versions/5.3.28/etc/

CMD ["/home/.phpenv/versions/5.3.28/sbin/php-fpm", "-F"]
