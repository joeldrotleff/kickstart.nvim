#!/usr/bin/env fish

function yolo
    # Check if we're in a git repository
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Error: Not in a git repository"
        return 1
    end
    
    # Check if a commit message was provided
    if test (count $argv) -eq 0
        echo "❌ Error: Please provide a commit message"
        echo ""
        echo "Usage: yolo <commit message>"
        echo "Example: yolo added a new setting"
        return 1
    end
    
    # Combine all arguments into a single commit message
    set commit_message (string join " " $argv)
    
    # Add all changes
    echo "📦 Adding all changes..."
    git add -A
    
    # Show the diff
    echo ""
    echo "📊 Here's what will be committed:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    git diff --cached --stat
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Show detailed diff if it's not too large
    set diff_lines (git diff --cached | wc -l | string trim)
    if test $diff_lines -lt 100
        git diff --cached
        echo ""
    else
        echo "💡 Diff is large ($diff_lines lines). Showing summary only."
        echo "   Run 'git diff --cached' to see full changes."
        echo ""
    end
    
    # Ask for confirmation
    echo "🤔 Does this look right? (y/n)"
    read -l -n 1 response
    
    if test "$response" != "y" -a "$response" != "Y"
        echo ""
        echo "❌ Cancelled. Changes are still staged."
        echo "💡 Run 'git reset' to unstage them."
        return 1
    end
    
    echo ""
    echo "💬 Committing with message: \"$commit_message\""
    git commit -m "$commit_message"
    
    if test $status -ne 0
        echo "❌ Error: Commit failed"
        return 1
    end
    
    # Get current branch
    set current_branch (git branch --show-current)
    
    # Push to origin
    echo ""
    echo "🚀 Pushing to origin/$current_branch..."
    git push origin $current_branch
    
    if test $status -ne 0
        echo ""
        echo "❌ Error: Push failed"
        echo "💡 Your commit is saved locally. Try 'git push' again later."
        return 1
    end
    
    echo ""
    echo "✅ All done! Changes committed and pushed successfully."
    echo "🎉 YOLO complete!"
end