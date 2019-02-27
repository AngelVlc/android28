FROM node:10.15.1-jessie-slim

# java
RUN mkdir -p /usr/share/man/man1 \
  && echo "deb http://http.debian.net/debian jessie-backports main" | tee --append /etc/apt/sources.list.d/jessie-backports.list > /dev/null \
  && apt-get update \
  && apt-get install -y -t jessie-backports openjdk-8-jdk

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" ANDROID_HOME="/android-sdk" GRADLE="/gradle" PATH="$JAVA_HOME/bin:${PATH}"

# android
WORKDIR $ANDROID_HOME
RUN apt-get install unzip \
  && wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
  && unzip sdk-tools-linux-4333796.zip \
  && rm -f sdk-tools-linux-4333796.zip \
  && yes | tools/bin/sdkmanager "platforms;android-27" "build-tools;28.0.3" "platform-tools" "tools"
ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:${PATH}"

# gradle
WORKDIR $GRADLE
RUN wget https://services.gradle.org/distributions/gradle-4.1-all.zip \
  && unzip -d . gradle-4.1-all.zip \
  && rm -f gradle-4.1-all.zip
ENV PATH="$GRADLE/gradle-4.1/bin:${PATH}"

# ionic & cordova
RUN npm install -g ionic@4.10.3 cordova@8.1.2 \
  && cordova telemetry off
