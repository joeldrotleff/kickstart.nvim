#!/bin/bash

# Xcode Build Test Commit Mode Script
# This script builds the project, opens it in Xcode for verification,
# and waits for user confirmation before committing

# Function to print colored output
print_status() {
    echo -e "\033[1;34m[BUILD-TEST-COMMIT]\033[0m $1"
}

print_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

print_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

# Check if we're in an Xcode project directory
if ! find . -name "*.xcodeproj" -o -name "*.xcworkspace" | grep -q .; then
    print_error "No Xcode project found in current directory"
    exit 1
fi

# Build the project
print_status "Building project..."
xcodebuild -quiet build 2>&1 | tee build.log

if [ ${PIPESTATUS[0]} -ne 0 ]; then
    print_error "Build failed! Check build.log for details"
    exit 1
fi

print_success "Build succeeded!"

# Open in Xcode and run
print_status "Opening project in Xcode for verification..."
osascript /Users/joel/code/jd-configs/nvim/scripts/xcode_run.scpt

# Wait for user confirmation
print_status "Please verify the app is working correctly in Xcode"
echo -n "Type 'commit' when ready to commit, or 'cancel' to abort: "
read response

if [ "$response" = "commit" ]; then
    print_status "Ready to commit changes"
    echo "true"
    exit 0
else
    print_status "Commit cancelled"
    echo "false"
    exit 1
fi