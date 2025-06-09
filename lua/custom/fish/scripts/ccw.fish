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
        echo "  ccw --imdone --force    Clean up worktree (discards all uncommitted changes)"
        echo "  ccw --help, -h          Show this help message"
        echo ""
        echo "Examples:"
        echo "  ccw cool-new-feature    Creates worktree 'wt-cool-new-feature' with branch 'cool-new-feature'"
        echo "  ccw --randomize         Creates worktree like 'wt-happy-dolphin' with random name"
        echo "  ccw --imdone           Safely removes current worktree after verification"
        echo "  ccw --imdone --force   Removes worktree, discarding all uncommitted changes"
        echo ""
        echo "Notes:"
        echo "  - Worktrees are prefixed with 'wt-' for easy gitignoring"
        echo "  - You'll be prompted to choose which branch to base the new worktree on"
        echo "  - By default, the current branch is selected (just press Enter)"
        echo "  - Claude is automatically started in the new worktree"
        return 0
    end
    
    # Check for --imdone flag
    if test "$argv[1]" = "--imdone"
        # Handle worktree cleanup
        
        # Check for --force option
        set force_mode false
        if test (count $argv) -ge 2 -a "$argv[2]" = "--force"
            set force_mode true
        end
        
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
            if test $force_mode = true
                echo "⚠️  Warning: You have uncommitted changes:"
                git status --short
                echo ""
                echo "🔥 Force mode enabled - resetting all changes..."
                git reset --hard HEAD
                git clean -fd
                echo "✅ All changes have been reset"
            else
                echo "⚠️  Warning: You have uncommitted changes:"
                git status --short
                echo ""
                echo "❌ Please commit or stash your changes before cleaning up."
                echo "💡 Tip: Use 'ccw --imdone --force' to discard all changes and proceed"
                return 1
            end
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
    
    # Check if we're in a worktree (not the main repo)
    set git_dir (git rev-parse --git-dir 2>/dev/null)
    set git_common_dir (git rev-parse --git-common-dir 2>/dev/null)
    
    if test "$git_dir" != "$git_common_dir"
        echo "❌ Error: You must be in the main repository to create a new worktree"
        echo "📍 Current location appears to be a worktree"
        echo ""
        echo "💡 Tip: Use 'ccw --imdone' to clean up current worktree first"
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
    
    # Get current branch before any operations
    set current_branch (git branch --show-current)
    
    # Get all branches (local and remote)
    echo "🌿 Select a branch to base the new worktree on:"
    echo ""
    
    # Get all branches including remote
    set all_branches_raw (git branch -a --format="%(refname:short)" | grep -v HEAD | sort | uniq)
    
    # Process branches to remove origin/ prefix for display
    set all_branches
    set branch_display
    for branch in $all_branches_raw
        if string match -q "origin/*" $branch
            # Remote branch - strip origin/ prefix
            set clean_branch (string replace "origin/" "" $branch)
            # Only add if we don't already have this branch locally
            if not contains $clean_branch $all_branches
                set all_branches $all_branches $clean_branch
                set branch_display $branch_display "$clean_branch (remote)"
            end
        else
            # Local branch
            set all_branches $all_branches $branch
            if test "$branch" = "$current_branch"
                set branch_display $branch_display "$branch ⭐ (current)"
            else if test "$branch" = "$default_branch"
                set branch_display $branch_display "$branch 🏠 (default)"
            else
                set branch_display $branch_display "$branch"
            end
        end
    end
    
    # Try to use interactive selection tools
    if command -v fzf >/dev/null 2>&1
        # Use fzf for interactive selection
        set selected_display (printf '%s\n' $branch_display | fzf --height=15 --reverse --header="Select branch (current: $current_branch)" --cycle)
        
        if test -z "$selected_display"
            echo "❌ Cancelled"
            return 1
        end
        
        # Extract the branch name from the display string
        set base_branch (string split ' ' $selected_display)[1]
    else if command -v gum >/dev/null 2>&1
        # Use gum for a nice arrow key interface
        set selected_display (printf '%s\n' $branch_display | gum choose --header="Select branch to base the new worktree on" --cursor-prefix="▶ " --selected-prefix="▶ ")
        
        if test -z "$selected_display"
            echo "❌ Cancelled"
            return 1
        end
        
        # Extract the branch name from the display string
        set base_branch (string split ' ' $selected_display)[1]
    else
        # Fallback to simple selection with arrow key hints
        echo "💡 Tip: Install fzf or gum for a better branch selection experience"
        echo "   brew install fzf   # or   brew install gum"
        echo ""
        
        # Display branches with the current branch pre-selected
        set branch_count (count $all_branches)
        set current_idx 1
        
        # Find current branch index
        for i in (seq 1 $branch_count)
            if test "$all_branches[$i]" = "$current_branch"
                set current_idx $i
                break
            end
        end
        
        # Display branches
        echo "Available branches:"
        for i in (seq 1 $branch_count)
            echo "  $i) $branch_display[$i]"
        end
        
        echo ""
        echo "📝 Enter branch name or number (default: $current_branch)"
        echo -n "Selection [press Enter for current]: "
        
        read -l selection
        set read_status $status
        
        # Check if read was interrupted (Ctrl-C)
        if test $read_status -ne 0
            echo ""
            echo "❌ Cancelled"
            return 1
        end
        
        if test -z "$selection"
            # User pressed Enter, use current branch
            set base_branch $current_branch
        else if string match -qr '^[0-9]+$' "$selection"
            # User entered a number
            if test $selection -ge 1 -a $selection -le $branch_count
                set base_branch $all_branches[$selection]
            else
                echo "❌ Error: Invalid selection"
                return 1
            end
        else
            # User entered a branch name
            if contains $selection $all_branches
                set base_branch $selection
            else
                echo "❌ Error: Branch '$selection' not found"
                return 1
            end
        end
    end
    
    echo ""
    echo "✅ Selected branch: $base_branch"
    
    echo ""
    
    # Fetch latest changes for the selected branch
    echo "⬇️  Fetching latest changes for $base_branch..."
    
    # Check if branch exists locally
    if git show-ref --verify --quiet "refs/heads/$base_branch"
        # Local branch exists
        git fetch origin $base_branch:$base_branch
        if test $status -ne 0
            echo "⚠️  Warning: Could not fetch latest changes for $base_branch"
            echo "   Continuing with local version..."
        end
    else
        # Remote branch only, fetch it
        git fetch origin $base_branch
        if test $status -ne 0
            echo "❌ Error: Failed to fetch branch $base_branch"
            return 1
        end
    end
    
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
    
    # Create the worktree with a new branch based on the selected base branch
    # Determine the correct ref to use
    set base_ref ""
    if git show-ref --verify --quiet "refs/heads/$base_branch"
        # Local branch exists, use it
        set base_ref "$base_branch"
    else
        # Remote branch only, use origin/branch
        set base_ref "origin/$base_branch"
    end
    
    # Capture git output to add emojis
    set git_output (git worktree add -b "$branch_to_create" "$worktree_path" "$base_ref" 2>&1)
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
    
    # Copy .env files from main repository to worktree
    echo "📄 Copying .env files..."
    set env_files_copied 0
    
    # Find all .env files in the main repository (including subdirectories)
    for env_file in (find "$git_root" -name ".env*" -type f -not -path "*/$worktree_name/*" -not -path "*/.git/*" -not -path "*/wt-*/*" 2>/dev/null)
        # Get the relative path from git root
        set rel_path (string replace "$git_root/" "" "$env_file")
        
        # Get the directory path
        set dir_path (dirname "$rel_path")
        
        # Create the target directory in worktree if it doesn't exist
        set target_dir "$worktree_path/$dir_path"
        if test "$dir_path" != "."
            mkdir -p "$target_dir"
        end
        
        # Copy the .env file
        set target_file "$worktree_path/$rel_path"
        cp "$env_file" "$target_file"
        
        set env_files_copied (math $env_files_copied + 1)
        echo "  ✓ Copied $rel_path"
    end
    
    if test $env_files_copied -eq 0
        echo "  ℹ️  No .env files found to copy"
    else
        echo "  📋 Copied $env_files_copied .env file(s)"
    end
    
    echo ""
    
    # Change to the new worktree directory
    cd "$worktree_path"
    
    # Start Claude in the new worktree (unless in test mode)
    if not set -q CCW_TEST_MODE
        echo "🤖 Starting Claude in $worktree_name..."
        claude
    end
end