#!/bin/bash

# Determine the current directory where this script is located (where the script is being run)
SCRIPT_DIR="$(pwd)/gitscripts"  # This is where the Git hooks will be stored

# Ensure the script is executable
chmod +x "$0"  # Make the script itself executable

# Check if the directory exists, and if not, clone the hooks repo
if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Git hooks directory not found, cloning repository..."
    git clone "https://github.com/vykanand/gitscripts-d2" "$SCRIPT_DIR"
else
    echo "Git hooks directory found, pulling the latest changes..."
    cd "$SCRIPT_DIR"
    git pull origin main  # Or the appropriate branch
fi

# Now, since hooks are in the parent directory, we need to reference the correct location
HOOKS_SUB_DIR="$(pwd)"  # The parent directory now contains the git hooks directly

# Verify the cloned repo structure
echo "Checking contents of $HOOKS_SUB_DIR"
ls -l "$HOOKS_SUB_DIR"  # To verify where the hook scripts are located

# Ensure that the hooks directory exists (parent directory now contains the hooks)
if [ ! -d "$HOOKS_SUB_DIR" ]; then
    echo "Error: Git hooks directory does not exist in $SCRIPT_DIR"
    echo "Git hooks setup failed."
    exit 1  # Exit since critical directory is missing
fi

# Ensure that all hook scripts are executable
chmod -R +x "$HOOKS_SUB_DIR"

# Run the custom script located in the gitscripts folder
CUSTOM_SCRIPT="$SCRIPT_DIR/custom-script.sh"

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
