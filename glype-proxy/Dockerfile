FROM alpine:latest as build
LABEL maintainer="Julian Reith <julianreith@gmx.de>"
LABEL description="glype - a web-based proxy on webdevops/php-nginx:8.0-alpine"

WORKDIR /app

# install dependencies
RUN apk add --no-cache --virtual .git-deps \
    ca-certificates \
    dpkg \
    git \
    gnupg \
    less \
    openssh

# clone app
RUN git clone https://github.com/vincentclee/glype.git .

# copy app into container
FROM webdevops/php-nginx:8.0-alpine
WORKDIR /app
COPY --from=build /app/ /app/
RUN chown -R 1000:1000 /app
VOLUME /app
