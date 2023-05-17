FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

# Update and install packages
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    git \
    flex \
    bison \
    build-essential \
    wget \
    curl \
    vim \
    libc6:i386 \
    zsh \
    htop \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    python2 \
    perl \
    tcsh

# Install oh-my-zsh
RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Install starship
RUN curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Edit .zshrc
RUN echo "eval \"\$(starship init zsh)\"" >> ~/.zshrc

# Disable new line after prompt
RUN mkdir -p ~/.config && touch ~/.config/starship.toml
RUN echo "\"\$schema\" = 'https://starship.rs/config-schema.json'" >> ~/.config/starship.toml
RUN echo "add_newline = false" >> ~/.config/starship.toml

# set zsh as default shell
RUN chsh -s $(which zsh)

# Copy course files
WORKDIR /afs/ir/class
COPY cs143 cs143
WORKDIR /usr/class
COPY cs143u cs143

RUN echo "export PATH=/afs/ir/class/cs143/bin:\$PATH" >> ~/.zshrc

# Clean up
RUN apt-get clean
