#!/bin/bash
# render all .vmd files given as arguments with tachyon optix renderer
# after rendering, convert to png and trim
# usage: render-tachyonGPU.sh *.dat
set -e
set -o pipefail
shopt -s globstar

args=("$@")

n=0

for ((n=0; n<$#; ++n));
do
   file=${args[$n]}
   if [ ! -f "$file" ]; then
      continue
   fi

   if [ -f "tmp.vmd" ]; then
      echo "tmp.vmd exists, exiting"
      exit 1
   fi

   echo "$file"
   basefile=$(basename $file .vmd)
   path=$(dirname $file)
   cat "${file}" > tmp.vmd
   echo "render TachyonLOptiXInternal ${basefile}.ppm" >> tmp.vmd
   echo "quit" >> tmp.vmd
   vmd -dispdev text -e tmp.vmd -size 7664 4164 
   #4096 2160
   rm tmp.vmd
   convert -trim "${basefile}".ppm "${path}"/"${basefile}".png
   rm "${basefile}".ppm
done
