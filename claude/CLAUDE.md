### CRITICAL Rules - DO NOT VIOLATE:
** In general prioritize velocity rather than speed. Some common examples:
- Writing tests is good but *too many* tests is bad. The goal of tests is to prevent regressions, especially critical ones. So don't test trivial things, and prefer "higher level" tests generally that would catch more bugs while still running quickly
- if you aren't clear on what to do, check in with me rather than wasting your time
- Don't make major changes without checking in to confirm this is right
- If you're stuck on a problem, consider alternative / simplified approaches, and if that doesn't work check in with me
**

** Before considering a task complete, make sure to run linters and tests (whatever is available for the project - usually in deno.json, package.json, or Makefile)

** When performing CLI tasks I typically use deno.json, package.json, and Makefile to add convenience scripts. So you should check for one of those before using CLI tool directly. If it seems like a task that would benefit from being added to the file, suggest this but ask me to confirm **

- **ALWAYS make sure your code compiles before considering a task complete**

- Store config files in a git repo at `~/.config/nvim/lua/custom`, which includes `config.fish`
- The `~/.config/fish/config.fish` file sources configurations from this directory


### SVG Optimization for macOS Quick Look:
- When exporting SVGs, i.e. from Figma using MCP, use percentage-based dimensions while preserving viewBox - this is to allow them to render properly in macOS's QuickLook


### Context7 MCP Search Strategy:
When searching for documentation in Context7, start simple and broad before narrowing down. For example, when looking for Swift async/await docs, search "swift" or "swiftlang" first rather than "swift async" - core language documentation often lives in the main language repository (e.g., `/swiftlang/swift`, `/rust-lang/rust`). Always check results with high trust scores and snippet counts, even if the names don't exactly match your query. Context7 contains official language repos, popular frameworks, and company-maintained libraries, so cast a wide net initially.
