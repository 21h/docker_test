#!/bin/bash
datadir=/home/vlad/Documents/docker/datadir

docker start php mail mysql nginx

docker network create wpnet
docker network connect wpnet nginx
docker network connect wpnet mysql
docker network connect wpnet php
docker network connect wpnet mail

docker ps 
