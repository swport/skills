#!/usr/bin/env bash

INPUT=""
if [ ! -t 0 ]; then
  INPUT=$(cat)
fi

COMMAND=""

# 1) Explicit command arguments: script.sh git push origin main
if [ "$#" -gt 0 ]; then
  COMMAND="$*"
fi

# 2) Environment variable adapters used by some tool runners
if [ -z "$COMMAND" ] && [ -n "${AGENT_COMMAND:-}" ]; then
  COMMAND="$AGENT_COMMAND"
fi

if [ -z "$COMMAND" ] && [ -n "${TOOL_COMMAND:-}" ]; then
  COMMAND="$TOOL_COMMAND"
fi

# 3) JSON stdin payloads from hook systems (Claude, generic, custom)
if [ -z "$COMMAND" ] && [ -n "$INPUT" ] && command -v jq >/dev/null 2>&1; then
  COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // .toolInput.command // .command // .input.command // .params.command // .arguments.command // empty' 2>/dev/null)
fi

# 4) Plain-text stdin fallback
if [ -z "$COMMAND" ] && [ -n "$INPUT" ]; then
  COMMAND="$INPUT"
fi

DANGEROUS_PATTERNS=(
  "git push"
  "git reset --hard"
  "git clean -fd"
  "git clean -f"
  "git branch -D"
  "git checkout \."
  "git restore \."
  "push --force"
  "reset --hard"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "BLOCKED: '$COMMAND' matches dangerous pattern '$pattern'. This action is disallowed by git guardrails policy." >&2
    exit 2
  fi
done

exit 0
