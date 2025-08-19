#!/usr/bin/env fish

# Update CLAUDE.md date on terminal startup
function update_claude_date
    set current_date (TZ="America/Los_Angeles" date +"%Y-%m-%d")
    
    set files \
        /Users/joel/.claude/CLAUDE.md \
        /Users/joel/.config/nvim/claude/CLAUDE.md
    
    for file in $files
        if test -f $file
            sed -i '' "s/\*\*Current date\*\*: [0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/**Current date**: $current_date/g" $file
        end
    end
end

# Run the update
update_claude_date