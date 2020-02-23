FROM alpine:latest

RUN apk add --update gzip curl nodejs
RUN addgroup -g 1000 -S user
RUN adduser -h /home/user -g "" -s /bin/sh -G user -S -D -u 1000 user
RUN curl -Lo elm.gz https://github.com/elm/compiler/releases/download/0.19.1/binary-for-linux-64-bit.gz
RUN gunzip elm.gz
RUN chmod +x elm
RUN mv elm /usr/local/bin
