# https://github.com/lachie83/k8s-kubectl/blob/master/Dockerfile
FROM alpine AS kubectl-builder
ARG KUBE_RELEASE="v1.15.3"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_RELEASE}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

# https://github.com/mikesir87/aws-cli-docker/blob/master/Dockerfile
FROM python:alpine
ARG CLI_VERSION=1.16.225

RUN apk -uv add --no-cache groff jq less ca-certificates curl bash && \
    pip install --no-cache-dir awscli==$CLI_VERSION

COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl

WORKDIR /
CMD ["bash"]
