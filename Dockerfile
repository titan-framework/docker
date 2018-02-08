FROM debian:stretch

LABEL author 'Camilo Carromeu <camilo@carromeu.com>'

ADD . /root/docker

ADD ./startup.sh /root/

RUN /root/docker/bootstrap.sh

RUN rm -rf /root/docker

VOLUME [ "/var/www/app", "/var/lib/postgresql/db" ]

EXPOSE 80 443 5432