FROM nginx:stable-alpine

COPY conf/default.conf /etc/nginx/conf.d/default.conf

COPY src/index.html /var/wwww/html/public

RUN sed -i "s/user nginx/user teacher/g"/etc/nginx.conf

EXPOSE 80

RUN mkdir -p /var/www/html/public

RUN adduser -g teacher -s /bin/sh -D teacher
