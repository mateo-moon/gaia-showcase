FROM golang:1.21.0-alpine AS gaiad-builder

ARG GAIA_TAG=v17.2.0

# Update apk and install required packages
RUN apk update && apk add --no-cache \
    curl \
    git \
    make \
    libc-dev \
    bash \
    gcc \
    linux-headers \
    eudev-dev \
    python3

#Clone the gaia repo
RUN git clone --branch ${GAIA_TAG} --depth 1 https://github.com/cosmos/gaia.git /src/app/gaia

#Build
WORKDIR /src/app/gaia
RUN go mod download
RUN CGO_ENABLED=0 make install

#This is the part of official gaia Dockerfile https://github.com/cosmos/gaia/blob/main/Dockerfile
FROM alpine:3.19.2

ENV MONIKER=dazzling_shtern \
    CHAIN_ID=cosmoshub-4 \
    GENESIS_URL=https://raw.githubusercontent.com/cosmos/launch/master/genesis.json

RUN apk update && apk add --no-cache \
    build-base \
    curl \
    jq \
    lz4 \
    aria2
    
RUN adduser -D nonroot
COPY --from=gaiad-builder  /go/bin/gaiad /usr/local/bin/
COPY entrypoint.sh /usr/local/bin/
COPY init_pruned.sh /usr/local/bin/
RUN chmod +x \ 
    /usr/local/bin/entrypoint.sh \
    /usr/local/bin/init_pruned.sh
USER nonroot

EXPOSE 26656
WORKDIR /home/nonroot

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
