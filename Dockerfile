FROM alpine as android-tools

WORKDIR /tmp
ADD https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip .
RUN unzip sdk-tools-linux-4333796.zip > /dev/null
ADD https://services.gradle.org/distributions/gradle-4.10.3-bin.zip .
RUN unzip gradle-4.10.3-bin.zip > /dev/null

# ---------------------------------------------
FROM node:16-stretch-slim

# java
RUN mkdir -p /usr/share/man/man1 \
  && apt-get update > /dev/null \
  && apt-get install -y openjdk-8-jdk-headless unzip > /dev/null

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
ENV ANDROID_HOME="/android-sdk"
ENV ANDROID_SDK_ROOT="/android-sdk"
ENV GRADLE="/gradle"
ENV PATH="$JAVA_HOME/bin:${PATH}"

# android
WORKDIR $ANDROID_HOME
COPY --from=android-tools /tmp/tools/bin/sdkmanager ./tools/bin/
COPY --from=android-tools /tmp/tools/lib/*.jar ./tools/lib/
RUN yes | tools/bin/sdkmanager "platforms;android-28" "build-tools;29.0.2" "platform-tools" "tools"  > /dev/null \
  && rm -rf emulator

ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/29.0.2:${PATH}"

# gradle
WORKDIR $GRADLE
COPY --from=android-tools /tmp/gradle-4.10.3/ .
ENV PATH="$GRADLE/bin:${PATH}"

ENV NG_CLI_ANALYTICS=false

# ionic & cordova
RUN npm install -g ionic cordova @angular/cli > /dev/null \
  && cordova telemetry off  > /dev/null
