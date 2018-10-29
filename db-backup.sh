#!/bin/bash

# This script backs up the specified mysql database to the local machine and then syncs with s3

# Load in the specified config
CONFIG=$1
. $CONFIG

# mysqldump
suffix=`date +%Y%m%d-%H`
cmd='/usr/bin/mysqldump'

# Get a list of databases
databases=(`echo 'show databases;' | mysql -h ${DB_HOST} -u ${DB_USER} --password=${DB_PASSWORD} | grep -v ^Database$`)

# Loop through each database and back it up
for d in "${databases[@]}"; do
    # If the database isn't test or tmp
    if [[ $d != 'tmp' && $d != 'test' ]]
    then
        echo "DATABASE ${d}"

        # Get the list of tables
        s="use ${d}; show tables;"
        tables=(`echo ${s} | mysql -h ${dbh} -u ${dbu} --password=${dbp} | grep -v '^Tables_in_'`)

        # Loop through the tables and get the sql dump
        for t in "${tables[@]}"; do
          echo " TABLE ${t}"

          path="${dest}/${suffix}/${d}"
          mkdir -p ${path}

          # Do the mysql dump and bzip it
          ${cmd} -h ${dbh} --user=${dbu} --password=${dbp} --quick --add-drop-table --create-options ${d} ${t} | bzip2 -c > ${path}/${t}.sql.bz2

        done
    fi
done


# push the backup dir
/usr/local/bin/aws s3 sync ${dest} s3://${s3bucket}/db/


# Clean up backups off the server after lifespan 
find ${dest} -mtime +${lifespan} -exec rm -rf {} \;
find ${dest} -type d -empty -exec rmdir {} \;
