FROM ubuntu:18.04

RUN apt-get update && apt-get install -y wget

RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.11.2-5b225d99.tar.gz \
    && tar -xzf geth-linux-amd64-1.11.2-5b225d99.tar.gz \
    && cp geth-linux-amd64-1.11.2-5b225d99/geth /usr/local/bin/

RUN mkdir /data

WORKDIR /data

EXPOSE 8545
EXPOSE 8546

CMD ["geth", "--rpc", "--rpcaddr", "0.0.0.0"]

