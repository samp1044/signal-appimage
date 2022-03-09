
mkdir release
docker build -t buildsignal .

./run.sh

docker stop buildsignal
docker rm buildsignal

docker image prune -a -f
