command: shipit

Generate a pull request for the current branch. If on main/master, create a new branch first with any unpushed commits.

A: I'll create a pull request for you. Let me first check the current git status and branch.

First, I need to check for any uncommitted changes:

```bash
git status --porcelain
```

If there are uncommitted changes, I'll stop and let you know rather than proceeding.

Next, I'll check what branch we're on:

```bash
git branch --show-current
```

And identify the base branch:

```bash
git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo "main"
```

If we're on main/master:
1. Check if there are any unpushed commits using:
   ```bash
   git log origin/$(git branch --show-current)..HEAD --oneline
   ```
2. If no unpushed commits, I'll let you know there's nothing to create a PR for
3. If there are unpushed commits, I'll create a new branch named `joeldrotleff/<description>` based on the commit messages
4. Push the new branch

If we're already on a feature branch:
1. Make sure the branch is pushed to origin
2. Get all commits between the base branch and current branch

Then I'll create the PR using gh:
- Extract any issue references (like HNOM-123 or similar patterns) from commit messages
- Generate a succinct, colloquial title
- If multiple commits, list them briefly in the body
- Include any found issue references with "fixes" prefix
- No emojis, no fluff

I'll use:
```bash
gh pr create --title "<title>" --body "<body>"
```

If anything goes wrong at any step (no commits, unstaged changes, gh errors), I'll stop and let you know what happened.