#!/bin/sh

pg_dump timeseries --username=openadms-server | gzip > /mnt/backups/`date +"%Y%m%d%H%M%S"`_timeseries.sql.gz
