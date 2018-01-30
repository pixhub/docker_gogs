FROM debian:9-slim

ENV GOROOT=/home/git/local/go \
    GOPATH=/home/git/go \
    USERNAME=git \
    USER=git
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin

RUN useradd -ms /bin/bash git && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
            git \
            openssh-server \
            wget && \
    mkdir /home/git/ssh && \
    chown -R 1000:1000 /home/git && \
    mv /etc/ssh/ssh_host* /home/git/ssh

COPY sshd_config /etc/ssh

RUN service ssh restart

USER git

RUN mkdir /home/git/local && \
    cd /home/git/local  && \
    wget https://dl.google.com/go/go1.9.3.linux-amd64.tar.gz && \
    tar xzvf go1.9.3.linux-amd64.tar.gz && \
    rm -rf go1.9.3.linux-amd64.tar.gz && \
    go get -u github.com/gogits/gogs && \
    cd $GOPATH/src/github.com/gogits/gogs && \
    go build

ENTRYPOINT ["gogs", "web"]

