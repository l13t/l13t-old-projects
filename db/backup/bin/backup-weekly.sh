#!/bin/sh
DST=/data/backup
DATE=$(date  +%Y-%m-%d)
WEEK=$(date  +%U-%Y)

mkdir $DST/mysql/weekly/$WEEK
cp $DST/mysql/$DATE/* $DST/mysql/weekly/$WEEK/

exit 0


