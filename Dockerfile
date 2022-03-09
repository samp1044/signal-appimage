FROM fedora

ENV NVM_SH=v0.35.3

RUN dnf group install 'Development Tools' -y && dnf install g++ -y
RUN dnf install git-lfs -y
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_SH/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm" && \
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

RUN mkdir /release

COPY build.sh /build.sh

CMD ["sh", "/build.sh"]
