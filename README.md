# Skills

A curated collection of reusable Copilot skills and prompts.

This repository includes:
- Skill packages under `skills/`
- Prompt templates under `prompts/`
- Helper install scripts for Unix and Windows

## Installation

Clone this repository, then run the installer for your platform from the repository root.

### macOS / Linux

```bash
bash install-skills-unix.sh
```

### Windows (Command Prompt)

```bat
install-skills-windows.cmd
```

### Windows (Git Bash / WSL Bash)

```bash
bash install-skills-windows.sh
```

## What The Installer Does

The install scripts copy:
- All `SKILL.md` skill folders to `~/.agents/skills`
- All `*.prompt.md` files to `~/.agents/prompts`
