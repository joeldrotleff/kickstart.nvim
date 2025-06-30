Goal: Save the current Claude Code conversation context and git changes to a branch

Steps:
1. First, save the current conversation context to a file called `current_context.yaml` in the git repository root
   The YAML file must follow this exact structure:
   ```yaml
   conversation:
     - role: user
       content: |
         <user's first message>
     - role: assistant  
       content: |
         <claude's first response>
     - role: user
       content: |
         <user's second message>
     - role: assistant
       content: |
         <claude's second response>
   timestamp: "2024-12-30T14:30:00Z"
   metadata:
     project: "<project name from git repo>"
     branch: "<current git branch>"
     model: "claude-3-opus-20240229"  # or whatever model is being used
   ```
   
   Important formatting notes:
   - Use literal block scalars (|) for multiline content
   - Properly escape any quotes in the content
   - Include ALL messages in the conversation
   - Use ISO 8601 format for timestamp

2. Then run the `claudette` fish script using Bash tool:
   ```bash
   claudette
   ```
   This will:
   - Validate that current_context.yaml exists and has proper structure
   - Stash current changes
   - Create a new branch named `claudette/<timestamp>`
   - Commit all changes including the context file
   - Switch back to the original branch
   - Restore the working directory state

3. Provide a summary to the user:
   - Confirm the context was saved
   - Show the branch name where it was saved
   - Note the file path of current_context.yaml
   - Remind them they're back on their original branch with changes restored

Note: The claudette script will handle all the git operations. Your job is to create the properly formatted current_context.yaml file first.