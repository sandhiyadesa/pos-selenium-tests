#!/bin/bash

# Define the directory path
directory="/home/azureuser/reports"

# Check if the directory exists
if [ -d "$directory" ]; then
    # List all directories (excluding hidden ones) within the specified directory
    # and output their names
    echo "Folders created in $directory:"
    for folder in "$directory"/*/; do
        folder_name=$(basename "$folder")
        echo "$folder_name"
        # You can perform further operations with $folder_name here
    done
else
    echo "Directory $directory does not exist."
fi