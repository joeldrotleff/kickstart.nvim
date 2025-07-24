# Day in the Life - Raw Data Export

Extract today's Claude Code conversations into a single markdown file using the claude-conversation-extractor tool.

## Setup & Execution

1. **First, ensure the tool is installed**
   ```bash
   # Check if claude-conversation-extractor is installed
   which claude-conversation-extractor || pip install git+https://github.com/ZeroSumQuant/claude-conversation-extractor.git
   ```

2. **Get user's first name and today's date**
   ```bash
   # Extract first name from username
   USERNAME=$(whoami)
   FIRST_NAME=$(echo $USERNAME | awk '{print toupper(substr($0,1,1)) substr($0,2)}' | sed 's/[^a-zA-Z].*//')
   
   # Get today's date in MM-DD-YYYY format
   DATE=$(date +"%m-%d-%Y")
   
   # Create output filename
   OUTPUT_FILE="day-in-the-life-${FIRST_NAME,,}-${DATE}.md"
   ```

3. **Extract recent conversations**
   ```bash
   # Extract conversations from the last 24 hours
   claude-conversation-extractor --since "24 hours ago" --output-dir /tmp/claude-exports
   ```

4. **Process all exported files into a single markdown document**
   - Parse each conversation JSON from `/tmp/claude-exports`
   - Extract repository/directory context for each session
   - Pull out user messages and assistant actions
   - Combine all sessions into one file with the naming format: `day-in-the-life-joel-12-25-2025.md`

5. **Output Format**

```markdown
# Day in the Life - [First Name] - [Date]

## Session 1: [Repository/Directory Name]

**[Timestamp]**
[First Name]: "[Exact command/request]"
Claude: [What Claude did - file edits, commands, etc.]

**[Timestamp]**  
[First Name]: "[Next command/request]"
Claude: [What Claude did]

## Session 2: [Next Repository/Directory]

**[Timestamp]**
[First Name]: "[Command/request]"
Claude: [Actions taken]

[Continue for all sessions from today]
```

Create a single markdown file named `day-in-the-life-[firstname]-[MM-DD-YYYY].md` with all of today's Claude Code sessions.