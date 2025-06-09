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
- **Format before committing**: Always run the project's format command (e.g., `deno fmt`, `npm run format`) before committing to ensure consistent code style and prevent CI failures

### Running scripts
- It's important to distinguish between automatic changes run by a script and those made by us. So if you run a script like `precommit` or `format` and it makes changes, commit those as a commit with a message like "Ran autoformat script". This is important because when reviewing, automatic changes deserve less scrutiny than those made by AI/humans.
- **ALWAYS check exit codes**: When running any task or script, verify it completed successfully by checking the exit code. Don't just look at the output - use `&& echo "SUCCESS" || echo "FAILED"` or check `$?` to ensure the command didn't fail
- **Investigate failures immediately**: If a command exits with an error code, investigate what went wrong before proceeding. Long output might truncate important error messages at the end

### Research / Planning
- When asked to do research or make a plan, check in with the user to verify the plan looks good before implementing any changes

### CI/CD Best Practices
- **ALWAYS use the same commands in CI that are used locally** - prefer `npm run test`, `deno task test`, `make test` etc. over duplicating logic in CI
- **NEVER duplicate build/test logic** between CI workflows and local scripts - this prevents CI-only failures
- When setting up CI, call the project's existing scripts/makefiles rather than reimplementing commands
- This ensures CI and local development stay in sync and reduces "works on my machine" issues

### iOS/macOS App Development

#### XcodeGen Setup
- **Prefer XcodeGen over manual Xcode project management** - use a declarative `project.yml` file instead of editing .xcodeproj files
- Install with: `brew install xcodegen`
- Generate project with: `xcodegen generate`
- **NEVER manually edit .xcodeproj files** - always modify `project.yml` and regenerate
- Benefits: Clean diffs, easier merging, reproducible builds, no more .pbxproj conflicts

Example project.yml structure:
```yaml
name: MyApp
options:
  bundleIdPrefix: com.example
  deploymentTarget:
    iOS: 15.0
targets:
  MyApp:
    type: application
    platform: iOS
    sources: [MyApp]
    settings:
      GENERATE_INFOPLIST_FILE: YES  # Auto-generates Info.plist
```

#### xcpretty for Clean Build Output
- **ALWAYS use xcpretty when running xcodebuild** - it makes output readable and highlights errors clearly
- Install with: `gem install xcpretty` 
- Usage: `xcodebuild [options] | xcpretty`
- For CI/scripts, check if xcpretty exists first:
```bash
if command -v xcpretty &> /dev/null; then
    xcodebuild build | xcpretty
else
    xcodebuild build
fi
```

#### SwiftFormat for Code Consistency
- **ALWAYS use SwiftFormat for Swift projects** - ensures consistent code style across the codebase
- Install with: `brew install swiftformat`
- Format all files: `swiftformat .`
- Check without modifying: `swiftformat . --dryrun`
- Create `.swiftformat` config file for project-specific rules:
```
--swiftversion 5.0
--indent 4
--exclude .build,Pods,Carthage
```
- Run before committing code to maintain consistency
- Can integrate with Xcode as a build phase or Git pre-commit hook

#### Common iOS Development Patterns
- When CMAcceleration or similar types don't conform to Equatable, use `.onReceive` with Combine instead of `.onChange`
- For watchOS apps, remember the container iOS app is required even if minimal
- Use `GENERATE_INFOPLIST_FILE: YES` in project.yml to avoid Info.plist management issues

### Configuration Management
- Store config files in a git repo at `~/.config/nvim/lua/custom`, which includes `config.fish`
- The `~/.config/fish/config.fish` file sources configurations from this directory