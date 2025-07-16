### CRITICAL Rules - DO NOT VIOLATE:
** In general prioritize velocity rather than speed. Some common examples:
- if you aren't clear on what to do, check in with me rather than wasting your time
** Make sure to let me know if something goes wrong (for example if you are unable to access a web page that I told you to summarize). If you think you can work around the issue then you may continue working (but still let me know), but if this isn't possible then stop and ask for guidance**
- If you're stuck on a problem, consider alternative / simplified approaches, and if that doesn't work check in with me
- Don't make major changes without checking in to confirm this is right

** Before considering a task complete, make sure to run linters and tests (whatever is available for the project - usually in deno.json, package.json, or Makefile)

** When performing CLI tasks I typically use deno.json, package.json, and Makefile to add convenience scripts. So you should check for one of those before using CLI tool directly. If it seems like a task that would benefit from being added to the file, suggest this but ask me to confirm **

- **ALWAYS make sure your code compiles before considering a task complete**

- Store config files in a git repo at `~/.config/nvim/lua/custom`, which includes `config.fish`
- The `~/.config/fish/config.fish` file sources configurations from this directory


### SVG Optimization for macOS Quick Look:
- When exporting SVGs, i.e. from Figma using MCP, use percentage-based dimensions while preserving viewBox - this is to allow them to render properly in macOS's QuickLook


### Context7 MCP Search Strategy:
When searching for documentation in Context7, start simple and broad before narrowing down. For example, when looking for Swift async/await docs, search "swift" or "swiftlang" first rather than "swift async" - core language documentation often lives in the main language repository (e.g., `/swiftlang/swift`, `/rust-lang/rust`). Always check results with high trust scores and snippet counts, even if the names don't exactly match your query. Context7 contains official language repos, popular frameworks, and company-maintained libraries, so cast a wide net initially.

### Klaus Integration

Klaus is a personal learning management system that captures programming insights, patterns, and preferences. You should interact with Klaus in two ways:

#### 1. Querying Klaus for Relevant Learnings

**BEFORE** suggesting a plan or implementing something, check Klaus for relevant learnings:

```bash
klaus query --task "[what you're about to do]" --language "[language if applicable]" --framework "[framework if applicable]"
```

Examples:
- About to work with async code: `klaus query --task "async" --language "typescript"`
- Setting up testing: `klaus query --task "testing" --framework "jest"`
- Database operations: `klaus query --task "database" --framework "lancedb"`

Use the learnings as helpful context, but apply your judgment:
- Learnings are suggestions, not rigid rules
- Consider if they're relevant to the current situation
- Adapt them to fit the specific use case
- They represent what worked before, but may not always apply

#### 2. Capturing New Learnings

When you encounter valuable insights during our work, suggest saving them to Klaus. Look for:

1. **Non-trivial problem solutions** - bugs fixed, performance improvements, security fixes
2. **Library/framework insights** - undocumented behaviors, gotchas, best practices  
3. **User coding preferences** - style choices, architectural patterns, conventions
4. **Reusable patterns** - error handling, API integration, validation strategies

When you identify a learning opportunity:

1. Present it clearly to the user for review:
   ```
   I noticed a valuable learning from what we just worked on:
   
   **Title**: [concise summary]
   **Problem**: [what issue this solves]
   **Solution**: [the approach that worked]
   **Context**: [task, language, framework if applicable]
   **Code Example**: [if applicable]
   ```

2. Ask: "Would you like me to save this learning to Klaus? If you'd like to edit first let me know."

3. If approved, save using:
   ```bash
   klaus add --title "..." --problem "..." --solution "..." --task "..." --language "..." --framework "..."
   ```

4. Confirm: "✓ Learning saved to Klaus with ID: [id]"

**Guidelines:**
- Query Klaus early in the process, not after implementing
- Quality over quantity when adding (1-3 learnings per session)
- Focus on reusable insights, not project-specific details
- Don't interrupt flow - suggest new learnings at natural pauses
- Skip trivial fixes or well-documented practices
- Often the best learnings are when the user had to request revisions or updates to your original code (if the original code was good, we probably don't need a learning for it)

**DO NOT suggest learnings for:**
- Trivial syntax corrections
- One-off implementations  
- Well-documented standard practices
- Simple typo fixes
- Temporary workarounds
