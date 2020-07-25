FROM ubuntu:focal
# Replace the base image by one containing your dev toolchain

ARG USER=docker
ARG UID=1000
ARG GID=1000
ARG PW=docker

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y --no-install-recommends \
    vim \
    git \
    zsh \
    tmux \
    ripgrep \
    nodejs \
    npm \
    zlib1g \
    curl \
    locales \
    sudo && \
    # Cleanup
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# Fix sudo 1.8
RUN echo "Set disable_coredump false" > /etc/sudo.conf

# Install bat: A cat(1) clone with syntax highlighting and git integration
# see https://github.com/sharkdp/bat
RUN curl -L https://github.com/sharkdp/bat/releases/download/v0.15.4/bat_0.15.4_amd64.deb --output bat_0.15.4_amd64.deb && \
    dpkg -i bat_0.15.4_amd64.deb

# Set the locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set zsh as default shell
RUN chsh -s $(which zsh)

# Setup default user
RUN useradd -l -m -s $(which zsh) -u ${UID} ${USER} && \
    echo "${USER}:${PW}" | chpasswd && \
    adduser ${USER} sudo

USER ${UID}:${GID}
WORKDIR /home/${USER}

# Install "Oh my zsh!"
# see https://ohmyz.sh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    rm -rf $HOME/.zshrc

# Install my dotfiles
# see https://github.com/gcuendet/dotfiles
RUN zsh -c "$(curl https://raw.githubusercontent.com/gcuendet/dotfiles/master/.install_dotfiles.sh)"

ENV DEBIAN_FRONTEND=dialog

ENTRYPOINT ["/bin/zsh"]