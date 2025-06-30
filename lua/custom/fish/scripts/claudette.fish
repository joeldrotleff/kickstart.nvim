#!/usr/bin/env fish

function claudette
    # Check for help flag
    if test "$argv[1]" = "--help" -o "$argv[1]" = "-h"
        echo "🎭 claudette - Save Claude Code context to a git branch"
        echo ""
        echo "Usage:"
        echo "  claudette <name>    Save current changes to branch claudette/<name>"
        echo "  claudette          Save with auto-generated name based on timestamp"
        echo "  claudette --help   Show this help message"
        echo ""
        echo "How it works:"
        echo "  1. Validates current_context.yaml exists with proper structure"
        echo "  2. Stashes current changes"
        echo "  3. Creates new branch claudette/<name>"
        echo "  4. Unstashes and commits changes"
        echo "  5. Returns to original branch with changes restored"
        echo ""
        echo "Requirements:"
        echo "  - Must be in a git repository"
        echo "  - current_context.yaml must exist with valid conversation structure"
        echo ""
        return 0
    end
    
    # Get the root of the current git working directory
    set git_root (git rev-parse --show-toplevel 2>/dev/null)
    
    if test -z "$git_root"
        echo "❌ Error: Not in a git repository"
        return 1
    end
    
    # Check if current_context.yaml exists in git root
    if not test -f "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml not found in repository root"
        echo "💡 This file should be created by Claude Code with conversation history in YAML format"
        echo ""
        echo "Expected YAML structure:"
        echo "  conversation:"
        echo "    - role: user"
        echo "      content: \"user prompt\""
        echo "    - role: assistant"
        echo "      content: \"claude response\""
        echo "  timestamp: \"2024-12-30T14:30:00Z\""
        echo "  metadata:"
        echo "    project: \"project name\""
        echo "    branch: \"current branch\""
        return 1
    end
    
    # Validate YAML structure
    echo "🔍 Validating current_context.yaml structure..."
    
    # Check if file contains required fields
    if not grep -q "^conversation:" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml missing 'conversation:' field"
        return 1
    end
    
    if not grep -q "^timestamp:" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml missing 'timestamp:' field"
        return 1
    end
    
    if not grep -q "^metadata:" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml missing 'metadata:' field"
        return 1
    end
    
    # Check for conversation structure with roles
    if not grep -q "role: user" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml missing user messages (role: user)"
        return 1
    end
    
    if not grep -q "role: assistant" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml missing assistant messages (role: assistant)"
        return 1
    end
    
    # Check metadata fields
    if not grep -q "project:" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml missing 'project:' in metadata"
        return 1
    end
    
    if not grep -q "branch:" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml missing 'branch:' in metadata"
        return 1
    end
    
    # Basic YAML syntax check - ensure no tabs (YAML requires spaces)
    if grep -q "\t" "$git_root/current_context.yaml"
        echo "❌ Error: current_context.yaml contains tabs. YAML requires spaces for indentation"
        return 1
    end
    
    echo "✅ current_context.yaml validation passed"
    
    # Get current branch for reference
    set current_branch (git branch --show-current)
    
    # Determine branch name
    set branch_name ""
    if test -n "$argv[1]"
        # User provided a name
        set branch_name "claudette/$argv[1]"
    else
        # Generate name based on timestamp
        set timestamp (date "+%Y%m%d-%H%M%S")
        set branch_name "claudette/$timestamp"
    end
    
    echo ""
    echo "🎭 Saving Claude Code context..."
    echo "📍 Current branch: $current_branch"
    echo "🌿 Target branch: $branch_name"
    echo ""
    
    # Check for uncommitted changes
    echo "🔍 Checking for uncommitted changes..."
    set has_changes (git status --porcelain)
    
    if test -z "$has_changes"
        echo "ℹ️  No uncommitted changes found"
        echo ""
        
        # Still create the branch and switch to it
        echo "🌿 Creating branch '$branch_name'..."
        git checkout -b "$branch_name"
        
        if test $status -ne 0
            echo "❌ Error: Failed to create branch"
            return 1
        end
        
        echo "✅ Branch created successfully"
        echo "💡 No changes to commit - branch is ready for future work"
        
        # Switch back to original branch
        echo "🔄 Returning to branch '$current_branch'..."
        git checkout "$current_branch"
        
        return 0
    end
    
    # Show what will be saved
    echo "📝 Changes to be saved:"
    git status --short
    echo ""
    
    # Stash changes
    echo "📦 Stashing changes..."
    set stash_message "claudette: temporary stash for $branch_name"
    git stash push -m "$stash_message" --include-untracked
    
    if test $status -ne 0
        echo "❌ Error: Failed to stash changes"
        return 1
    end
    
    # Create and switch to new branch
    echo "🌿 Creating branch '$branch_name'..."
    git checkout -b "$branch_name"
    
    if test $status -ne 0
        echo "❌ Error: Failed to create branch"
        # Try to restore stash
        echo "🔄 Attempting to restore stashed changes..."
        git stash pop
        return 1
    end
    
    # Apply stashed changes
    echo "📦 Applying stashed changes..."
    git stash pop
    
    if test $status -ne 0
        echo "❌ Error: Failed to apply stashed changes"
        echo "💡 You can manually apply with: git stash pop"
        return 1
    end
    
    # Stage all changes (including untracked files)
    echo "📝 Staging all changes..."
    git add -A
    
    # Create commit message
    set commit_date (date "+%Y-%m-%d %H:%M:%S")
    set commit_message "Save Claude Code context - $commit_date

Branch created from: $current_branch
Contains: Work in progress with Claude Code conversation context"
    
    # Commit changes
    echo "💾 Committing changes..."
    git commit -m "$commit_message"
    
    if test $status -ne 0
        echo "❌ Error: Failed to commit changes"
        return 1
    end
    
    echo ""
    echo "✅ Successfully saved Claude Code context to branch '$branch_name'!"
    
    # Switch back to original branch
    echo "🔄 Returning to branch '$current_branch'..."
    git checkout "$current_branch"
    
    if test $status -ne 0
        echo "❌ Error: Failed to switch back to original branch"
        echo "💡 You can manually switch with: git checkout $current_branch"
        return 1
    end
    
    # Recreate the working directory state by checking out files from the saved branch
    echo "📦 Restoring working directory state..."
    
    # Get list of files that were changed in the commit
    set changed_files (git diff --name-only "$current_branch" "$branch_name")
    
    if test -n "$changed_files"
        # Checkout the files from the saved branch to restore the working directory
        for file in $changed_files
            git checkout "$branch_name" -- "$file" 2>/dev/null
        end
        
        echo "✅ Working directory restored to previous state"
        echo "📝 Your uncommitted changes are back in the working directory"
    end
    
    echo ""
    echo "🎯 Summary:"
    echo "  - Context saved to branch: $branch_name"
    echo "  - Current branch: $current_branch"
    echo "  - Working directory: restored with uncommitted changes"
    echo ""
    echo "💡 To push the saved branch: git push -u origin $branch_name"
    
    return 0
end