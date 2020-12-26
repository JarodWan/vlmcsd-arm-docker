FROM alpine:latest as builder
WORKDIR /root
RUN apk add --no-cache git make build-base && \
    git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git && \
    cd vlmcsd && \
    make

FROM alpine:latest
# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="jarodwan"

COPY --from=builder /root/vlmcsd/bin/vlmcsd /vlmcsd
RUN apk add --no-cache tzdata

# expose port use for KMS
EXPOSE 1688/tcp

CMD ["/vlmcsd", "-D", "-d", "-t", "3", "-e", "-v"]
