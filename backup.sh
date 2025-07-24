#!/bin/bash
# bash backup script - step 1
echo "Starting backup script..."
read -p "Enter the source path for backup: " source_path
read -p "Enter the file extension to include (example txt or jpg): " file_ext
echo "Searching for *.$file_ext files in $source_path ..."
find "$source_path" -type f -name "*.$file_ext" > backup.conf
echo "List of files saved to backup.conf."

# step 2
read -p "Enter destination path to save the backup: " dest_path
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
backup_file="backup-$timestamp.tar.gz"
full_path="$dest_path/$backup_file"
echo "Creating backup archive at: $full_path"
tar -czf "$full_path" -T backup.conf
# Check success
if [ $? -eq 0 ]; then
  echo "Backup archive created successfully"
else
  echo "Error occurred while creating backup archive."
fi
