Docker PHP-FPM 7.0 & Nginx 1.10 on Alpine Linux
==============================================
Example PHP-FPM 7.0 & Nginx 1.10 setup for Docker, build on [Alpine Linux](http://www.alpinelinux.org/).
The image is only +/- 60MB large.


[![Docker Pulls](https://img.shields.io/docker/pulls/kasperfranz/docker-php-nginx.svg)](https://hub.docker.com/r/kasperfranz/docker-php-nginx/) [![](https://images.microbadger.com/badges/image/kasperfranz/docker-php-nginx.svg)](https://microbadger.com/images/kasperfranz/docker-php-nginx "Get your own image badge on microbadger.com")

Usage
-----
Start the Docker containers:

    sudo docker run -p 80:80 trafex/alpine-nginx-php7

See the PHP info on http://localhost, or the static html page on http://localhost/test.html

Resources & inspiration
-----------------------
https://ejosh.co/de/2015/09/how-to-link-docker-containers-together

https://github.com/johanan/Ansible-and-Docker
 