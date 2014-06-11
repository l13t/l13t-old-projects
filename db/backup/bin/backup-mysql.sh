#!/bin/sh
DST=/data/backup/mysql
IGNREG='^test$'
#DBDIR=/data/db/mysql
DBUSER=root
DBPASS='<password>'
KEEPDAYS=7

DATE=$(/bin/date  +%Y-%m-%d)

#cd  $DBDIR

/usr/bin/find ${DST} -type f -mtime +${KEEPDAYS} -exec rm -f {} \;
/bin/rmdir $DST/* 2>/dev/null

/bin/mkdir -p ${DST}/${DATE}
/bin/rm ${DST}/today
/bin/ln -s ${DST}/${DATE} ${DST}/today
for db in $(echo 'show databases;' | /usr/bin/mysql -s -u ${DBUSER} -p${DBPASS} | /bin/egrep -v ${IGNREG}) ; do
echo -n "Backing up ${db}... "
/usr/bin/mysqldump --opt -u ${DBUSER} -p${DBPASS} $db | /bin/gzip -c > ${DST}/${DATE}/${db}.txt.gz
echo "Done."
done

exit 0


