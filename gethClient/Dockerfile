# Use a specific version of ubuntu
FROM ubuntu:18.04 as builder

# Install wget
RUN apt-get update && apt-get install -y wget

# Download and extract geth
RUN wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.11.2-5b225d99.tar.gz \
    && tar -xzf geth-linux-amd64-1.11.2-5b225d99.tar.gz

# Create the final runtime image
FROM ubuntu:18.04

# Copy the geth binary from the builder stage
COPY --from=builder /geth-linux-amd64-1.11.2-5b225d99/geth /usr/local/bin/

# Create a data directory
RUN mkdir /data

# Set the working directory
WORKDIR /data

# Expose ports
EXPOSE 8545
EXPOSE 8546

# Set the default command
CMD ["geth", "--rpc", "--rpcaddr", "0.0.0.0"]
