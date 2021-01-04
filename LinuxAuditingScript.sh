#!/bin/bash

#Linux Auditing Script
#Version 1.0

#Created by: Matthew Mahigian on 01/08/2020

#The purpose and requirements of this script is to review necesary information within a Linux system and copy the log to /data/seclogs/audits for archiving (or whatever destination you prefer)

#The purpose of this script is to help anybody audit a RHEL system that is unable to have any sort of automation tools investigate it

#Script improvements needed:


clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Welcome to the Linux Auditing Script \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
echo "The following script is intended to be used for reviewing a linux system and checking for various types of key auditing points that you should be looking over"
echo ""
echo "This script should be run with Super-User privileges (using sudo or as root) and will work best if this system:"
echo ""
echo -e "\e[1;40m \e[1;32m Has McAfee Virus-Scan software installed \e[0m"
echo -e "\e[1;40m \e[1;32m Has IGNORE set for the max_file_log_action parameter under /etc/audit/auditd.conf \e[0m"
echo -e "\e[1;40m \e[1;32m Is generating weekly zipped log files in /var/log/audit that are named like: /var/log/audit/audit.log-20200601.gz \e[0m"
echo ""
echo "If you are unsure about any of the following, please contact your SA to confirm that your system/environment is set up this way"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to begin audit review \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m System Information \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo -n "Date: "; /bin/date
echo -n "Host Name: "; /bin/uname -n
/usr/sbin/dmidecode | grep -e 'Manufacturer' -e 'Product Name' -e 'Serial Number' | head -n 3
echo "Network Info: "; ip addr
echo ""
echo "This will show you the localhost IP Address + any other configured IP Addresses on the NIC(s)"
echo ""
if [ -a /etc/redhat-release ];
then
    echo -e "\e[1;40m \e[1;32m Operating System Version:\e[0m"
    cat /etc/redhat-release
elif [ -a /etc/centos-release];
then    
    echo -e "\e[1;40m \e[1;32m Operating System Version:\e[0m"
    cat /etc/centos-release
elif [ -a /etc/suse-release];
then   
    echo -e "\e[1;40m \e[1;32m Operating System Version:\e[0m"
    cat /etc/suse-release
elif [ -a /etc/debian_version ];
then
    echo -e "\e[1;40m \e[1;32m Operating System Version:\e[0m"
    cat /etc/debian_version
else
    echo -e "\e[1;41m \e[1;37m This script is currently unable to output the OS version \[0m"
fi
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Is auditd running? \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
echo -e "\e[1;45m \e[1;37m If auditd is running, then your system is auditing! \e[0m"
echo ""
/sbin/service auditd status
echo ""
echo "If it is not running, please contact your SA"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Which set of logs to review \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
echo -e "\e[1;40m \e[1;32m If you don't see dated and compressed audit files, please contact your SA \e[0m"
echo ""
ls -ltr /var/log/audit/ | tail -5
echo ""
echo -n "Enter the desired date of the log file that you'd like to review (i.e. 20200117):"; read my_date
#The user will be prompted to enter in their desired log file for analysis 
gunzip -c /var/log/audit/audit.log-$my_date.gz > /var/log/audit/auditfile
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Summary Report \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
/sbin/aureport --summary -if /var/log/audit/auditfile
echo ""
echo -e "\e[1;45m \e[1;37m This summary report shows a count total for each category listed. \e[0m"
echo -e "\e[1;45m \e[1;37m Focus on areas of interest based on excessive count totals or severity. \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Account Modifications \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
/sbin/aureport -m -i -if /var/log/audit/auditfile
echo ""
echo -e "\e[1;45m \e[1;37m This shows you any sort of account modifications that have happened during the week \e[0m"
echo -e "\e[1;45m \e[1;37m The [auid] from [term] performed [exe] to [acct] \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Authentication Attempts \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
/sbin/aureport -au -i -if /var/log/audit/auditfile
echo ""
echo -e "\e[1;45m \e[1;37m This report shows authentication attempts \e[0m"
echo -e "\e[1;45m \e[1;37m Authentications match usernames to passwords \e[0m"
echo -e "\e[1;45m \e[1;37m The [acct] from [term] performed [exe] \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Login Attempts \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
/sbin/aureport -l -i -if /var/log/audit/auditfile
echo ""
echo -e "\e[1;45m \e[1;37m This report shows all login attempts \e[0m"
echo -e "\e[1;45m \e[1;37m Logins assign privileges to users (if successful) \e[0m"
echo -e "\e[1;45m \e[1;37m The [auid] from [host] [term] (if known) used [exe] to login \e[0m"
echo -e "\e[1;45m \e[1;37m Compare date/time stamps from authentications file (previous) to logins (above) - the event ids are sequential \e[0m"    
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Who is logged in right now? \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
who
echo ""
echo -e "\e[1;45m \e[1;37m This reports all users on the system right now. \e[0m"
echo -e "\e[1;45m \e[1;37m Expect to see individual authenticators and limited use of root or other privileged accounts. \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "---------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Review report on privilege escalation \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "---------------------------------------------------------------------"
echo ""
#What you're seeing here is the unzipping of the zipped up messages file (synonymous with the date in which your logs are zipped up) and creating a temporary messages file to examine. We will eventually delete it.
gunzip -c /var/log/messages-$my_date.gz > /var/log/messagesfile
grep -i -e '/bin/su -' -i -e sudo /var/log/messagesfile | more
echo ""
echo -e "\e[1;45m \e[1;37m This reports su and sudo activity recorded in the /var/log/messages file. \e[0m"
echo -e "\e[1;45m \e[1;37m If you see sudo: username : TTY=pts/2 ; PWD=/home/username ; USER=root ; COMMAND=/bin/su - \e[0m"
echo -e "\e[1;45m \e[1;37m This means a user became root without knowing the root password and should be reported to your ISSM. \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read

