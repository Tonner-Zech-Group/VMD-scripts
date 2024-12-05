#!/bin/bash
# Use VMD to create images of cube files named <name>*.cub
# Have a name.vmd file of the same name ready.
# It must contain the cube file to be loaded with the name name.cub
# Usage: cubes2png.sh name
set -e

VMD="${1}.vmd"

if [[ ! -f "${VMD}" ]]; then
   echo "Expecting to find file ${VMD}, but could not find it!"
   exit 1
fi

# Get the number of files to process defined by name*.cub
files=("${1}"*.cub)
echo "Found ${#files[@]} files"


if tail -1 "${NAME}.vmd" | grep -iq "quit"
then
   echo "${NAME}.vmd already appended, error!"
   exit 1
fi

#iterate over files
for file in "${files[@]}"; do
   echo "Processing $file"
   # Get the number of frames in the cube file
   NAME="${file%.cub}"
   # Create a vmd file to render the image
   if [[ -f "${NAME}.vmd" ]]; then
      echo "${NAME}.vmd already exists, error!"
      exit 1
   else
      cp "${VMD}" "${NAME}.vmd"
      # sed replace every instance of *.cub with the current file
      sed -i "s/${1}.cub/${file}/" "${NAME}.vmd"
      {
         echo "render options Tachyon '/usr/local/vmd/lib/vmd/tachyon_LINUXAMD64 -aasamples 12 %s -format TARGA'"
         echo "render Tachyon ${NAME}.dat"
         echo "quit"
      } >> "${NAME}.vmd"
   fi
done


#iterate over files
for file in "${files[@]}"; do
   NAME="${file%.cub}"
   echo "Now plotting, give me time"
   vmd -dispdev text -e "${NAME}.vmd"
   echo "Rendering $NAME"
   sed -i 's/Resolution.*/Resolution 7664 4164/' "$NAME".dat
   tachyon  -aasamples 12 "$NAME".dat -format TARGA -o "$NAME".tga
   convert "$NAME".tga "$NAME".png
   rm "$NAME".tga
done

