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

.dockerignore

```
node_modules
platforms
plugins
www
```

Dockerfile

```
FROM angelvlc/ionic-build as builder

ARG KEYSTORE_PASSWORD
ENV APP=/app KEYSTORE_PASSWORD=$KEYSTORE_PASSWORD

WORKDIR $APP
COPY . $APP

RUN bash buildAndroid
```

It needs a build arg with the pashprase of the keystore used to sign the apk.

Where buildAndroid is a bash script which should do this:

```
npm install

ionic cordova build android --release

jarsigner -sigalg SHA1withRSA -digestalg SHA1 -keystore keystore_path -storepass pass /app/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk alias_name

zipalign 4 /app/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk release_signed.apk
```