#So right here is where you'll be deleting that temporarily unzipped file that was the result of turning the zipped messages file into a readable form

rm -rf /var/log/messagesfile

clear
echo "---------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Review report on root logon attempts \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "---------------------------------------------------------------------"
echo ""
/sbin/ausearch -if /var/log/audit/auditfile -i -m USER_LOGIN,USER_AUTH | grep -i acct=root
echo ""
echo -e "\e[1;45m \e[1;37m This reports this weeks root logon attempts. \e[0m"          
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Disk/Filesystem Space \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
df -h
echo ""
echo -e "\e[1;45m \e[1;37m The following list shows all mounted filesystems and their disk space usage. \e[0m" 
echo -e "\e[1;45m \e[1;37m Pay attention to the directories (/home, /var/, /var/log/, etc.) and the percentage of allocate space vs total space available  \e[0m"
echo -e "\e[1;45m \e[1;37m If you see any filesystems that show >90% disk space full, contact your SA \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m User Inactivity 90+ days \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo -e "\e[1;45m \e[1;37m Once you hit enter, you will be viewing users with 90+ days of inactivity \e[0m"
read
echo ""
#alter to only include user accounts
lastlog -b 90 | tail -n+2 | grep -v 'Never Log'| awk '{print $1}' | more
echo ""
echo -e "\e[1;45m \e[1;37m The following names are accounts that have not seen any logon activity on this specific system in 90+ days. \e[0m" 
echo -e "\e[1;45m \e[1;37m This list includes system accounts along with user accounts, so please make sure to focus on the user accounts  \e[0m"
echo -e "\e[1;45m \e[1;37m Please disable these user accounts if you have not done so already \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Review report about files \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo -e "\e[1;45m \e[1;37m Once you hit enter, you will be viewing reports about files executed to various system programs \e[0m"
read
echo ""
/sbin/aureport -f -i -if /var/log/audit/auditfile | grep -v 'rtlogic' | grep -v 'uvscan' | grep -v cron | grep -v gnome | grep -v mtab | grep -v 'splunkd' | more
echo "" 
echo -e "\e[1;45m \e[1;37m This reports [syscall] system calls to [exe] various system level programs. \e[0m" 
echo -e "\e[1;45m \e[1;37m Look for program executed using a non-privileged account. \e[0m"
echo -e "\e[1;45m \e[1;37m lines containing rtlogic, uvscan, cron, mtab, splunkd and gnome are omitted from the search. \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "---------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Review /var/log/messages for pam activity \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "---------------------------------------------------------------------"
echo ""

#What you're seeing here is the unzipping of the zipped up messages file (synonymous with the date in which your logs are zipped up) and creating a temporary messages file to examine. We will eventually delete it.

gunzip -c /var/log/messages-$my_date.gz > /var/log/messagesfile
grep -i 'pam' /var/log/messagesfile | more
echo ""
echo -e "\e[1;45m \e[1;37m This reports calls to the Pluggable Authentication Module (pam) activity recorded in the /var/log/messages file. \e[0m"
echo -e "\e[1;45m \e[1;37m If you see passwords in clear text, promptly contact that user to change their password. \e[0m"
echo -e "\e[1;45m \e[1;37m Look for excessive errors or failures that may warrent further inquiry. \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read

#So right here is where you'll be deleting that temporarily unzipped file that was the result of turning the zipped messages file into a readable form

rm -rf /var/log/messagesfile

clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m View /etc/passwd \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
echo -e "\e[1;45m \e[1;37m Once you hit enter, you will be taken to the /etc/passwd file \e[0m"
read
cat /etc/passwd | more
echo ""
echo -e "\e[1;45m \e[1;37m Review the /etc/passwd file and make sure that every account listed belongs on the system \e[0m"     
echo -e "\e[1;45m \e[1;37m Password File Syntax: Username:Password:UserID:GroupID:AccountName/Comment:HomeDirectory:Shell \e[0m" 
echo -e "\e[1;45m \e[1;37m Make sure there are no hashed passwords. If so, have the SA move the hash to /etc/shadow \e[0m"     
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m View /etc/shadow \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
echo -e "\e[1;45m \e[1;37m Once you hit enter, you will be taken to the /etc/shadow file \e[0m"
read
cat /etc/shadow | more
echo ""
echo -e "\e[1;45m \e[1;37m Review the /etc/shadow file and make sure that every account listed below belongs on the system \e[0m" 
echo -e "\e[1;45m \e[1;37m Shadow File Syntax: Username:Password(encrypted):LastPwdChange:MinDaysToChangePwd:MaxDaysToChangePwd:DaysBeforePwdExpires:DaysUntilAcctIsInactive:DaysUntilAcctExpires \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m View cronjobs \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
crontab -l
echo ""
echo -e "\e[1;45m \e[1;37m Review cronjobs set to run on the system. Make sure a Virus Scan is running. \e[0m"
echo -e "\e[1;45m \e[1;37m Crontab File Syntax: Minute(0-60)-Hour(0-24)-DayOfMonth(1-31)-Month(1-12)-DayOfWeek(0=Sunday,1=Monday to 6=Saturday) \e[0m" 
echo -e "\e[1;45m \e[1;37m If a Virus Scan is not running here, please contact the SA \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Virus-Scan Version \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
/usr/local/uvscan/uvscan --version
echo ""
echo -e "\e[1;45m \e[1;37m For your McAfee Virus-Scan software, please verify that your version and patch level are up-to-date \e[0m"
echo -e "\e[1;45m \e[1;37m For your .dats aka virus definitions, please verify that the date is within 30 days of today \e[0m"
echo -e "\e[1;45m \e[1;37m Please contact the SA if the any of the prementioned items are out-of-date \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m Virus-Scan Logs \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
ls -la /usr/local/uvscan/logs | tail -5
echo ""
echo -n "Copy + Paste the entire uvscan filename that you want to view including the .log at the end (i.e. hostname_191018_1730_uvscan.log): "; read my_date2
echo ""
egrep -e 'Engine version' -e 'Dat set' -e 'Scanning:' -e 'Total' -e 'Infected' /usr/local/uvscan/logs/$my_date2
echo -e "\e[1;45m \e[1;37m If any infected files found, examine the uvscan logs for what was cleaned and report to your SA and ISSM. \e[0m"
echo -e "\e[1;45m \e[1;37m Reports key statistics from the A/V logs \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear
echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;44m \e[1;37m You have completed your audit! \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
#Validation of successful copy
[ -f /data/seclogs/audits/audit.log-$my_date.gz ]
if [ $? == 0 ];
then 
    echo -e "\e[1;40m\e[1;32mSUCCESS: The file has been copied to /data/seclogs/audits/\e[0m"
else 
    echo -e "\e[1;40m\e[1;31mFAILURE: The file did not copy to /data/seclogs/audits/. Please verify the permissions on the directory path.\e[0m"
fi
echo -e "\e[1;42m \e[1;30m Press Enter to complete the script \e[0m"
read
clear


#Now we will clean up the /var/log/audit/auditfile we generated and move the zipped up log to the folder of your choosing. The script will default to /data/seclogs/audits/

#If you wish to edit the location where the zipped up log copies to, utilize vi controls to do so (look this up on the internet on how to navigate vi)

rm -rf /var/log/audit/auditfile
cp /var/log/audit/audit.log-$my_date.gz /data/seclogs/audits/
#cp /var/log/audit/audit.log-$my_date.gz /home/Security/audit_backups/hosts/$(hostname)/ 


exit
