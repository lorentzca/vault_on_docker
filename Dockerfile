FROM alpine

RUN apk --update add --virtual build-dependencies \
  curl \
  wget \
  unzip

RUN \
  cd /usr/local/bin && \
  wget https://releases.hashicorp.com/vault/0.4.1/vault_0.4.1_linux_amd64.zip && \
  unzip vault_0.4.1_linux_amd64.zip && \
  rm vault_0.4.1_linux_amd64.zip && \
  mkdir /etc/vault.d && \
  mkdir /var/vault

COPY ./config.hcl /etc/vault.d/config.hcl

ENTRYPOINT ["/usr/local/bin/vault", "server", "-config=/etc/vault.d/config.hcl"]
