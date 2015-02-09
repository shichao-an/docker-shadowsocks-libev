FROM ubuntu:14.04
MAINTAINER Shichao An <shichao.an@nyu.edu>

ENV REFRESHED_AT 2015-02-05
RUN apt-get install -y wget
RUN wget -O- http://shadowsocks.org/debian/1D27208A.gpg | sudo apt-key add -
RUN echo 'deb http://shadowsocks.org/debian wheezy main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes shadowsocks-libev

VOLUME [ "/etc/shadowsocks-libev" ]
ENTRYPOINT [ "ss-server" ]
