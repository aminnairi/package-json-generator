FROM archlinux:base-devel-20220417.0.53367

ARG DOCKER_USER_IDENTIFIER
ARG NODE_VERSION
ARG NODE_DISTRIBUTION
ARG ELM_VERSION
ARG ELM_DISTRIBUTION

WORKDIR /root

ENV PATH="/usr/local/lib/nodejs/node-$NODE_VERSION-$NODE_DISTRIBUTION/bin:${PATH}"

RUN useradd --home-dir /home/user --create-home --system --shell /bin/bash --uid "${DOCKER_USER_IDENTIFIER}" user \
  && mkdir -p /usr/local/lib/nodejs \
  && curl -L -o elm.gz "https://github.com/elm/compiler/releases/download/0.19.1/binary-for-$ELM_DISTRIBUTION.gz" \
  && gunzip elm.gz \
  && chmod +x elm \
  && mv elm /usr/local/bin/ \
  && curl -o "node-${NODE_VERSION}-${NODE_DISTRIBUTION}.tar.xz" "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-${NODE_DISTRIBUTION}.tar.xz" \
  && tar -xJvf "node-$NODE_VERSION-$NODE_DISTRIBUTION.tar.xz" -C /usr/local/lib/nodejs \
  && npm install --global uglify-js
