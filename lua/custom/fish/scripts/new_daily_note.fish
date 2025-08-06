#!/usr/bin/env fish

# Set the base directory
set base_dir ~/Documents/daily_notes

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

# Create a new note with the current date
set new_file $dir/$current_date.md
set todo_file $base_dir/todo.md

# Check if the new file already exists
if test -e $new_file
    echo "Warning: Note file for today already exists @ $new_file"
else
    # Copy the template to the new file
    cp $base_dir/daily_note_template.md $new_file
    echo "New file for today created."
    # Replace <TODAYS_DATE> with the current date in the new file
    sed -i '' "s/<TODAYS_DATE>/$current_date_verbose/g" $new_file

    # Copy unfinished TODOs from the todo_file to the new file
    echo -e "\n\n## From your TODOs:" >> $new_file
    grep "^\- \[-\]" $todo_file >> $new_file
end

# Set/Update a symlink that points to today's note
# This should allow Harpoon Neovim plugin to point 
# to today's note
ln -f -s $new_file $base_dir/today.md

# Switch to directory of current project
@MARCOPOLO

# Open the new file in neovim
nvim $new_file



