FROM alpine

ARG version="0.6.4"

RUN apk --update add --virtual build-dependencies \
  curl \
  wget \
  unzip

RUN \
  cd /usr/local/bin && \
  wget https://releases.hashicorp.com/vault/${version}/vault_${version}_linux_amd64.zip && \
  unzip vault_${version}_linux_amd64.zip && \
  rm vault_${version}_linux_amd64.zip && \
  mkdir /etc/vault.d && \
  mkdir /var/vault

COPY ./config.hcl /etc/vault.d/config.hcl

ENTRYPOINT ["/usr/local/bin/vault", "server", "-config=/etc/vault.d/config.hcl"]
