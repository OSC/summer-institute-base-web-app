#!/bin/bash

module load ffmpeg/4.0.2
ffmpeg -r "$FRAMES_PER_SEC" -y -i "$OUTPUT_DIR/render_%04d.png" -vsync vfr -b:v 16M -pix_fmt yuv420p "$OUTPUT_DIR/video.mp4"