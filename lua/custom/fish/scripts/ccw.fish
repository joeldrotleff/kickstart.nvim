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
    
    # Detect the default branch (main or master)
    set default_branch ""
    
    # Try to get the default branch from remote origin
    set remote_head (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
    
    if test -n "$remote_head"
        set default_branch $remote_head
    else
        # Fallback: check if main or master exists
        if git rev-parse --verify main >/dev/null 2>&1
            set default_branch "main"
        else if git rev-parse --verify master >/dev/null 2>&1
            set default_branch "master"
        else
            echo "Error: Could not determine default branch (main or master)"
            return 1
        end
    end
    
    echo "📌 Using default branch: $default_branch"
    
    # Generate a pleasant random name
    # Select random adjective and noun
    set adj_count (count $adjectives)
    set noun_count (count $nouns)
    set random_adj (math (random) % $adj_count + 1)
    set random_noun (math (random) % $noun_count + 1)
    
    set selected_adj $adjectives[$random_adj]
    set selected_noun $nouns[$random_noun]
    
    set worktree_name "wt-$selected_adj-$selected_noun"
    set worktree_path "$git_root/$worktree_name"
    
    echo "✨ Creating worktree '$worktree_name'..."
    
    # Create the worktree with a new branch based on the default branch
    git worktree add -b "$worktree_name" "$worktree_path" "$default_branch"
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