#!/bin/sh
set -e

# Create output directory
mkdir -p /app/live

# Starting HTTP server
python3 -m http.server 8080 -d /app/live &> /dev/null &

echo "[INFO] Starting streaming..."
echo "RE_LIVE_PIPE_OPTIONS=\"$RE_LIVE_PIPE_OPTIONS -f hls -hls_time $FFMPEG_HLS_TIME -hls_list_size $FFMPEG_HLS_LIST_SIZE -hls_flags delete_segments /app/live/$STREAM_FILE\" ./N_m3u8DL-RE $N_M3U8DL_RE_PARAMS  --live-real-time-merge --live-pipe-mux --live-keep-segments false  --live-wait-time $N_M3U8DL_RE_LIVE_WAIT_TIME --live-take-count $N_M3U8DL_RE_LIVE_TAKE_COUNT"

# Append output file to RE_LIVE_PIPE_OPTIONS
eval RE_LIVE_PIPE_OPTIONS=\"$RE_LIVE_PIPE_OPTIONS -f hls -hls_time $FFMPEG_HLS_TIME -hls_list_size $FFMPEG_HLS_LIST_SIZE -hls_flags delete_segments /app/live/$STREAM_FILE\" ./N_m3u8DL-RE $N_M3U8DL_RE_PARAMS  --live-real-time-merge --live-pipe-mux --live-keep-segments false  --live-wait-time $N_M3U8DL_RE_LIVE_WAIT_TIME --live-take-count $N_M3U8DL_RE_LIVE_TAKE_COUNT
