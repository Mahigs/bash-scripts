#!/bin/bash

# DT.bat Linux Script (DT.sh)

# Created by: Matthew Mahigian
# Email: matthew.j.mahigian@lmco.com

# Created on: March 24th, 2020

# Version: 1.0

# Description: This script is intended to satisfy the DCSA DTA Logging Requirement in accordance with the DAAPM

# Date Variable
LOGDATE=$(/bin/date '+%Y%m%d%H%M%S')

# Things to test/add/need-to-do:


# Prerequisities to running this script
#   - Make sure a DTA group in /etc/group is created and the user running the script is in it
#   - Whether or not a datatransferlogs directory already exists or not, make sure the permissions are 0750 (so DTAs can write to the datatransferlogs directory )
#   - Make sure the User and Group owners are isso (or some sort of auditors group) and DTA respectively for /data/seclogs/datatransferlogs


if [ -d /data/seclogs/datatransferlogs ];
then
    clear
else
    echo "The /data/seclogs/datatransferlogs path was not found. Work with your SA to get the directory path created and acquiring write privileges to the directory"
    exit
fi   

echo "--------------------------------------------------------------------"
echo -e ">>>>>>>>>>>>>>>>>>>>" "\e[1;47m \e[1;34m Welcome to the Data Transfer Script \e[0m" "<<<<<<<<<<<<<<<<<<<"
echo "--------------------------------------------------------------------"
echo ""
echo -e "\e[1;40m \e[1;32m This script is designed to log the required information when performing a Data Transfer \e[0m"
echo -e "\e[1;40m \e[1;32m Only approved Data Transfer Agents are authorized to perform data transfers \e[0m"
echo ""
echo -e "\e[1;40m \e[1;32m Make sure that you're in the DTA group in /etc/group before running this script \e[0m"
echo -e "\e[1;40m \e[1;32m Make sure you're NOT running this script as a superuser (sudo,su) so the log will reflect you performing the transfer \e[0m"
echo -e "\e[1;40m \e[1;32m Lastly, although the /data/seclogs/datatransferlogs directory exists, please confirm you have write privileges to it \e[0m"
echo -e "\e[1;40m \e[1;32m If you don't have write privileges to the directory, you'll encounter an error on the first prompt. Work with your SA to get write privileges \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
read
clear


# Now let's move to the DT type section


echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "**                                                                                                                         **"
echo "**                                                                                                                         **"
echo "**   There are three types of data transfers, Low-to-High, High-to-High, and High-to-Low (AFT).                            **"
echo "**                                                                                                                         **"
echo "**       1 - Low-to-High (LTH) data transfers:                                                                             **"
echo "**            - A transfer from a lower classification system to a higher classification system                            **"
echo "**                                                                                                                         **"
echo "**       2 - High-to-High (HTH) data transfers:                                                                            **"
echo "**            - A transfer between systems of the same classification                                                      **"
echo "**                                                                                                                         **"
echo "**       3 - High-to-Low (HTL) Assured File Transfers (AFT):                                                               **"
echo "**            - A transfer from a higher classification system to a lower classification system                            **"
echo "**                                                                                                                         **"
echo "**       High-to-Low (HTL) limitations:                                                                                    **"
echo "**            - HTL AFTs may only be performed on ASCII, HTML, JPEG, BMP, and GIF file types                               **"
echo "**            - HTL AFTs must follow the DCSA AFT procedures located in the SSP binder                                     **"
echo "**                                                                                                                         **"
echo "**                                                                                                                         **"
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo ""
# Let's define the variable $valid_input throughout the script. This variable will help us with our while loops that allows users to try-again at the each prompt.
valid_input1=false
echo ""
echo ""
while [ $valid_input1 == false ];
do
    echo -n "Enter the type of Data Transfer you are performing (LTH,HTH,HTL): "; read dt_type
    
    if [ $dt_type == LTH ];
    then
        echo 'This type of Data Transfer was a LTH.' > /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo ""
        valid_input1=true
        echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
        read
        clear

    elif [ $dt_type == HTH ];
    then 
        echo 'This type of Data Transfer was a HTH.' > /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo ""
        valid_input1=true
        echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
        read
        clear

    elif [ $dt_type == HTL ];
    then
        echo 'This type of Data Transfer was a HTL.' > /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo ""
        valid_input1=true
        echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
        read
        clear
    else
        echo "You have entered an invalid option. Please enter either LTH, HTH, or HTL depending on your type of transfer."
    fi
done

# Now let's move to the data source section


echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "**                                                                                                                         **"
echo "**                                                                                                                         **"
echo "**                  Examples of sources are LMI, Hostname and Information System, Vendor, etc.                             **"
echo "**                                                                                                                         **"
echo "**                                                                                                                         **"
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo ""
valid_input2=false
echo ""
echo ""
while [ $valid_input2 == false ];
do
    echo -e "\e[1;47m \e[1;34m NOTE: If you are going to list out a source with a space in the name, please substitute that space with the _ character \e[0m"
    echo ""
    echo -n "Enter the source where this data is coming from: "; read data_source

    if [ -z $data_source ];
    then
        echo "There was no value given. Please specify where the data is coming from."
    else
        echo >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo 'The following data source was' $data_source >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo ""
        valid_input2=true
        echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
        read
        clear
    fi 
done

# Now let's do how many copies

valid_input3=false

while [ $valid_input3 == false ];
do
    echo -n "Enter the number of copies that will be made of this data: "; read number_of_copies

    if [ -z $number_of_copies ]
    then
        echo "There was no value given. Please enter the number of copies you are making of this data."
    else
        echo >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo 'The number of copies made was' $number_of_copies >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo ""
        valid_input3=true
        echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
        read
        clear
    fi
done


# Now let's move to the full file path section


echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo "**                                                                                                                         **"
echo "**                                                                                                                         **"
echo "**             In a the Linux command line, you will want to open up a separate terminal and grab the full-file path       **"
echo "**             by doing the following:                                                                                     **"
echo "**                                                                                                                         **"
echo "**             If it's a file:                                                                                             **"
echo "**             - Go into the directory where the file lives, run the pwd command, copy that full-file path                 **"
echo "**             into the prompt, then type in the name of the file following the path in the prompt. Press Enter.           **"
echo "**                                                                                                                         **"
echo "**             Example:                                                                                                    **"
echo "**             - When you run pwd, you get the output /home/jsmith, so if your file is named myfile.txt,                   **"
echo "**             you'd type /myfile.txt after pwd in the prompt below and end up with /home/jsmith/myfile.txt                **"
echo "**                                                                                                                         **"
echo "**             If it's a directory:                                                                                        **"
echo "**             - Go into the directory where your files live, run the pwd command, and copy the full path                  **"
echo "**             into the prompt. Press Enter.                                                                               **"
echo "**                                                                                                                         **"
echo "**             IMPORTANT: If there are any blank spaces in your Folders or File names you must rename them                 **"
echo "**             to not include any spaces by utilizing the mv command  (you may have to preface mv with sudo)               **"
echo "**             Example:                                                                                                    **"
echo "**             bash-3.2$ mv my\ file.txt myfile.txt                                                                        **"
echo "**             bash-3.2$ mv /home/j\ smith /home/jsmith                                                                    **"
echo "**             NOTE: The backslashes are used to delimit the spaces                                                        **"
echo "**                                                                                                                         **"
echo "**                                                                                                                         **"
echo "*****************************************************************************************************************************"
echo "*****************************************************************************************************************************"
echo ""
valid_input4=false
echo ""
echo ""
while [ $valid_input4 == false ];
do 
    echo -e "\e[1;47m \e[1;34m NOTE: If you are run into any error regarding permission denied, it means you don't have access to said file/directory \e[0m"
    echo ""
    echo -n "Enter the full file path to the data you are moving: "; read file_path
    
    if [ -f $file_path ]
    then
        echo >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo 'The following file you are moving is' $file_path >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
        echo ""
        valid_input4=true
        echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
        read
        clear
    else
        if [ -d $file_path ]
        then
            echo >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
            echo 'The list of files you are moving is' $file_path >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
            echo >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
            ls -lL $file_path >> /data/seclogs/datatransferlogs/$dt_type'_'$(echo $LOGDATE)'_'$(whoami)'_DTLog'.txt
            valid_input4=true
            echo -e "\e[1;42m \e[1;30m Press Enter to continue on \e[0m"
            read
            clear
        else
            echo "Your file or directory was not found. Please make sure to specify the full file path of the data that you are moving."
        fi
    fi
done


# Now let's wrap up the script

echo -e "\e[1;42m \e[1;32m Congrats! Your Data Transfer is complete, your filename is: $(ls -tr /data/seclogs/datatransferlogs/ | tail -n 1 ) \e[0m"
echo ""
echo -e "\e[1;42m \e[1;30m Press Enter to conclude the script \e[0m"
read
clear












