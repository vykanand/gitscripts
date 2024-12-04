#!/bin/bash

# Ensure the script is executable
chmod +x "$0"  # Make the script itself executable

# Check if the Git repository exists, and if not, clone it
if [ ! -d "./.git" ]; then
    echo "Git hooks directory not found, cloning repository..."
    git clone "https://github.com/vykanand/gitscripts-d2" "./"
else
    echo "Git hooks directory found, pulling the latest changes..."

    # Temporarily stash any local changes to cron-script.sh to keep it safe
    if [ -f "./cron-script.sh" ]; then
        echo "Stashing local 'cron-script.sh' to avoid overwriting it"
        git stash push --include-untracked ./cron-script.sh
    fi

    # Now safely pull the latest changes from the repository
    git pull origin main  # Or the appropriate branch

    # If cron-script.sh was stashed, restore it after the pull
    if [ -f "./cron-script.sh" ]; then
        echo "Restoring local 'cron-script.sh' from stash"
        git stash pop
    fi
fi

# Verify the structure after pulling or cloning
echo "Checking contents of current directory"
ls -l  # To verify where the hook scripts are located

# Ensure that the hooks directory exists (current directory now contains the hooks)
if [ ! -d "./" ]; then
    echo "Error: Git hooks directory does not exist in the current directory"
    echo "Git hooks setup failed."
    exit 1  # Exit since critical directory is missing
fi

# Ensure that all hook scripts are executable
chmod -R +x .

# Run the custom script located in the current directory
CUSTOM_SCRIPT="./custom-script.sh"

# Check if custom-script.sh exists
if [ -f "$CUSTOM_SCRIPT" ]; then
    echo "Running custom script..."
    chmod +x "$CUSTOM_SCRIPT"  # Make sure it's executable
    "$CUSTOM_SCRIPT"  # Run the custom script
    echo "Custom script executed."
else
    echo "Custom script not found at $CUSTOM_SCRIPT. Skipping..."
fi

echo "Git hooks have been updated (if needed) and the custom script has been executed."
