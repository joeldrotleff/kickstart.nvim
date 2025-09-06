# Critical Instructions **DO NOT VIOLATE**
## Making commits:
When committing code, **ALWAYS** use the git commit subagent with these specific instructions:
- Keep commit messages **short, concise, and colloquial** (e.g., "fix login bug", "add dark mode", "update api endpoint")
- **NEVER** include any of the following in commit messages:
  - "🤖 Generated with [Claude Code]" 
  - "Co-Authored-By: Claude <noreply@anthropic.com>"
  - Any mention of AI, Claude, or automated generation
  - Any emoji or special formatting
- Write commit messages as if a human developer wrote them
- Focus on WHAT changed and WHY it changed (e.g., "fix login timeout issue", "add caching to improve performance")
- The WHY is more important than the WHAT



## File Headers:
**NEVER** add file headers (like //  FileName.swift, //  ProjectName, //  Created on date, etc.) to new Swift files or any other code files. Start files directly with the actual code content.

## Git Repos
When creating a git repo name the default branch 'main' unless instructed otherwise

## Showing iOS / Xcode results:
If requested to, use the script in ~/.config/nvim/scripts/xcodeRun.scpt to run the app so your human operator can verify changes.

## Build Verification for iOS/Xcode:
When you need to verify build errors or compilation errors in Xcode projects, **ALWAYS** use the specialized `ios-build-verifier` agent. If the agent reports that there's no markdown file for the current project, create one but **make sure to inform the user** that you've created this file.

## Build-Test-Commit Mode for iOS/Xcode:
When the user requests "build test commit mode" or wants you to build, test, and then commit changes:
1. **Build** the project using xcodebuild
2. **Automatically run** the script at `/Users/joel/code/jd-configs/nvim/scripts/xcode_build_test_commit.sh`
3. The script will open Xcode and run the app for user verification
4. **Wait for user confirmation** - they will type "commit" if satisfied or "cancel" to abort
5. **Only commit** after receiving "commit" confirmation from the user
6. Use the git commit subagent following the commit message guidelines above

## Today's date:
- The **Current date** is: 2025-08-20


## SwiftUI Style Guide:
- Always use trailing closure Button syntax: Button { /* action */ } label: { /* view */ } instead of Button(action:label:)
- Prefer trailing closure syntax for all view modifiers when possible
- Use @StateObject for owned objects, @EnvironmentObject for shared/injected objects (avoid @ObservedObject)
- Extract complex views into separate computed properties or View structs
- Use ViewBuilder for conditional content instead of AnyView
- Use .task for async work instead of .onAppear with Task
- When unwrapping optionals use the shorthand syntax, i.e. 'if let someVar { // do something with someVar', rather than if let renamedVar = someVar
