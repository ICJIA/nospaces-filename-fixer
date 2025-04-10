#!/bin/bash

###############################################################################
# Name: nospaces.sh
# Description: Utility script to clean up filenames by:
#   - Replacing spaces with underscores
#   - Removing single and double quotes
#   - Setting file permissions to 777 (rwxrwxrwx)
#
# Usage:
#   ./nospaces.sh <filename>
#
# Examples:
#   ./nospaces.sh "my file.txt"        -> my_file.txt
#   ./nospaces.sh "user's file.txt"    -> users_file.txt
#   ./nospaces.sh "my \"quoted\" file" -> my_quoted_file
#
# Installation:
#   To make globally executable:
#   1. Make script executable:
#      chmod +x nospaces.sh
#   2. Move to system bin:
#      sudo cp nospaces.sh /usr/local/bin/nospaces
#   3. Verify installation:
#      which nospaces
#
# After Changes:
#   If you modify this script, remember to:
#   1. Source your shell to apply changes:
#      source ~/.bashrc     # For Bash
#      source ~/.zshrc      # For Zsh
#   2. If installed globally, copy again:
#      sudo cp nospaces.sh /usr/local/bin/nospaces
#
# Exit Codes:
#   0 - Success (file renamed or no action needed)
#   1 - Error (missing argument, file not found, target exists)
#
# Safety Features:
#   - Prevents overwriting existing files
#   - Requires user confirmation before renaming
#   - Handles filenames with special characters
#   - Validates file existence before processing
###############################################################################

# --- Argument Handling ---
# Check if a filename argument was provided
if [[ $# -eq 0 ]]; then
  # Print usage instructions using the actual script name
  echo "Usage: $(basename "$0") <filename_with_spaces_and_or_quotes>"
  echo "Example: $(basename "$0") \"my 'document' file.txt\""
  exit 1 # Exit with an error code
fi

original_file="$1"
temp_file=""
new_file=""

# --- File Existence Check ---
# Check if the provided argument is actually a file or directory
# Using -e checks for existence (file, directory, symlink etc.)
if [[ ! -e "$original_file" ]]; then
  echo "Error: File or directory '$original_file' not found."
  exit 1
fi

# --- Filename Cleaning ---
# 1. Trim leading and trailing spaces
trimmed_file="$(echo "$original_file" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
# 2. Replace all remaining spaces with underscores using Bash parameter expansion
temp_file="${trimmed_file// /_}"
# 3. Remove all single quotes (') using Bash parameter expansion
temp_file="${temp_file//\'/}"
# 4. Remove all double quotes (") using Bash parameter expansion
new_file="${temp_file//\"/}"
# --- End Filename Cleaning ---


# --- Check if Renaming is Needed ---
# Check if the filename was actually changed by the cleaning process
# (Handles cases where the original had no spaces or quotes)
if [[ "$original_file" == "$new_file" ]]; then
  echo "Filename '$original_file' does not contain spaces or quotes needing removal. Setting permissions only."

  # Set permissions even if no renaming is needed
  chmod 777 -- "$original_file"

  # Check if chmod was successful
  if [[ $? -eq 0 ]]; then
    echo "Permissions successfully set to rwxrwxrwx."
  else
    echo "Warning: Failed to set permissions to rwxrwxrwx for '$original_file'." >&2
  fi

  exit 0 # Exit successfully
fi

# --- Target Filename Check ---
# Check if a file with the new name already exists to prevent overwriting
if [[ -e "$new_file" ]]; then
  echo "Error: Target filename '$new_file' already exists. Aborting to prevent overwrite."
  exit 1
fi

# --- Confirmation ---
# Show the proposed change and ask for confirmation
echo "Original: '$original_file'"
echo "New name: '$new_file'"

# Prompt the user - Bash equivalent of zsh's read -q
# -n 1: Read only one character
# -p "Prompt": Display the prompt text
# REPLY: Store the answer in the REPLY variable (default for read without var name)
read -n 1 -p "Rename this file? (y/n) " REPLY
echo # Print a newline after the prompt for cleaner output

# --- Perform Rename and Set Permissions ---
# Check the user's response (case-insensitive using regex match)
if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  # Perform the move (rename) command
  # Using -- ensures filenames starting with '-' are handled correctly
  mv -- "$original_file" "$new_file"

  # Check if the move was successful ($? holds the exit status of the last command)
  if [[ $? -eq 0 ]]; then
    echo # Add a newline for spacing
    echo "File successfully renamed to '$new_file'."

    # --- Set Permissions ---
    # Attempt to set permissions to rwxrwxrwx (octal 777) for the new file
    # Using -- ensures filenames starting with '-' are handled correctly by chmod
    chmod 777 -- "$new_file"

    # Check if chmod was successful
    if [[ $? -eq 0 ]]; then
        echo "Permissions successfully set to rwxrwxrwx."
        exit 0 # Exit with success code (rename and chmod both worked)
    else
        # Print a warning if chmod fails, but don't exit with error, as rename succeeded
        # Redirect warning message to standard error (>&2)
        echo "Warning: Failed to set permissions to rwxrwxrwx for '$new_file'." >&2
        # Exit successfully because the primary goal (rename) worked.
        # Change to 'exit 1' or another non-zero code if chmod failure should
        # indicate an overall script failure.
        exit 0
    fi
    # --- End Set Permissions ---

  else
    # mv command failed
    echo # Add a newline for spacing
    echo "Error: Failed to rename the file. Check permissions or other issues."
    exit 1 # Exit with error code
  fi
else
  # User did not confirm with 'y' or 'Y'
  echo # Add a newline for spacing
  echo "Operation cancelled by user."
  exit 0 # Exit successfully (operation cancelled is not a script error)
fi
