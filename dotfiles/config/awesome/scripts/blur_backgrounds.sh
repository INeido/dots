#!/bin/bash

pictures_folder="../wallpapers"
blurred_folder="$pictures_folder/blurred"
mkdir -p "${blurred_folder}"

read -p "Enter the screen resolution (e.g. 1920x1080): " res

for file in "$pictures_folder"/*; do

  if [[ $file != *.png ]]; then
    convert "$file" "${file%.*}.png"
    rm "$file"
    file="${file%.*}.png"
  fi

  filename=$(basename "$file" .png)

  if [[ ! -f "$blurredfile" ]]; then
      convert "$file" -resize "$res^" -gravity center -extent "$res" -blur 0x8 "${blurred_folder}""/${filename}.png"
  fi

done