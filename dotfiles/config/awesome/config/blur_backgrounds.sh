#!/bin/bash

pictures_folder="../wallpapers"
read -p "Enter the screen resolution (e.g. 1920x1080): " res

for file in "$pictures_folder"/*; do

  if [[ $file == *_blurred.* ]]; then
    continue
  fi

  if [[ $file != *.png ]]; then
    convert "$file" "${file%.*}.png" && rm "$file"
    file="${file%.*}.png"
  fi

  filename=$(basename "$file")
  extension="${filename##*.}"
  filename="${filename%.*}"

  blurredfile="${file%.*}_blurred.${file##*.}"
  if [[ ! -f "$blurredfile" ]]; then
      convert "$file" -resize "$res^" -gravity center -extent "$res" -blur 0x8 "$blurredfile"
  fi

done