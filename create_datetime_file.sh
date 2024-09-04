#!/bin/bash

# Define the file path
FILE_PATH="datetime.txt"

# Get the current date and time
CURRENT_DATETIME=$(date +"%Y-%m-%d %H:%M:%S")

# Write the current date and time to the file
echo "$CURRENT_DATETIME" > $FILE_PATH

echo "Created $FILE_PATH with current date and time."

# Optionally, you could commit the changes to the repository

git config --global user.name "abhishek"
git config --global user.email "abhishek@instnt.org"

git add $FILE_PATH
git commit -m "Update datetime.txt with current date and time"
git push

#testing