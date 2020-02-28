# Base image to work from
FROM alpine:latest

# Add the necessary Alpine packages
RUN apk add --update gzip curl nodejs

# Add the group of the unpriviledged user
RUN addgroup -g 1000 -S user

# Add the unpriviledged user
RUN adduser -h /home/user -g "" -s /bin/sh -G user -S -D -u 1000 user

# Download the Elm binary directly from the official GitHub repository
RUN curl -Lo elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz

# Unzip the binary archive
RUN gunzip elm.gz

# Allow the binary to be run as an executable
RUN chmod +x elm

# Move the binary to the global binaries path
RUN mv elm /usr/local/bin
