FROM php:8.1-cli-alpine

#envirotmen variable
ENV \
    APP_DIR="/app" \
    APP_PORT="8001"

#memindahkan file atau folder ke direktori yang di inginkan di docker
COPY . $APP_DIR
COPY .env.example $APP_DIR/.env

#menginstal kebutuhan yang ingin kita gunakan
RUN apk add --update \
    curl \
    php \
    php-opcache \
    php-openssl \
    php-pdo \
    php-json \
    php-phar \
    php-dom \
    && rm -rf /var/cache/apk/*

#menginstall composer
RUN curl -sS https://getcomposer.org/installer | php -- \
 --install-dir=/usr/bin --filename=composer

 #menjalankan perintah composer
 RUN cd $APP_DIR && composer update
 RUN cd $APP_DIR && php artisan key:generate

 #entrypoint
WORKDIR $APP_DIR
#
CMD php artisan serve --host=0.0.0.0 --port=$APP_PORT

#
EXPOSE $APP_PORT
