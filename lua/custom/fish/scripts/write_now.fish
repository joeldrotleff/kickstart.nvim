#!/usr/bin/env fish

echo "Let's write!!!!!!!!!!!!!!!!"

# Set the base directory
set base_dir ~/Documents/writing/by_me

# Get the current date and month
set current_date (date "+%m-%d-%y")
set current_month (date "+%B, %Y")

# Get the current date in a verbose format, e.g. "Monday, January 01, 2021"
set current_date_verbose (date "+%A, %B %d, %Y")

# Create a new directory for the current month if it doesn't exist
set dir $base_dir/$current_month
if not test -d $dir
    mkdir -p $dir
end

# Create a new file with the current date
set new_file $dir/$current_date.md

cd $base_dir

# Sleep for 0.5s to give user time to see the printed message
sleep 0.5

# Open the new file in neovim
nvim $new_file



