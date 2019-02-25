FROM java:openjdk-8-alpine

ENV ANDROID_HOME="/android-sdk" GRADLE="/gradle"

# android
WORKDIR $ANDROID_HOME
ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:${PATH}"

RUN apk add --update openssl \ 
    && wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip \
    && unzip sdk-tools-linux-4333796.zip \
    && rm -f sdk-tools-linux-4333796.zip \
    && yes | tools/bin/sdkmanager "platforms;android-28" "build-tools;28.0.3" "platform-tools" "tools"

# gradle
WORKDIR $GRADLE
RUN wget https://services.gradle.org/distributions/gradle-3.4.1-bin.zip \
    && unzip -d . gradle-3.4.1-bin.zip \
    && rm -f gradle-3.4.1-bin.zip

ENV PATH="$GRADLE/gradle-3.4.1/bin:${PATH}"

# node
RUN apk add --update nodejs \
    && npm install -g ionic cordova \
    && cordova telemetry off

WORKDIR /