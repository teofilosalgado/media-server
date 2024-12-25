#!/bin/bash
readonly JELLYFIN_SERVER_PATH="/opt/jellyfin"
readonly JELLYFIN_FFMPEG_PATH="/usr/share/jellyfin-ffmpeg"

$JELLYFIN_SERVER_PATH/jellyfin \
 --datadir   $JELLYFIN_SERVER_PATH/data \
 --cachedir  $JELLYFIN_SERVER_PATH/cache \
 --configdir $JELLYFIN_SERVER_PATH/config \
 --logdir    $JELLYFIN_SERVER_PATH/log \
 --ffmpeg    $JELLYFIN_FFMPEG_PATH/ffmpeg