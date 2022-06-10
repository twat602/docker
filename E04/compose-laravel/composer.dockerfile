FROM composer:2

# RUN addgroup -g 1000 --system laurent
# RUN adduser -G www-data --system -D -s /bin/sh -u 1000 laurent

RUN adduser -g www-data -s /bin/sh -D laurent