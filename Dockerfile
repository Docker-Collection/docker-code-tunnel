FROM ubuntu:24.04

RUN set -xe; \
    \
    # Script place    
    mkdir /app; \
    \
    # Disable recommand install and suggests
    echo 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/01norecommends; \
    \
    # Get apt package
    apt-get update; \
    \
    # Install some tools
    apt-get install -y git curl wget sudo jq zip build-essential; \
    \
    # Install Python3
    apt-get install -y python3 python3-pip python3-venv; \
    \
    # Install Golang
    wget -O /tmp/golang-linux.tar.gz "https://go.dev/dl/go1.20.3.linux-$([ "$(uname -m)" = "x86_64" ] && echo "amd64" || echo "arm64").tar.gz"; \
    rm -rf /usr/local/go; \
    tar -C /usr/local -xzf /tmp/golang-linux.tar.gz; \
    rm /tmp/golang-linux.tar.gz; \
    echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/profile; \
    \
    # Install Nodejs
    curl -fsSL https://deb.nodesource.com/setup_19.x | bash -; \
    apt-get install -y nodejs; \
    \
    # Install VSCode Cli
    wget -O /tmp/vscode-cli.tar.gz "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-$([ "$(uname -m)" = "x86_64" ] && echo "x64" || echo "arm64")"; \
    tar -xf /tmp/vscode-cli.tar.gz -C /usr/bin; \
    rm /tmp/vscode-cli.tar.gz; \
    \
    # Cleanup apt
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf \
       tmp/* \
       /var/tmp/* \
       /var/lib/apt/lists/*

# Verify Install
RUN set -xe; \
    python3 --version; \
    /usr/local/go/bin/go version; \
    node --version; \
    code --version

# Setup User
RUN set -xe; \
    # Create user and home directory
    useradd -m -s /bin/bash -G sudo -p "" ubuntu

ENV VSCODE_CLI_DATA_DIR=/home/ubuntu

COPY entrypoint.sh /app/

USER ubuntu
WORKDIR /home/ubuntu

ENTRYPOINT [ "/app/entrypoint.sh" ]
