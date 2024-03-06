#!/bin/bash
# Search for all .dat files in all subdirectories and render them with render-tachyon.sh
# if the corresponding png file is older than the dat file.
set -e
set -o pipefail
shopt -s globstar

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P  )"
RENDERSCRIPT="${SCRIPTPATH}"/render-tachyon.sh
# check that renderscript exists and is callable
if [ ! -x "$RENDERSCRIPT" ]; then
   echo "Render script not found or not executable: $RENDERSCRIPT"
   exit 1
fi

# find all .dat files in all subdirectories
dat_files=($(find . -name "*.dat"))
# iterate over all dat files
for file in "${dat_files[@]}"; do 
   basefile=$(basename "$file" .dat)
   path=$(dirname "$file")
   # check if corresponding png exists
   if [ -f "${path}"/"${basefile}".png ]; then
      # check if string Begin_Scene is in not dat file
      # then it's most likely not a tachyon file
      if ! grep -q "Begin_Scene" "$file"; then
         # string not found, skip
         continue
      fi
      # check if png is newer than dat
      if [ "${path}"/"${basefile}".png -nt "$file" ]; then
         # png is newer, skip
         continue
      else
         echo "Found $file with outdated png, updating..."
         "$RENDERSCRIPT" "$file"
      fi
   fi
done

