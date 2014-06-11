#!/bin/sh

dbage=336
prefix=/data/backup
dblist=$prefix/bin/postgresql.databases

for db in `cat $dblist`
do
		FFILE=`/bin/date +"${prefix}/pgsql/incremental/${db}.%d%m%Y.%H-%M.dump"`
		su -l postgres -c "/usr/bin/pg_dump -F c -o -U postgres -f $FFILE  $db && [ -e $FFILE ] && /bin/bzip2 $FFILE"
		/usr/bin/find $prefix/pgsql/incremental/ -mtime +15 -name "${db}*" -delete
done
