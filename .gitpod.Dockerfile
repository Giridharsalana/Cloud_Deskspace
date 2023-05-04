FROM gitpod/workspace-full-vnc

LABEL maintainer="giridharsalana@gmail.com"

# Install custom tools, runtime, etc.
RUN sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install --quiet --yes fish
    
# Flutter Setup
RUN sudo apt update && sudo apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# Gui Setup
RUN sudo apt-get update && \
    sudo apt-get install -y libgtk-3-dev && \
    sudo rm -rf /var/lib/apt/lists/*

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

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/gitpod/flutter/bin"

# Run basic check to download Dark SDK
RUN flutter doctor
RUN flutter channel stable
RUN flutter upgrade
# Flutter Setup End
    
# Apply user-specific settings

RUN mkdir -p /home/gitpod/.config/fish/

RUN  echo "function c\n    clear\nend" > /home/gitpod/.config/fish/config.fish

RUN sudo chsh -s /usr/bin/fish

ENV SHELL /usr/bin/fish

ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8

ENTRYPOINT [ "fish" ]
