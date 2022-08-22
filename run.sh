#!/bin/sh

docker stop buildsignal
docker rm buildsignal
docker run -v $PWD/release:/release -it --name buildsignal buildsignal
