#!/usr/bin/env fish

function ccw
    # Check for help flag
    if test "$argv[1]" = "--help" -o "$argv[1]" = "-h"
        echo "🛠️  ccw - Create Claude Worktree"
        echo ""
        echo "Usage:"
        echo "  ccw <branch-name>        Create a worktree with the specified branch name"
        echo "  ccw --randomize          Create a worktree with a random pleasant name"
        echo "  ccw --imdone            Clean up current worktree (checks for pending work)"
        echo "  ccw --help, -h          Show this help message"
        echo ""
        echo "Examples:"
        echo "  ccw cool-new-feature    Creates worktree 'wt-cool-new-feature' with branch 'cool-new-feature'"
        echo "  ccw --randomize         Creates worktree like 'wt-happy-dolphin' with random name"
        echo "  ccw --imdone           Safely removes current worktree after verification"
        echo ""
        echo "Notes:"
        echo "  - Worktrees are prefixed with 'wt-' for easy gitignoring"
        echo "  - New branches are created from the latest origin/main or origin/master"
        echo "  - Claude is automatically started in the new worktree"
        return 0
    end
    
    # Check for --imdone flag
    if test "$argv[1]" = "--imdone"
        # Handle worktree cleanup
        
        # Get the root of the current git working directory
        set git_root (git rev-parse --show-toplevel 2>/dev/null)
        
        if test -z "$git_root"
            echo "❌ Error: Not in a git repository"
            return 1
        end
        
        # Check if we're in a worktree by comparing git-dir and git-common-dir
        # Note: git rev-parse --show-superproject-working-tree is for submodules, not worktrees!
        set git_dir (git rev-parse --git-dir 2>/dev/null)
        set git_common_dir (git rev-parse --git-common-dir 2>/dev/null)
        
        if test "$git_dir" = "$git_common_dir"
            echo "❌ Error: Not in a worktree"
            return 1
        end
        
        # Alternative method: Check if .git is a file (worktree) vs directory (main repo)
        # if test ! -f "$git_root/.git"
        #     echo "❌ Error: Not in a worktree"
        #     return 1
        # end
        
        # Get the parent repository directory
        set parent_repo_dir (dirname $git_common_dir)
        
        # Get the current worktree name
        set current_worktree (basename $git_root)
        
        echo ""
        echo "🧹 Preparing to clean up worktree '$current_worktree'..."
        echo ""
        
        # Check for uncommitted changes
        echo "🔍 Checking for uncommitted changes..."
        set has_changes (git status --porcelain)
        
        if test -n "$has_changes"
            echo "⚠️  Warning: You have uncommitted changes:"
            git status --short
            echo ""
            echo "❌ Please commit or stash your changes before cleaning up."
            return 1
        end
        
        # Check for unpushed commits
        echo "🔍 Checking for unpushed commits..."
        set current_branch (git branch --show-current)
        set unpushed (git log origin/$current_branch..$current_branch 2>/dev/null)
        
        if test -n "$unpushed"
            echo "⚠️  Warning: You have unpushed commits on branch '$current_branch'"
            echo ""
            echo "❌ Please push your commits before cleaning up."
            return 1
        end
        
        # All clear, proceed with cleanup
        echo "✅ No pending changes found"
        echo ""
        echo "🚀 Moving back to main repository..."
        
        # Navigate to the parent (main repo)
        cd $parent_repo_dir
        
        # Remove the worktree
        echo "🗑️  Removing worktree '$current_worktree'..."
        git worktree remove $git_root --force
        
        echo ""
        echo "✨ Worktree '$current_worktree' has been cleaned up!"
        echo "📍 You are now in the main repository"
        return 0
    end
    
    # Check for --randomize flag or branch name
    set use_random_name false
    set branch_name ""
    
    if test "$argv[1]" = "--randomize"
        set use_random_name true
    else if test -n "$argv[1]"
        set branch_name $argv[1]
    else
        # No arguments provided
        echo "❌ Error: Branch name required"
        echo ""
        echo "Usage:"
        echo "  ccw <branch-name>     Create worktree with specified branch"
        echo "  ccw --randomize       Create worktree with random name"
        echo "  ccw --help           Show full help"
        return 1
    end
    
    # Lists of adjectives and nouns for random names
    set adjectives brave cheerful dazzling elegant fancy gentle happy jolly kind lovely merry nice pleasant radiant serene tranquil vivid warm zealous bright calm delightful graceful harmonious joyful luminous peaceful quiet refined sparkling tender upbeat vibrant wonderful yearning zesty
    set nouns apple breeze canyon daisy eagle fountain garden harbor island jasmine kite lighthouse meadow nebula ocean penguin quartz rainbow seashell tulip umbrella valley waterfall xylophone yacht zenith butterfly cloud dolphin emerald forest galaxy horizon iris jungle koala lotus mountain nightingale opal phoenix quill river star
    
    # Get the root of the current git working directory
    set git_root (git rev-parse --show-toplevel 2>/dev/null)
    
    if test -z "$git_root"
        echo "❌ Error: Not in a git repository"
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
            echo "❌ Error: Could not determine default branch (main or master)"
            return 1
        end
    end
    
    echo "📌 Using default branch: $default_branch"
    
    # Fetch latest changes from origin
    echo "🔄 Fetching latest changes from origin..."
    git fetch origin
    
    # Determine worktree and branch names
    if test $use_random_name = true
        # Generate a pleasant random name
        # Select random adjective and noun
        set adj_count (count $adjectives)
        set noun_count (count $nouns)
        set random_adj (math (random) % $adj_count + 1)
        set random_noun (math (random) % $noun_count + 1)
        
        set selected_adj $adjectives[$random_adj]
        set selected_noun $nouns[$random_noun]
        
        set worktree_name "wt-$selected_adj-$selected_noun"
        set branch_to_create "$selected_adj-$selected_noun"
        echo "🎲 Generated random branch name: $branch_to_create"
    else
        # Use provided branch name
        set worktree_name "wt-$branch_name"
        set branch_to_create $branch_name
        echo "📝 Using provided branch name: $branch_name"
    end
    
    set worktree_path "$git_root/$worktree_name"
    
    echo "✨ Creating worktree '$worktree_name'..."
    
    # Create the worktree with a new branch based on the latest remote default branch
    # Capture git output to add emojis
    set git_output (git worktree add -b "$branch_to_create" "$worktree_path" "origin/$default_branch" 2>&1)
    set worktree_status $status
    
    if test $worktree_status -ne 0
        echo "❌ Error: Failed to create worktree"
        echo $git_output
        return 1
    end
    
    # Parse and enhance git output with emojis
    for line in $git_output
        if string match -q "*Preparing worktree*" $line
            echo "🔧 $line"
        else if string match -q "*branch*set up to track*" $line
            echo "🌿 $line"
        else if string match -q "*HEAD is now at*" $line
            echo "🗿 $line"
        else
            echo $line
        end
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