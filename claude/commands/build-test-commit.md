Goal: Build, test, and commit iOS/Xcode changes with user verification

This command enters a special mode for iOS development where changes are built, tested in Xcode with user verification, and then committed.

Process:
1. **Make requested changes**:
   - Implement the features/fixes the user requested
   - Run swiftformat on any modified Swift files
   - Ensure code follows the SwiftUI style guide from CLAUDE.md

2. **Build the project**:
   - Use `xcodebuild` to build the project
   - If build fails, fix the errors and try again
   - Continue until the build succeeds

3. **Open for verification**:
   - Run the script at `/Users/joel/code/jd-configs/nvim/scripts/xcode_build_test_commit.sh`
   - This will automatically:
     - Open Xcode
     - Run the app (Cmd+R)
     - Display a prompt asking for user confirmation

4. **Wait for user confirmation**:
   - The script will prompt: "Type 'commit' when ready to commit, or 'cancel' to abort"
   - If user types 'commit', proceed to commit
   - If user types 'cancel', stop the process and ask what needs to be fixed

5. **Commit the changes**:
   - Use the git-commit-specialist agent
   - Follow commit message guidelines from CLAUDE.md:
     - Short, concise, colloquial messages
     - NO AI/Claude mentions or emojis
     - Focus on WHAT and WHY changed
   - Show the commit hash to the user

Example workflow:
- User: "/build-test-commit add a dark mode toggle to settings"
- Claude: Makes the changes, builds, opens Xcode for testing
- User: Tests the app and types "commit"
- Claude: Commits with message like "add dark mode toggle to settings"