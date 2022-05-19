FROM archlinux:base-devel-20220417.0.53367

ARG DOCKER_USER_IDENTIFIER
ARG DOCKER_NODE_VERSION
ARG DOCKER_NODE_DISTRIBUTION
ARG DOCKER_ELM_VERSION
ARG DOCKER_ELM_DISTRIBUTION

WORKDIR /root

ENV PATH="/usr/local/lib/nodejs/node-${DOCKER_NODE_VERSION}-${DOCKER_NODE_DISTRIBUTION}/bin:${PATH}"

RUN useradd --home-dir /home/user --create-home --system --shell /bin/bash --uid "${DOCKER_USER_IDENTIFIER}" user \
  && mkdir -p /usr/local/lib/nodejs \
  && curl -L -o elm.gz "https://github.com/elm/compiler/releases/download/0.19.1/binary-for-${DOCKER_ELM_DISTRIBUTION}.gz" \
  && gunzip elm.gz \
  && chmod +x elm \
  && mv elm /usr/local/bin/ \
  && curl -o "node-${DOCKER_NODE_VERSION}-${DOCKER_NODE_DISTRIBUTION}.tar.xz" "https://nodejs.org/dist/${DOCKER_NODE_VERSION}/node-${DOCKER_NODE_VERSION}-${DOCKER_NODE_DISTRIBUTION}.tar.xz" \
  && tar -xJvf "node-${DOCKER_NODE_VERSION}-${DOCKER_NODE_DISTRIBUTION}.tar.xz" -C /usr/local/lib/nodejs \
  && elm --version \
  && node --version \
  && npm --version \
  && npx --version
