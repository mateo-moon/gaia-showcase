FROM golang:1.21.0-alpine AS gaiad-builder

ARG GAIA_TAG=v17.3.0

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

RUN apk add --no-cache build-base
RUN adduser -D nonroot
COPY --from=gaiad-builder  /go/bin/gaiad /usr/local/bin/
EXPOSE 26656 26657 1317 9090
USER nonroot

ENTRYPOINT ["gaiad", "start"]
