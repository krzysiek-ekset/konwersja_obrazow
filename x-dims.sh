#!/bin/bash

directory="$PWD"
extensions=$(find "$directory" -type f -exec sh -c 'echo "${0##*.}"' {} \; | grep -v 'sh' | sort -u)

files=""
for ext in $extensions; do
    files+="*.$ext "
done


# echo "Lista rozszerzeń: $files"

for i in $files;
    do
    no=$((no+1))
    img_h=$(identify -format '%h' $i)
    img_w=$(identify -format '%w' $i)
    max_w=2560
    max_h=2560

    if [ $img_h -gt $img_w ]
    then
        if [ $img_h -gt 2560 ]
        then
        convert $i -background none -gravity center -extent "${max_w}x${max_h}" webp/$i.webp
        echo $no ': Obrazek pionowy duży:        ' $i
        else
        convert $i -background none -gravity center -extent "${img_h}x${img_h}" webp/$i.webp
        echo $no ': Obrazek pionowy mały:        ' $i
        fi

    fi

    if [ $img_h -lt $img_w ]
    then
    if [ "$img_w" -gt "${max_w}" ]
        then
        convert $i -background none -gravity center -extent "${max_w}x${max_h}" webp/$i.webp
        echo $no ': Obrazek poziomy duży:        ' $i
        else
        convert $i -background none -gravity center -extent "${img_w}x${img_w}" webp/$i.webp
        echo $no ': Obrazek poziomy mały:        ' $i
        fi
    fi

    if [ $img_h -eq $img_w ]
    then
        if [ "$img_w" -gt "${max_w}" ]
        then
        convert $i -resize "${max_w}x${max_h}" webp/$i.webp
        echo $no ': Obrazek kwadratowy duży:     ' $i
        fi

        if [ "$img_w" -lt "${max_w}" ]
        then
        convert $i webp/$i.webp
        echo $no ': Obrazek kwadratowy mały:     ' $i
        fi
    fi  

    done

cd webp/
rename 's/\.jpg(\.webp)$/$1/' *.webp
rename 's/\.png(\.webp)$/$1/' *.webp
rename 's/\.JPG(\.webp)$/$1/' *.webp
rename 's/\.jpeg(\.webp)$/$1/' *.webp


read -p "Podaj prefix pliku: " prefix
rename "s/^/$prefix-/" *.webp
