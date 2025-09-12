# Create PR with concise summary

I need you to prepare a pull request. Follow these steps:

1. First, check the current git status and identify which branch we're on
2. Find the base branch (usually main or master) 
3. Analyze ALL commits that will be included in the PR (from where this branch diverged from the base)
4. Look at the actual code changes to validate what the commits claim to do
5. Generate a SHORT, SUCCINCT summary with:
   - Bullet points only
   - Action-oriented language (use verbs like "Add", "Fix", "Update", "Remove")
   - NO fluff words like "comprehensive", "robust", etc.
   - NO test plans or additional sections
   - Each bullet should be one clear line explaining what changed
   - Be colloquial and direct

Example format:
- Add user authentication flow
- Fix memory leak in data processor
- Update API endpoints for v2

After generating the summary, present it to me and ask if it looks good or needs tweaking.

If I approve (say "lgtm", "looks good", "yes", "approve", etc.), then create the PR with that summary as the body.

Start by analyzing the commits now.