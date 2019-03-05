# ionic-build-image [![Build Status](https://travis-ci.org/AngelVlc/ionic-build-image.svg?branch=master)](https://travis-ci.org/AngelVlc/ionic-build-image)

Docker image with:

- node 10.15.1
- openjdk 8
- android (platform 27 + buildtools + platform-tools + tools)
- gradle 4.1
- ionic
- cordova

I use this image to build ionic projects for Android without Android Studio.

## Usage example

Dockerfile

```
FROM angelbh/ionic-build

ENV APP /app/

# app
WORKDIR $APP
COPY . $APP
```

docker-compose.yml

```
version: '2.2'
services:
  main:
    build: .
    command: bash -c "npm install && npm rebuild node-sass && ionic cordova build android"
    volumes:
      - '.:/app'
```

.dockerignore

```
node_modules
platforms
plugins
www
```