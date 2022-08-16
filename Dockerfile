# https://github.com/lachie83/k8s-kubectl/blob/master/Dockerfile
FROM alpine:3.16.2 AS kubectl-builder
ARG KUBE_RELEASE="v1.22.2"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_RELEASE}/bin/linux/$(uname -m)/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

# https://github.com/mikesir87/aws-cli-docker/blob/master/Dockerfile
FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y unzip groff jq less ca-certificates curl bash && \
    rm -rf /var/lib/apt/lists/*
RUN case "$(uname -m)" in \
        x86_64) curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip ;; \
        aarch64) curl https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip -o awscliv2.zip ;; \
        *) echo "Unknown architecture: $(uname -m)" && exit 255 ;; \
    esac;
RUN unzip awscliv2.zip && ./aws/install

COPY --from=kubectl-builder /usr/local/bin/kubectl /usr/local/bin/kubectl

WORKDIR /
CMD ["bash"]
