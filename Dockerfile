FROM node:16-buster-slim

ADD https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip /tmp

ADD https://services.gradle.org/distributions/gradle-7.5-bin.zip /tmp

ENV NODE_OPTIONS=--max_old_space_size=8096

# java
RUN mkdir -p /usr/share/man/man1 \
  && apt-get update \
  && apt-get install -y openjdk-11-jdk-headless unzip

ENV JAVA_HOME="/usr/lib/jvm/java-11-openjdk-amd64"
ENV ANDROID_HOME="/android-sdk"
ENV ANDROID_SDK_ROOT="/android-sdk"
ENV GRADLE="/gradle"
ENV PATH="$JAVA_HOME/bin:${PATH}"

# android
WORKDIR $ANDROID_HOME

RUN unzip /tmp/commandlinetools-linux-8512546_latest.zip
RUN mv cmdline-tools tools && mkdir cmdline-tools && mv tools cmdline-tools/
RUN rm /tmp/commandlinetools-linux-8512546_latest.zip
RUN yes | cmdline-tools/tools/bin/sdkmanager "platforms;android-33" "build-tools;32.0.0" "tools" && rm -rf emulator

ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/build-tools/32.0.0:${PATH}"

# gradle
WORKDIR $GRADLE
RUN unzip /tmp/gradle-7.5-bin.zip && rm /tmp/gradle-7.5-bin.zip
ENV PATH="$GRADLE/gradle-7.5/bin:${PATH}"

ENV NG_CLI_ANALYTICS=false

# ionic & cordova
RUN npm install --location=global @ionic/cli cordova cordova-res @angular/cli && cordova telemetry off
