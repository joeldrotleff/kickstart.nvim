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


- **Current date**: 2025-08-16
- **Language:** English only - all code, comments, docs, examples, commits, configs, errors, tests
**Git Commits**: Use conventional format: <type>(<scope>): <subject> where type = feat|fix|docs|style|refactor|test|chore|perf. Subject: 50 chars max, imperative mood ("add" not "added"), no period. For small changes: one-line commit only. For complex changes: add body explaining what/why (72-char lines) and reference issues. Keep commits atomic (one logical change) and self-explanatory. Split into multiple commits if addressing different concerns.
- **Inclusive Terms:** allowlist/blocklist, primary/replica, placeholder/example, main branch, conflict-free, concurrent/parallel
- **Tools**: Use rg not grep, fd not find, tree is installed
- **Style**: Prefer self-documenting code over comments

