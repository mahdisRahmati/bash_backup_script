#!/bin/bash

# *extra credit section - step CLI Menu
echo "============================="
echo "         Backup Menu         "
echo "1. Start backup"
echo "2. View log file"
echo "3. Exit"
echo "============================="
read -p "Choose an option (1 or 2 or 3): " choice

case $choice in
1)
  echo ">> Starting backup..."
  ;;
2)
  echo ">> Showing last 10 log entries:"
  tail -n 10 backup.log
  exit 0
  ;;
3)
  echo "Exiting."
  exit 0
  ;;
*)
  echo "Invalid option. Exiting."
  exit 1
  ;;
esac

# bash backup script - step 1
echo "Starting backup script..."
start_time=$(date +%s)
read -p "Enter the source path for backup: " source_path
read -p "Enter the file extension to include (example txt or jpg): " file_ext
echo "Searching for *.$file_ext files in $source_path ..."
find "$source_path" -type f -name "*.$file_ext" > backup.conf
echo "List of files saved to backup.conf."

# * extra credit section - step: Dry-Run
read -p "Do you want to run in dry-run mode? (y/n): " dry_run
if [ "$dry_run" == "y" ]; then
   echo " Dry-run mode enabled. The following files would be backed up:"
   cat backup.conf
   exit 0
fi

# step 2
read -p "Enter destination path to save the backup: " dest_path
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
backup_file="backup-$timestamp.tar.gz"
full_path="$dest_path/$backup_file"
echo "Creating backup archive at: $full_path"
tar -czf "$full_path" -T backup.conf

# *extra credit section - step encrypt
read -p "Do you want to encrypt the backup? (y/n): " encrypt
if [ "$encrypt" == "y" ]; then
   if command -v gpg &> /dev/null; then
       echo "Encrypting backup file..."
       gpg -c "$full_path"
       if [ $? -eq 0 ]; then
           echo "Encrypted file created: $full_path.gpg"
           rm "$full_path"
           full_path="$full_path.gpg"
       else 
           echo "Encryption failed."
       fi
    else
        echo "gpg is not installed. Skipping encryption."
    fi
fi
# Check success
if [ $? -eq 0 ]; then
  echo "Backup archive created successfully"
else
  echo "Error occurred while creating backup archive."
fi

# Logging the backup process - step 3
log_file="backup.log"
end_time=$(date +%s)
duration=$((end_time - start_time))
archive_size=$(du -h "$backup_path" | cut -f1)
file_count=$(cat backup.conf | wc -l)
{
  echo "Date       : $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Backup file: $backup_path"
  echo "File Count : $file_count"
  echo "Size       : $archive_size"
  echo "Duration   : ${duration}s"
  echo "Status     : Success"
} >> "$log_file"
echo "Backup log updated: $log_file"

# Remove old backups (older than 7 days) - step 4
echo "Checking for old backups to delete "
find "$dest_path" -type f -name "*.tar.gz" -mtime +7 -exec rm {} \;
echo "Old backups (older than 7 days) deleted if found."
