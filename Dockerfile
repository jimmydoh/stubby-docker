FROM alpine:3.21

RUN apk update
RUN apk add --no-cache musl=1.2.5-r8 yaml=0.2.5-r2 drill=1.8.4-r0
RUN apk add --no-cache getdns-libs=1.7.3-r0 stubby=0.4.3-r1 --repository=http://dl-cdn.alpinelinux.org/alpine/v3.21/community/
RUN apk upgrade

# copy default stubby config
COPY stubby.yml /etc/stubby/

HEALTHCHECK --interval=30s --timeout=30s --start-period=10s CMD drill @127.0.0.1 -p 53 cloudflare.com || exit 1

EXPOSE 53/UDP

ENTRYPOINT ["/usr/bin/stubby"]