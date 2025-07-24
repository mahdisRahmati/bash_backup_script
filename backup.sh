#!/bin/bash
# bash backup script - step 1
echo "Starting backup script..."
read -p "Enter the source path for backup: " source_path
read -p "Enter the file extension to include (example txt or jpg): " file_ext
echo "Searching for *.$file_ext files in $source_path ..."
find "$source_path" -type f -name "*.$file_ext" > backup.conf
echo "List of files saved to backup.conf."
