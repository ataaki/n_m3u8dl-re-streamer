#Builder Image
FROM debian:bookworm-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ffmpeg \
    python3 \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Get N_m3u8DL-RE
RUN N_URL=$(curl -s https://api.github.com/repos/nilaoda/N_m3u8DL-RE/releases/latest \
      | grep browser_download_url \
      | grep linux-x64 \
      | cut -d '"' -f 4) \
 && curl -L "$N_URL" -o n.tar.gz \
 && tar -xzf n.tar.gz \
 && rm n.tar.gz \
 && chmod +x N_m3u8DL-RE

# Get Shaka Packager
RUN S_URL=$(curl -s https://api.github.com/repos/shaka-project/shaka-packager/releases/latest \
      | grep browser_download_url \
      | grep linux \
      | grep packager-linux-x64 \
      | cut -d '"' -f 4) \
 && curl -L "$S_URL" -o shaka-packager \
 && chmod +x shaka-packager

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Final Image
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /usr/share/doc/* \
 && rm -rf /usr/share/man/* \
 && rm -rf /usr/share/locale/* \
 && rm -rf /var/cache/* \
 && find / -name "*.pyc" -delete || true

WORKDIR /app

COPY --from=builder /app/N_m3u8DL-RE /app/N_m3u8DL-RE
COPY --from=builder /app/shaka-packager /app/shaka-packager
COPY --from=builder /app/entrypoint.sh /app/entrypoint.sh

ENV OUTPUT_FILE="output.m3u8"
ENV N_M3U8DL_RE_PARAMS=""
ENV RE_LIVE_PIPE_OPTIONS="-c copy"
ENV N_M3U8DL_RE_LIVE_WAIT_TIME=5
ENV N_M3U8DL_RE_LIVE_TAKE_COUNT=5
ENV FFMPEG_HLS_TIME=2
ENV FFMPEG_HLS_LIST_SIZE=3


ENTRYPOINT ["/app/entrypoint.sh"]
