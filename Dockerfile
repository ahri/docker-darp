FROM ahri/base

RUN apt-get update -qq && \
    apt-get -qqy install nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

ENV DAEMON_USER root
ENV DAEMON_BIN /usr/sbin/nginx
RUN mkdir -p /etc/service/nginx
ADD nginx.sh /etc/service/nginx/run

ADD bootstrap.sh bootstrap.sh

ENTRYPOINT ["/bootstrap.sh"]
