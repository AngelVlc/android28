# android-28

Docker image with:

- node
- java 8
- android 28
- gradle 3.4.1
- ionic
- cordova

I use this image to build ionic projects for Android without Android Studio.

## Test the image

```
docker build . -t android-28
docker run -it --name my-android android-28 sh
```