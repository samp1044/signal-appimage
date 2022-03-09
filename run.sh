#!/bin/sh

docker stop buildsignal
docker rm buildsignal
docker run -v /home/sami/repos/signal/release:/release -it --name buildsignal buildsignal
