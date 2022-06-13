#!/bin/bash
#PBS -e /dev/null
#PBS -o /dev/null
#SBATCH --account=PZS1127
set -euo pipefail
IFS=$'\n\t'

function frames_range() {
  (
    set +u  # allow using environment variables
    echo "$FRAMES_RANGE" | perl -pe 's[.+/][]'
  )
}

# Use LMod to load Blender into our PATH
module load blender
(
  # Change directory to where our .blend file is
  cd "$OUTPUT_DIR"

  env | grep -P '^[A-Z]' | sort

  # Call blender on our blend
  #   -b which blend to work on
  #   -F sets the file format
  #   -o sets the output directory; defaults to /tmp
  #   -x allows blender to set the file extension
  #   -t 0 allows blender to use as many threads as there are processors
  #   -a render all scenes in the blend
  blender \
    -b "$BLEND_FILE_PATH" \
    -F PNG \
    -o "$OUTPUT_DIR/render_" \
    -x 1 \
    -t 0 \
    -E CYCLES \
    -f "$(frames_range)" # renders frames 1-10, -f 1,3,5 renders frames 1, 3 and 5...
)