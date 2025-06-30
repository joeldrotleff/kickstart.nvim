### Critical Rules - DO NOT VIOLATE

- **ALWAYS make sure your code compiles before considering a task complete**
- **NEVER create mock data or simplified components** unless explicitly told to do so
- **NEVER replace existing complex components with simplified versions** - always fix the actual problem
- **ALWAYS work with the existing codebase** - do not create new simplified alternatives
- **ALWAYS find and fix the root cause** of issues instead of creating workarounds
- **ALWAYS make sure your code compiles before considering a task complete** ⚠️ CRITICAL
- When debugging issues, focus on fixing the existing implementation, not replacing it
- When something doesn't work, debug and fix it - don't start over with a simple version

### Compilation Verification Commands
  **ALWAYS run before considering task complete:**
  - TypeScript/JavaScript: `npm run build` or `tsc` or `deno task check`
  - Rust: `cargo check` or `cargo build`
  - Go: `go build`
  - Swift: `swift build` or `xcodebuild`
  - Python: Run the main file or `python -m py_compile *.py`

  If you don't know the build command, ASK THE USER before marking complete.


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

#### Xcode Test Console Logs
- **IMPORTANT**: When running tests in Xcode, console logs from the test target will NOT appear in the output unless you set a breakpoint in the test
- To see `print()` statements and logs from XCTest:
  1. Set a breakpoint anywhere in the test method
  2. Run the test
  3. When the breakpoint hits, the console will show all previous print statements
  4. You can then continue execution or step through
- This is a known Xcode limitation that affects test debugging

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

### Deployment Best Practices
- **ALWAYS use `make deploy-prod` for Deno Deploy deployments** - never use raw `deployctl` commands
- This ensures production deployment with the `--prod` flag
- Use `make deploy-preview` for preview deployments
- Check if a Makefile exists before running deployment commands
- If deploying a project without a Makefile, create one first with proper `deploy-prod` and `deploy-preview` targets

### Configuration Management
- Store config files in a git repo at `~/.config/nvim/lua/custom`, which includes `config.fish`
- The `~/.config/fish/config.fish` file sources configurations from this directory

### SVG Optimization for macOS Quick Look
- **Problem**: SVGs with fixed pixel dimensions (e.g., `width="24" height="20"`) appear tiny in macOS Quick Look preview
- **Solution**: Use percentage-based dimensions while preserving viewBox:
  ```svg
  <!-- Instead of: -->
  <svg width="24" height="20" viewBox="0 0 24 20">
  
  <!-- Use: -->
  <svg width="100%" height="100%" viewBox="0 0 24 20">
  ```
- **Benefits**: 
  - SVGs scale properly in Quick Look preview
  - Web rendering remains unchanged (viewBox maintains aspect ratio)
  - No visual changes to the graphics themselves
- When exporting SVGs from Figma, make sure to use this technique

### Context7 MCP Search Strategy
When searching for documentation in Context7, start simple and broad before narrowing down. For example, when looking for Swift async/await docs, search "swift" or "swiftlang" first rather than "swift async" - core language documentation often lives in the main language repository (e.g., `/swiftlang/swift`, `/rust-lang/rust`). Always check results with high trust scores and snippet counts, even if the names don't exactly match your query. Context7 contains official language repos, popular frameworks, and company-maintained libraries, so cast a wide net initially.
