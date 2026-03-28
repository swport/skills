---
name: git-guardrails-claude-code
description: Set up git guardrails for any agentic tool by blocking dangerous git commands (push, reset --hard, clean, branch -D, etc.) before they execute. Use when user wants to prevent destructive git operations with pre-command hooks, wrappers, or command interceptors.
---

# Setup Git Guardrails

Sets up a command guardrail script that can be used with any agentic tool that supports one of these inputs:

- command arguments: `./block-dangerous-git.sh git push origin main`
- environment variable: `AGENT_COMMAND="git push origin main" ./block-dangerous-git.sh`
- JSON on stdin with a command field (supports `.tool_input.command`, `.toolInput.command`, `.command`, `.input.command`, `.params.command`, `.arguments.command`)
- plain command text on stdin

## What Gets Blocked

- `git push` (all variants including `--force`)
- `git reset --hard`
- `git clean -f` / `git clean -fd`
- `git branch -D`
- `git checkout .` / `git restore .`

When blocked, the script exits with code `2` and prints a BLOCKED policy message on stderr.

## Steps

### 1. Ask integration model

Ask the user how they want to integrate guardrails:

- **Hook mode (preferred)**: connect script to a pre-command/pre-tool hook
- **Wrapper mode**: route command execution through a wrapper that calls the script first

Then ask scope:

- **Project scope**: only this repository/workspace
- **Global scope**: all repositories on this machine

### 2. Copy the hook script

The bundled script is at: [scripts/block-dangerous-git.sh](scripts/block-dangerous-git.sh)

Copy it to the target location based on scope:

- **Project**: `.agent-guardrails/block-dangerous-git.sh`
- **Global**: `~/.agent-guardrails/block-dangerous-git.sh`

Make it executable with `chmod +x`.

### 3. Wire it into your tool

Use your tool's pre-command hook/interceptor and pass the attempted command to this script.

Any of these invocation styles are valid:

```bash
# Args mode
/path/to/block-dangerous-git.sh git push origin main

# Env var mode
AGENT_COMMAND="git reset --hard" /path/to/block-dangerous-git.sh

# JSON mode
echo '{"command":"git clean -fd"}' | /path/to/block-dangerous-git.sh
```

If your tool can only call a shell command, create a tiny adapter that forwards the command as args or `AGENT_COMMAND`.

### 4. Optional: Claude Code compatibility example

If the user is on Claude Code, this still works with `.claude/settings.json` and `PreToolUse`.

**Project** (`.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

**Global** (`~/.claude/settings.json`):

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/hooks/block-dangerous-git.sh"
          }
        ]
      }
    ]
  }
}
```

If the settings file already exists, merge the hook into existing `hooks.PreToolUse` array — don't overwrite other settings.

### 5. Ask about customization

Ask if user wants to add or remove any patterns from the blocked list. Edit the copied script accordingly.

### 6. Verify

Run quick tests for both JSON and arg input styles:

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | <path-to-script>
<path-to-script> git reset --hard
```

Should exit with code 2 and print a BLOCKED message to stderr.
