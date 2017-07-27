#!/usr/bin/env bash

TBNLDIR=./static/images/tbnl

rm -rf $TBNLDIR
if [ ! -d $TBNLDIR ]; then
	mkdir -p $TBNLDIR
fi

for img in ./static/images/*.*
do
	filename=${img##*/}
	filename=${filename%.*}

	convert $img -resize 130x130 $TBNLDIR/${filename}.jpg
done
