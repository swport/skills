---
name: create-agents-md
description: "Analyze the codebase and create an AGENTS.md file with rules for AI coding agents (Claude Code, Copilot, Cursor, Gemini) to operate productively in this project."
---

Please analyze this codebase and create an `AGENTS.md` file, which will be given to future instances of this AI coding agent (like Claude Code, Codex or Gemini Cli) a simple set of rules to operate in this project.

What to add:

1. Commands that will be commonly used, such as how to build, lint, and run tests. Include the necessary commands to develop in this codebase, such as how to run a single test.
2. High-level code architecture and structure so that future instances can be productive more quickly. Focus on the "big picture" architecture that requires reading multiple files to understand
3. Include this section exactly as written:
```
## Update AGENTS.md Files

Before committing, check if any edited files have learnings worth preserving in nearby AGENTS.md files:

1. **Identify directories with edited files** - Look at which directories you modified
2. **Check for existing AGENTS.md** - Look for AGENTS.md in those directories or parent directories
3. **Add valuable learnings** - If you discovered something future developers/agents should know:
	- API patterns or conventions specific to that module
	- Gotchas or non-obvious requirements
	- Dependencies between files
	- Testing approaches for that area
	- Configuration or environment requirements

**Examples of good AGENTS.md additions:**
- "When modifying X, also update Y to keep them in sync"
- "This module uses pattern Z for all API calls"
- "Tests require the dev server running on PORT 3000"
- "Field names must match the template exactly"
```

Usage notes:

- If there's already an `AGENTS.md`, suggest improvements to it vs creating a new file.
- When you make the initial `AGENTS.md` do not repeat yourself and do not include obvious instructions like "Provide helpful error messages to users", "Write unit tests for all new utilities", "Never include sensitive information (API keys, tokens) in code or commits"
- Avoid listing every component or file structure that can be easily discovered
- Don't include generic development practices
- If there are Cursor rules (in .cursor/rules/ or .cursorrules), AGENTS.md, GEMINI.md or Copilot rules (in .github/copilot-instructions.md), make sure to include the important parts.
- If there is a README.md, PROJECT.md, make sure to include the important parts.
- Do not make up information such as "Common Development Tasks", "Tips for Development", "Support and Documentation" unless this is expressly included in other files that you read.
- Be sure to prefix the file with the following text:

```
This file provides guidance to AI coding agents like Claude Code (claude.ai/code), Cursor AI, Codex, Gemini CLI, GitHub Copilot, and other AI coding assistants when working with code in this repository.
```

Best practices:

* Good rules are focused, actionable, and scoped.
* Keep rules under 500 lines
* Avoid vague guidance. Write rules like clear internal docs
* Reuse rules when repeating prompts in chat