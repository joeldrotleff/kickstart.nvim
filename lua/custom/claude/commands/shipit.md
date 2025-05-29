Goal: Push new local changes to remote github repo, creating a branch and PR as necessary (since the repo requires PRs to merge changes to main)

Prepare local branch if necessary:
- Branches should be named like: joeldrotleff/<descriptive-name> 
- If there are new changes, and the current branch is a properly-named branch, then just commit them to that branch.
- If there are new changes, and current branch is main or has a name starting with 'wt-', then switch to a new branch following the convention and commit the changes (wt means working tree, which means the user switched to a work tree branch which isn't a good descriptive name for changes)

Check for issues:
- If the branch has changes with a commit message like 'wip' or 'work in progress' then check in with the user to ask what to do
- Before pushing changes, make sure to search diffs for any 'DO NOT PUSH' comments or code that looks like dev-only (i.e. hardcoding done for development that shouldn't be pushed)
- Once changes are commited, run the `npm run precommit` script and fix any errors, then run the script again. Repeat until all the tests pass. (Some projects may not have this script or it may be a deno script instead of npm)

Create & Push PR:
- Now check if there is an existing PR, and if not create a new one for the branch via gh cli tool
- Now provide a concise summary to the user of all changes that were pushed
- Finally show a link to the PR so user can click it to view

