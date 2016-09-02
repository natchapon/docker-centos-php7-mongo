docker stop $(docker ps -a -q)
docker build -t centos7-apache-php7-mongo:test .
docker run -t -i -p 80 -p 27017 centos7-apache-php7-mongo:test