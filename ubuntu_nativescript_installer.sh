#!/bin/bash
# Ubuntu Developer Script For Telerik NativeScript
# Created by Nic Raboy
# http://www.nraboy.com
#
#
# Downloads and configures the following:
#
#   Java JDK
#   Android
#   NPM
#   NativeScript

INSTALL_PATH=/opt
ANDROID_SDK_PATH=/opt/android-sdk
NODE_PATH=/opt/node
PARENT_USER=$(who am i | awk '{print $1}')

# Latest Android, Node.js as of 01-27-2016
ANDROID_SDK_X64="http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz"
NODE_X64="https://nodejs.org/download/release/v4.2.6/node-v4.2.6-linux-x64.tar.gz"

# Add i386 architecture
dpkg --add-architecture i386

# Update all Ubuntu software repository lists
apt-get update

# Android SDK requires some x86 architecture libraries even on x64 system
apt-get install -qq -y libc6:i386 libgcc1:i386 libstdc++6:i386 libz1:i386

# Install JDK, G++ and Apache Ant
apt-get -qq -y install default-jdk g++

# Set JAVA_HOME based on the default OpenJDK installed
if [ -z "$JAVA_HOME" ]; then
    export JAVA_HOME="$(find /usr -type l -name 'default-java')"
    if [ "$JAVA_HOME" != "" ]; then
        echo "export JAVA_HOME=$JAVA_HOME" >> ".profile"
    fi
else
    echo "The Java Development Kit was already installed"
fi

cd /tmp

if [ -z "$NODE_HOME" ]; then
    wget -c "$NODE_X64" -O "nodejs.tgz" --no-check-certificate
    tar zxf "nodejs.tgz" -C "$INSTALL_PATH"
    cd "$INSTALL_PATH" && mv "node-v4.2.6-linux-x64" "node"
    cd ~/ && echo "export NODE_HOME=$NODE_PATH" >> ".profile"
    cd ~/ && echo "export PATH=\$PATH:$NODE_PATH/bin" >> ".profile"
    export PATH=$PATH:$NODE_PATH/bin
else
    echo "Node $(node -v) was already installed"
fi

if [ -z "$ANDROID_HOME" ]; then
    wget -c "$ANDROID_SDK_X64" -O "android-sdk.tgz" --no-check-certificate
    tar zxf "android-sdk.tgz" -C "$INSTALL_PATH"
    cd "$INSTALL_PATH" && mv "android-sdk-linux" "android-sdk"
    cd "$INSTALL_PATH" && chown $PARENT_USER:$PARENT_USER "android-sdk" -R
    cd "$INSTALL_PATH" && chmod 777 "android-sdk" -R
    cd ~/ && echo "export ANDROID_HOME=$ANDROID_SDK_PATH" >> ".profile"
    cd ~/ && echo "export PATH=\$PATH:$ANDROID_SDK_PATH/tools" >> ".profile"
    cd ~/ && echo "export PATH=\$PATH:$ANDROID_SDK_PATH/platform-tools" >> ".profile"
    export PATH=$PATH:$ANDROID_SDK_PATH/tools
    export PATH=$PATH:$ANDROID_SDK_PATH/platform-tools
    echo y | android update sdk --no-ui --filter tools,platform-tools,build-tools-23.0.2,android-23,addon-google_apis-google-23,extra-android-m2repository,extra-android-support
else
    echo "The Android SDK was already installed"
fi

# Install Telerik NativeScript
npm install -g nativescript --unsafe-perm

cd "$INSTALL_PATH" && chmod 777 "node" -R
cd ~/ && chown $PARENT_USER:$PARENT_USER ".android" -R
cd ~/ && chown $PARENT_USER:$PARENT_USER ".node-gyp" -R
cd ~/ && chown $PARENT_USER:$PARENT_USER ".tnsrc" -R
cd ~/.local/share && chown $PARENT_USER:$PARENT_USER ".nativescript-cli" -R

echo "----------------------------------"
echo "Restart your Ubuntu session for installation to complete..."
