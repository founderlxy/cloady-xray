# xray on Cloady (VLESS + WebSocket + TLS)

Multi-stage Dockerfile: the xray binary is copied out of the official
`ghcr.io/xtls/xray-core` image (distroless, no shell) into Alpine, where
`entrypoint.sh` generates the config at container start.

## Required environment variables (set in the Cloady dashboard)

- `UUID` — the VLESS client UUID (generate a fresh one, never commit it here)
- `WS_PATH` — WebSocket path, e.g. `/tk-rail`

## Port

The container listens on `$PORT` when Cloady sets it, otherwise on 3000.
Cloady terminates TLS on 443 at the edge and proxies plain WebSocket
traffic to the container, so xray itself serves plain WS.

## Files

- `Dockerfile` — multi-stage build, Alpine + xray binary
- `entrypoint.sh` — writes `/tmp/config.json` from the env vars and runs xray
