# Critical Instructions **DO NOT VIOLATE**
## Making commits:
When committing code, **ALWAYS** use the git commit subagent.

## Code Verification Process:
After making any code changes, **ALWAYS** verify your changes by running, in parallel, the `qa-reviewer` subagent and the `ios-build-verifier` subagent.

## Swift Code Formatting:
After editing any Swift file, **ALWAYS** run `swiftformat` on that file before considering the task complete.

## File Headers:
**NEVER** add file headers (like //  FileName.swift, //  ProjectName, //  Created on date, etc.) to new Swift files or any other code files. Start files directly with the actual code content.

## Git Repos
When creating a git repo name the default branch 'main' unless instructed otherwise

## Showing iOS / Xcode results:
If requested to, use the script in ~/.config/nvim/scripts/xcodeRun.scpt to run the app so your human operator can verify changes.

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
