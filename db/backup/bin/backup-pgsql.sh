#!/bin/sh

DUMPAGE=7
DUMPDIR=/data/backup/pgsql
CURDUMP="alldump-"`date +"%d%m%Y"`".dump"
DROPDUMP="alldump-"`date -d "4 days ago" +"%d%m%Y"`".dump.bz2"

/usr/bin/logger -t PGDUMPALL: $CURDUMP to create...
su -l postgres -c "/usr/bin/pg_dumpall -g -S postgres -U postgres > $DUMPDIR/globalobjects.dump"
su -l postgres -c "/usr/bin/pg_dumpall -c -f $DUMPDIR/$CURDUMP -o -S postgres -U postgres && \
/bin/bzip2 $DUMPDIR/$CURDUMP && \
/bin/rm $DUMPDIR/$DROPDUMP && \
/usr/bin/logger -4 -t PGDUMPALL: $CURDUMP ok... $DROPDUMP deleted..."
