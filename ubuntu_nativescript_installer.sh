#!/bin/bash
# Ubuntu Developer Script For Telerik NativeScript
# Created by Nic Raboy
# http://www.nraboy.com
#
#
# Downloads and configures the following:
#
#   Java JDK
#   Apache Ant
#   Android
#   NPM
#   NativeScript
#   Gradle

INSTALL_PATH=/opt
ANDROID_SDK_PATH=/opt/android-sdk
NODE_PATH=/opt/node
GRADLE_PATH=/opt/gradle

# Latest Android, Node.js, and Gradle as of
ANDROID_SDK_X64="http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz"
NODE_X64="https://nodejs.org/download/release/v0.12.9/node-v0.12.9-linux-x64.tar.gz"
GRADLE_ALL="https://services.gradle.org/distributions/gradle-2.9-all.zip"

if [ "$EUID" -eq 0 ]; then
    echo "This script cannot be run as the root user"
    exit
fi

# Add i386 architecture
dpkg --add-architecture i386

# Update all Ubuntu software repository lists
apt-get update

cd /tmp

if [ -z "$(node -v)" ]; then
    wget -c "$NODE_X64" -O "nodejs.tgz" --no-check-certificate
    tar zxf "nodejs.tgz" -C "$INSTALL_PATH"
    cd "$INSTALL_PATH" && mv "node-v0.12.9-linux-x64" "node"
    cd ~/ && echo "export PATH=\$PATH:$NODE_PATH/bin" >> ".profile"
    export PATH=$PATH:$NODE_PATH/bin
else
    echo "Node $(node -v) was already installed"
fi

if [ -z "$ANDROID_HOME" ]; then
    wget -c "$ANDROID_SDK_X64" -O "android-sdk.tgz" --no-check-certificate
    tar zxf "android-sdk.tgz" -C "$INSTALL_PATH"
    cd "$INSTALL_PATH" && mv "android-sdk-linux" "android-sdk"
    cd ~/ && echo "export ANDROID_HOME=$ANDROID_SDK_PATH" >> ".profile"
    cd ~/ && echo "export PATH=\$PATH:$ANDROID_SDK_PATH/tools" >> ".profile"
    cd ~/ && echo "export PATH=\$PATH:$ANDROID_SDK_PATH/platform-tools" >> ".profile"
    export PATH=$PATH:$ANDROID_SDK_PATH/tools
    export PATH=$PATH:$ANDROID_SDK_PATH/platform-tools
else
    echo "The Android SDK was already installed"
fi

if [ -z "(gradle -v | grep Gradle)" ]; then
    wget -c "$GRADLE_ALL" -O "gradle.zip" --no-check-certificate
    unzip "gradle.zip"
    mv "gradle-2.9" "$INSTALL_PATH"
    cd "$INSTALL_PATH" && mv "gradle-2.9" "gradle"
    cd ~/ && echo "export PATH=\$PATH:$GRADLE_PATH/bin" >> ".profile"
    export PATH=$PATH:$GRADLE_PATH/bin
else
    echo "Gradle was already installed"
fi

# Android SDK requires some x86 architecture libraries even on x64 system
apt-get install -qq -y libc6:i386 libgcc1:i386 libstdc++6:i386 libz1:i386

cd "$INSTALL_PATH" && chown root:root "android-sdk" -R
cd "$INSTALL_PATH" && chmod 777 "android-sdk" -R

# Install JDK and Apache Ant
apt-get -qq -y install default-jdk ant

# Set JAVA_HOME based on the default OpenJDK installed
export JAVA_HOME="$(find /usr -type l -name 'default-java')"
if [ "$JAVA_HOME" != "" ]; then
    echo "export JAVA_HOME=$JAVA_HOME" >> ".profile"
fi

# Install Telerik NativeScript
npm install -g nativescript

cd "$INSTALL_PATH" && chmod 777 "node" -R
cd "$INSTALL_PATH" && chmod 777 "gradle" -R

echo "----------------------------------"
echo "Restart your Ubuntu session for installation to complete..."
