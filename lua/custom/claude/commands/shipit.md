Goal: Push new local changes to remote github repo's main branch, by creating or updating a PR (since the repo requires PRs to merge.

- Branches should be named like: <username>/<descriptive-name> (where username is your system username from whoami)
- If there are new changes, and the current branch is a properly-named branch, then just commit them to that branch.
- If there are new changes, and current branch is main, then switch to a new branch following the convention and commit the changes
- If the branch has changes with a commit message like 'wip' or 'work in progress' then check in with the user to ask what to do
- Before pushing changes, make sure to search diffs for any 'DO NOT PUSH' comments or code that looks like dev-only (i.e. hardcoding done for development that shouldn't be pushed)
- Once changes are commited, run the `npm run precommit` script and fix any errors, then run the script again. Repeat until all the tests pass. (Some projects may not have this script or it may be a deno script instead of npm)
- Now check if there is an existing PR, and if not create a new one for the branch via gh cli tool
- Now provide a concise summary to the user of all changes that were pushed
- Finally show a link to the PR so user can click it to view

