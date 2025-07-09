FROM gitpod/workspace-full-vnc:latest

LABEL maintainer="giridharsalana@gmail.com"

# Gui Setup
RUN sudo apt-get update && \
    sudo apt-get install -y libx11-dev libxkbfile-dev libsecret-1-dev libgconf-2-4 libnss3 && \
    sudo rm -rf /var/lib/apt/lists/*

# Install Dependencies
RUN sudo apt-get update \
    && sudo apt-get install -y libgtk-3-dev libwebkit2gtk-4.0-37 \
    && sudo apt-get clean && sudo rm -rf /var/cache/apt/* && sudo rm -rf /var/lib/apt/lists/* && sudo rm -rf /tmp/*

# Install custom tools, runtime, etc.
RUN sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get install --quiet --yes fish nala 

# Install UV
RUN curl -LsSf https://astral.sh/uv/install.sh | sh
    
# Apply user-specific settings
ENV LANG=C.UTF-8 LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8
ENTRYPOINT [ "bash" ]
