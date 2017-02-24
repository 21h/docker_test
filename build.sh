#!/bin/bash
datadir=/home/vlad/Documents/docker/datadir

#get some images
docker pull mysql/mysql-server:5.7
docker pull phpdockerio/php71-fpm
docker pull nginx:latest

#build some too
docker build postfix --tag=postfix

#run
docker run --name mail  -p 25:25 -v $datadir/maildirs:/var/mail -d postfix
docker run --name php   -p 9000:9000  -v $datadir/wordpress/:/wordpress -d phpdockerio/php71-fpm
docker run --name mysql -p 3306:3306 -v $datadir/mysql/data:/var/lib/mysql -v $datadir/script.sql:/script.sql -v $datadir/dbinit.sh:/dbinit.sh -v $datadir/mysql/my.cnf:/etc/my.cnf -e MYSQL_ROOT_PASSWORD=123 -d mysql/mysql-server:5.7
docker run --name nginx -p 80:80 -v $datadir/wordpress/:/wordpress -v $datadir/wpsite.ru:/etc/nginx/conf.d/default.conf -d nginx:latest

#exec script to allow root
docker exec -it mysql /dbinit.sh

#install php ext
docker exec php apt-get update
docker exec php apt-get install -y php-mysql

#initial steps finished. shutting down.
docker stop php mail mysql nginx

