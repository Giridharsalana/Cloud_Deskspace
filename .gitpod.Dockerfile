FROM gitpod/workspace-full-vnc:latest

LABEL maintainer="giridharsalana@gmail.com"

# Gui Setup
RUN sudo apt-get update && \
    sudo apt-get install -y libx11-dev libxkbfile-dev libsecret-1-dev libgconf-2-4 libnss3 && \
    sudo rm -rf /var/lib/apt/lists/*

# Install Dependencies
RUN sudo apt-get update \
    && sudo apt-get install -y libgtk-3-dev \
    && sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*

# Install custom tools, runtime, etc.
RUN sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install --quiet --yes fish
    
# Flutter Setup
RUN sudo apt update && sudo apt install -y curl git unzip xz-utils zip libglu1-mesa wget openjdk-8-jdk nala

# Prepare Android directories and system variables
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/gitpod/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# Set up Android SDK
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
RUN cd Android/sdk/tools/bin && ./sdkmanager --install "cmdline-tools;latest"
ENV PATH "$PATH:/home/gitpod/Android/sdk/platform-tools"

# Java 11 Install 
RUN sudo apt update -y && sudo apt install -y openjdk-11-jdk

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/gitpod/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor
RUN flutter channel stable
RUN flutter upgrade
# Flutter Setup End
    
# Apply user-specific settings
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
ENTRYPOINT [ "bash" ]
