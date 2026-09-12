FROM google85/devcontainer-asm-z80-vasm-sjasmplus:latest

# fix perl locale
USER root

RUN apt-get update && apt-get install -y --no-install-recommends locales \
 && sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen \
 && locale-gen \
 && rm -rf /var/lib/apt/lists/*
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

USER vscode

ENTRYPOINT [ "/bin/bash" ]