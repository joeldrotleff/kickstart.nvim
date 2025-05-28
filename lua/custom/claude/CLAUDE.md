### Critical Rules - DO NOT VIOLATE

- **NEVER create mock data or simplified components** unless explicitly told to do so
- **NEVER replace existing complex components with simplified versions** - always fix the actual problem
- **ALWAYS work with the existing codebase** - do not create new simplified alternatives
- **ALWAYS find and fix the root cause** of issues instead of creating workarounds
- When debugging issues, focus on fixing the existing implementation, not replacing it
- When something doesn't work, debug and fix it - don't start over with a simple version

### TypeScript and Linting
- ALWAYS add explicit types to all function parameters, variables, and return types
- ALWAYS run `deno task precommit` or `npm run precommit` or appropriate linter command before considering any code changes complete
- Fix all linter and TypeScript errors immediately - don't leave them for the user to fix
- When making changes to multiple files, check each one for type errors

### Running scripts
- It's important to distinguish between automatic changes run by a script and those made by us. So if you run a script like `precommit` or `format` and it makes changes, commit those as a commit with a message like "Ran autoformat script". This is important because when reviewing, automatic changes deserve less scrutiny than those made by AI/humans.

### Research / Planning
- When asked to do research or make a plan, check in with the user to verify the plan looks good before implementing any changes
