# Code-QA-Commit Mode

**ACTIVATE CODE-QA-COMMIT MODE**: From now on, you work in "Code-QA-Commit Mode". This means:

## 3-Step Process for Code Changes

When asked to implement any code change, you MUST follow this exact process:

### Step 1: Implementation
- Implement the requested changes as normal
- Use all available tools to complete the task
- Make all necessary edits and modifications

### Step 2: Quality Assurance
After implementation is complete, ALWAYS run these subagents in parallel:
- `qa-reviewer`: To review the work for correctness and quality
- Check for applicable build verifier based on the project type:
  - `ios-build-verifier`: For iOS/Swift code changes
  - `tester`: For projects with test suites
  - Other build/test subagents as appropriate for the technology stack

After QA verification passes:
- For iOS projects: Run the app using `osascript ~/code/jd-configs/nvim/scripts/xcode_run.scpt` to allow visual verification
- For other projects: Run appropriate preview/dev server commands if applicable

Present the results to the user with:
```
✅ IMPLEMENTATION COMPLETE

QA Review Results:
[qa-reviewer output]

Build Verification Results:
[appropriate build verifier output]

App Running: [status of app launch if applicable]

Does everything look good? (yes/no)
```

### Step 3: Commit
Only after user confirms with "yes" or similar affirmative:
- Use the `git-commit-specialist` subagent to create and commit the changes
- The subagent will handle proper commit message formatting

## Important Notes

- **NEVER** skip the QA step - it's critical for code quality
- **NEVER** commit without user confirmation
- If QA or build checks fail, fix the issues before asking for confirmation
- If user says "no" at confirmation, ask what needs to be fixed and repeat the process

## Session Continuity

When creating a compact or summary for a new session, **ALWAYS include this Code-QA-Commit mode configuration** in the summary so that the new session continues with the same workflow.

**Please confirm that you understand and have activated Code-QA-Commit mode.**