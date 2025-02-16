# Setting up gost and mitmweb for Proxy Inspection

This guide explains how to set up a local proxy chain using gost and mitmweb to inspect HTTP/HTTPS traffic.

## Prerequisites

- gost
- mitmweb (part of mitmproxy)
- Android device/emulator

## 1. Setting up gost HTTP Proxy

First, try setting up gost as a SOCKS5 proxy (if your remote proxy is SOCKS5):

```bash
# Start gost with SOCKS5 listener forwarding to remote SOCKS5 proxy
gost -L "socks5://:1080" -F "socks5://admin:admin@139.84.131.32:43449"
```

If that doesn't work, switch to HTTP proxy mode:

```bash
# Start gost with HTTP listener forwarding to remote proxy
gost -L "http://:1080" -F "http://alice:cool@139.84.131.32:42235"
```
http://alice:cool@192.168.29.190:35907
This creates a local proxy on port 1080 that:
- Listens on all interfaces
- Forwards traffic to your remote proxy
- Handles authentication to the remote proxy

## 2. Setting up mitmweb

Start mitmweb in upstream mode to use gost as its upstream proxy:

```bash
mitmweb --mode upstream:http://localhost:1080 --listen-port 8082
```

In the mitmweb interface (http://127.0.0.1:8081):
1. Click the settings gear icon
2. Go to "Explicit HTTP(S) Proxy"
3. Enter `http://localhost:1080` in the "Run HTTP/S Proxy and forward requests to" field

This configuration:
- Creates a proxy on port 8082
- Forwards all traffic to gost (localhost:1080)
- Provides a web interface at http://127.0.0.1:8081

## 3. Configuring Android Device

Set up your Android device to use the mitmweb proxy:

```bash
# For Android emulator (10.0.2.2 points to host's localhost)
adb shell settings put global http_proxy 10.0.2.2:8082
adb shell settings put global https_proxy 10.0.2.2:8082
```

## The Proxy Chain

The setup creates this chain:
```
Device -> mitmweb (8082) -> gost (1080) -> Remote Proxy -> Internet
```

## Certificate Setup

For HTTPS inspection:
1. Visit http://mitm.it through the proxy
2. Download and install the mitmproxy certificate
3. Trust the certificate in your device settings

## Testing the Setup

1. Visit http://ifconfig.me to verify your IP address
2. Check mitmweb's web interface (http://127.0.0.1:8081) for traffic inspection
3. Both HTTP and HTTPS traffic should be visible in the mitmweb interface

## Notes

- HTTPS traffic is handled via HTTP CONNECT tunneling
- The setup maintains end-to-end encryption for HTTPS
- mitmweb can inspect traffic if its certificate is trusted
- gost handles authentication to the remote proxy transparently 