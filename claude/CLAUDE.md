# Claude Agent Guidelines

## Code Verification Process

After making any code changes, ALWAYS run the following three verification agents in parallel to ensure quality:

### Required Verification Agents

1. **qa-reviewer** - Reviews implementation correctness
   - Verifies the implementation matches user requirements
   - Checks for idiomatic patterns and major bugs
   - Focuses on velocity - only flags significant blockers

2. **tester** - Runs tests and checks coverage
   - Identifies and runs the project's test suite
   - Reports passing/failing tests with details
   - Checks if new code has adequate test coverage

3. **security-checker** - Scans for vulnerabilities
   - Analyzes git diff for security issues
   - Performs proactive security scanning
   - Independently verifies all changes (doesn't rely solely on reported changes)

### How to Run Verification

After completing any implementation or code changes, use the Task tool to launch all three agents simultaneously:

```
Task 1: qa-reviewer - Review the implementation for correctness and quality
Task 2: tester - Run all tests and check coverage
Task 3: security-checker - Scan for security vulnerabilities
```

Run these in parallel (single message with multiple tool calls) for maximum efficiency.

### When to Run Verification

- After implementing new features
- After fixing bugs
- After refactoring code
- Before marking any coding task as complete
- When requested by the user

### Acting on Results

- **If qa-reviewer finds issues**: Address critical problems before proceeding
- **If tests fail**: Fix failing tests immediately
- **If security issues found**: Address CRITICAL and HIGH severity issues before continuing
- **If coverage is missing**: Consider adding tests for uncovered code

## Additional Guidelines

- Always run lint and typecheck commands if available (npm run lint, npm run typecheck, ruff, etc.)
- If unsure about test/lint commands, ask the user and suggest documenting them here
- Prioritize fixing issues that block deployment or create security risks
- Remember: The goal is velocity with quality - fix blockers, not nitpicks