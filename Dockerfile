FROM php:7.1.2-apache 

RUN docker-php-ext-install mysqli

# install node and npm
RUN apt-get update && apt-get install -y nodejs npm