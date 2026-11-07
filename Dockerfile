# Multi-stage build: copy the xray binary out of the official
# distroless image (which has no shell) into Alpine (which does),
# so the entrypoint script can generate the config at runtime.
FROM ghcr.io/xtls/xray-core:latest AS xray

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=xray /usr/local/bin/xray /usr/local/bin/xray
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
