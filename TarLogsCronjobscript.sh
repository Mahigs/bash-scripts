#!/bin/bash

# TarLogsCronjob Script
# Created by: Matthew Mahigian
# Date: 08/12/2020
# This script will be run as a cronjob on the first of the month to collect the previous month's logs and send them to /data/seclogs/audits
# This script will be compatible with Linux and Unix distros
# Please run this cronjob either in the root crontab
# This script should be run at the beginning of the month early in morning




# Let's start with seeing if the box is a Solaris system. If so, it will zip and archive logs the Solaris way


[ if -f /etc/release ];
then
    cd /var/audit
    if [ $(date | awk '{print $2}') == January ] || [ $(date | awk '{print $2}') == March ] || [ $(date | awk '{print $2}') == May ] || [ $(date | awk '{print $2}') == July ] || [ $(date | awk '{print $2}') == August ] || [ $(date | awk '{print $2}') == October ] || [ $(date | awk '{print $2}') == December ];
    then
        tar cvf $(hostname)"_"$(date | awk '{print $2$4}')"archivedlogs.tar.gz" $(find . -mtime +31)
        mv $(hostname)"_"$(date | awk '{print $2$4}')"archivedlogs.tar.gz" /data/seclogs/audits/
    elif [ $(date | awk '{print $2}') == April ] || [ $(date | awk '{print $2}') == June ] || [ $(date | awk '{print $2}') == September ] || [ $(date | awk '{print $2}') == November ];
    then
        tar cvf $(hostname)"_"$(date | awk '{print $2$4}')"archivedlogs.tar.gz" $(find . -mtime +30)
        mv $(hostname)"_"$(date | awk '{print $2$4}')"archivedlogs.tar.gz" /data/seclogs/audits
    elif [ $(date | awk '{print $2}') == February ];
        tar cvf $(hostname)"_"$(date | awk '{print $2$4}')"archivedlogs.tar.gz" $(find . -mtime +28)
        mv $(hostname)"_"$(date | awk '{print $2$4}')"archivedlogs.tar.gz" /data/seclogs/audits
    else
        exit 1
    fi


# If it wasn't Solaris, let's zip and archive for all the other Linux distros


else
    cd /var/log/audit
    if [ $(date | awk '{print $2}') == Jan ] || [ $(date | awk '{print $2}') == Mar ] || [ $(date | awk '{print $2}') == May ] || [ $(date | awk '{print $2}') == Jul ] || [ $(date | awk '{print $2}') == Aug ] || [ $(date | awk '{print $2}') == Oct ] || [ $(date | awk '{print $2}') == Dec ];
    then
        tar -cvzf $(hostname)"_"$(date | awk '{print $2$6}')"archivedlogs.tar.gz" $(find . -mtime +31)
        mv $(hostname)"_"$(date | awk '{print $2$6}')"archivedlogs.tar.gz" /data/seclogs/audits/
    elif [ $(date | awk '{print $2}') == Apr ] || [ $(date | awk '{print $2}') == Jun ] || [ $(date | awk '{print $2}') == Sep ] || [ $(date | awk '{print $2}') == Nov ];
    then
        tar -cvzf $(hostname)"_"$(date | awk '{print $2$6}')"archivedlogs.tar.gz" $(find . -mtime +30)
        mv $(hostname)"_"$(date | awk '{print $2$6}')"archivedlogs.tar.gz" /data/seclogs/audits/
    elif [ $(date | awk '{print $2}') == Feb ];
        tar -cvzf $(hostname)"_"$(date | awk '{print $2$6}')"archivedlogs.tar.gz" $(find . -mtime +28)
        mv $(hostname)"_"$(date | awk '{print $2$6}')"archivedlogs.tar.gz" /data/seclogs/audits/
    else
        exit 1
    fi
fi

