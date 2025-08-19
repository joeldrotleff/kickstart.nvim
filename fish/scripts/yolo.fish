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
    
    # Get the default remote (usually 'origin', but could be different)
    set remote (git remote | head -n1)
    if test -z "$remote"
        echo "❌ Error: No git remote configured"
        echo "💡 Add a remote with: git remote add origin <url>"
        return 1
    end
    
    # Try to push first (optimistic approach)
    echo ""
    echo "🚀 Pushing to $remote/$current_branch..."
    git push $remote $current_branch 2>&1
    set push_status $status
    
    if test $push_status -eq 0
        # Push succeeded on first try - we're done!
        echo ""
        echo "✅ All done! Changes committed and pushed successfully."
        echo "🎉 YOLO complete!"
        return 0
    end
    
    # Push failed - check if it's because remote has new commits
    echo ""
    echo "⚠️  Push failed. Checking if remote has new commits..."
    
    # Fetch to see what's on remote
    git fetch $remote $current_branch
    
    # Check if we're behind
    set behind_count (git rev-list --count HEAD..$remote/$current_branch)
    
    if test $behind_count -gt 0
        echo "📥 Remote has $behind_count new commit(s). Pulling with rebase..."
        git pull --rebase $remote $current_branch
        
        if test $status -ne 0
            echo ""
            echo "❌ Error: Merge conflict detected during rebase!"
            echo "⚠️  Your commit is saved locally but not pushed."
            echo ""
            echo "To resolve:"
            echo "  1. Fix the conflicts in the listed files"
            echo "  2. Run 'git add' on the resolved files"
            echo "  3. Run 'git rebase --continue'"
            echo "  4. Then run 'git push $remote $current_branch'"
            echo ""
            echo "Or to abort the rebase and return to your previous state:"
            echo "  Run 'git rebase --abort'"
            return 1
        end
        
        # Try pushing again after successful rebase
        echo ""
        echo "🚀 Pushing again after rebase..."
        git push $remote $current_branch
        
        if test $status -ne 0
            echo ""
            echo "❌ Error: Push still failed after rebase"
            echo "💡 Your commit is saved locally. Try 'git push' again later."
            return 1
        end
    else
        # Push failed for some other reason
        echo ""
        echo "❌ Error: Push failed (not due to new remote commits)"
        echo "💡 Your commit is saved locally. Check your connection and try 'git push' again."
        return 1
    end
    
    echo ""
    echo "✅ All done! Changes committed and pushed successfully."
    echo "🎉 YOLO complete!"
end