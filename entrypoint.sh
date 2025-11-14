#!/bin/sh
set -e

# Create output directory
mkdir -p /app/live

# Starting HTTP server
python3 -m http.server 8080 -d /app/live &> /dev/null &

echo "[INFO] Starting streaming..."
echo "RE_LIVE_PIPE_OPTIONS=\"$RE_LIVE_PIPE_OPTIONS /app/live/$STREAM_FILE\" ./N_m3u8DL-RE $N_M3U8DL_RE_PARAMS"

# Append output file to RE_LIVE_PIPE_OPTIONS
eval RE_LIVE_PIPE_OPTIONS=\"$RE_LIVE_PIPE_OPTIONS /app/live/$STREAM_FILE\" ./N_m3u8DL-RE $N_M3U8DL_RE_PARAMS
