FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y mc wget nginx php7.0-fpm php7.0-curl php7.0-mysql php7.0-mcrypt
RUN apt-get update \
    && apt-get install -y debconf-utils \
    && echo mysql-server mysql-server/root_password password 123456 | debconf-set-selections \
    && echo mysql-server mysql-server/root_password_again password 123456 | debconf-set-selections \
    && apt-get install -y mysql-server -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing
RUN echo mysql-server postfix/main_mailer_type text "No configuration" | debconf-set-selections \
    && apt-get install -y postfix -o pkg::Options::="--force-confdef" -o pkg::Options::="--force-confold" --fix-missing
COPY latest.tar.gz /tmp/latest.tar.gz
RUN tar -xvzf /tmp/latest.tar.gz -C /var/www
COPY conf/* /etc/
EXPOSE 80
