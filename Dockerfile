# Reuse a base image made for devcontainers.
FROM mcr.microsoft.com/vscode/devcontainers/base:buster

# See example at:
# https://aaronlevin.ca/post/100703631408/installing-nix-within-a-docker-container

# Took the Nix configuration from:
# https://levelup.gitconnected.com/vs-code-remote-containers-with-nix-2a6f230d1e4e

# Took the initial flake config from the discussion at:
# https://discourse.nixos.org/t/how-do-nix-profiles-and-flakes-fit-together/28139/20

# Install packages required to add users and install Nix
RUN apt-get update && apt-get install -y curl bzip2 adduser

# Nix requires ownership of /nix.
RUN mkdir -m 0755 /nix && chown vscode /nix

# Configuration for Nix from the repository shared amongst developers.
COPY nix.conf /nix/nix.conf
RUN chown vscode /nix/nix.conf
ENV NIX_CONF_DIR /nix

# Change docker user to vscode
USER vscode

# Set some environment variables for Docker and Nix
ENV USER vscode

# Change our working directory to $HOME
WORKDIR /home/vscode

# Install Nix
ARG NIX_INSTALL_SCRIPT=https://releases.nixos.org/nix/nix-2.16.1/install
RUN curl ${NIX_INSTALL_SCRIPT} | sh

# update the nix channels
# Note: nix.sh sets some environment variables. Unfortunately in Docker
# environment variables don't persist across `RUN` commands
# without using Docker's own `ENV` command, so we need to prefix
# our nix commands with `. .nix-profile/etc/profile.d/nix.sh` to ensure
# nix manages our $PATH appropriately.
RUN . .nix-profile/etc/profile.d/nix.sh && nix-channel --update

# Copy our nix expression into the container.
COPY --chown=vscode flake.nix /home/vscode/

# Install the Flake contents.
RUN . .nix-profile/etc/profile.d/nix.sh && nix profile install .

# Add all the stuff to the path.
ENV PATH="${PATH}:~/.nix-profile/bin"
