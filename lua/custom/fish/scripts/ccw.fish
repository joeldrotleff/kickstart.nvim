#!/usr/bin/env fish

function ccw
    # Lists of adjectives and nouns for random names
    set adjectives brave cheerful dazzling elegant fancy gentle happy jolly kind lovely merry nice pleasant radiant serene tranquil vivid warm zealous bright calm delightful graceful harmonious joyful luminous peaceful quiet refined sparkling tender upbeat vibrant wonderful yearning zesty
    set nouns apple breeze canyon daisy eagle fountain garden harbor island jasmine kite lighthouse meadow nebula ocean penguin quartz rainbow seashell tulip umbrella valley waterfall xylophone yacht zenith butterfly cloud dolphin emerald forest galaxy horizon iris jungle koala lotus mountain nightingale opal phoenix quill river star
    
    # Get the root of the current git working directory
    set git_root (git rev-parse --show-toplevel 2>/dev/null)
    
    if test -z "$git_root"
        echo "Error: Not in a git repository"
        return 1
    end
    
    # Get the project name from the git root directory
    set project_name (basename $git_root)
    
    # Print welcome message
    echo ""
    echo "🛠️  Creating a new worktree for git project '$project_name'"
    echo ""
    
    # Store current directory to check if we need to change
    set current_dir (pwd)
    
    # Change to git root only if we're not already there
    if test "$current_dir" != "$git_root"
        echo "📂 Changing to git root directory..."
        cd $git_root
    end
    
    # Get current branch name
    set current_branch (git branch --show-current)
    
    # Check if we're on main or master
    if test "$current_branch" != "main" -a "$current_branch" != "master"
        echo "Error: Current branch is '$current_branch'. You must be on main or master branch."
        return 1
    end
    
    # Generate a pleasant random name
    # Select random adjective and noun
    set adj_count (count $adjectives)
    set noun_count (count $nouns)
    set random_adj (math (random) % $adj_count + 1)
    set random_noun (math (random) % $noun_count + 1)
    
    set selected_adj $adjectives[$random_adj]
    set selected_noun $nouns[$random_noun]
    
    set branch_name "$selected_adj-$selected_noun"
    set worktree_name "$selected_adj-$selected_noun"
    set worktree_path "$git_root/$worktree_name"
    
    echo "✨ Creating worktree '$worktree_name'..."
    
    # Create the worktree with a new branch
    git worktree add -b "$branch_name" "$worktree_path" "$current_branch"
    set worktree_status $status
    
    if test $worktree_status -ne 0
        echo "Error: Failed to create worktree"
        return 1
    end
    
    echo ""
    echo "✅ Worktree '$worktree_name' created, ready to work!"
    echo ""
    
    # Change to the new worktree directory
    cd "$worktree_path"
    
    # Start Claude in the new worktree
    echo "🤖 Starting Claude in $worktree_name..."
    claude
end