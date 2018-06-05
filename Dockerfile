FROM ubuntu
MAINTAINER neold2028

RUN apt update
RUN apt install build-essential libpcre3 libpcre3-dev libssl-dev -y
COPY master.zip /master.zip
COPY nginx-1.14.0.tar.gz /nginx-1.14.0.tar.gz
RUN tar -zxvf nginx-1.14.0.tar.gz
RUN apt install unzip -y
RUN unzip master.zip
RUN apt install zlib1g-dev -y
RUN cd nginx-1.14.0 && ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master && make && make install
COPY nginx-config-rtmp.txt /nginx-config-rtmp.txt
RUN cat /usr/local/nginx/conf/nginx.conf /nginx-config-rtmp.txt > /usr/local/nginx/conf/nginx.conf.new && mv /usr/local/nginx/conf/nginx.conf.new /usr/local/nginx/conf/nginx.conf

ENTRYPOINT /usr/local/nginx/sbin/nginx -g 'daemon off;'
