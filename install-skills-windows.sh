#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v cygpath >/dev/null 2>&1 && [ -n "${USERPROFILE:-}" ]; then
  HOME_DIR="$(cygpath -u "$USERPROFILE")"
else
  HOME_DIR="${HOME}"
fi

declare -a DEST_BASES=("${HOME_DIR}/.agents")

for DEST_BASE in "${DEST_BASES[@]}"; do
  SKILLS_DEST="$DEST_BASE/skills"
  PROMPTS_DEST="$DEST_BASE/prompts"
  mkdir -p "$SKILLS_DEST" "$PROMPTS_DEST"
  
  # Copy skills
  TMP_SKILLS="$(mktemp)"
  find "$SOURCE_ROOT" -type d -name ".*" -prune -o -type f -name "SKILL.md" -print > "$TMP_SKILLS"
  
  SKILLS_COPIED=0
  while IFS= read -r skill_file; do
    skill_dir="$(dirname "$skill_file")"
    skill_name="$(basename "$skill_dir")"
    target_dir="$SKILLS_DEST/$skill_name"
  
    if [ "$skill_dir" = "$target_dir" ]; then
      continue
    fi
  
    rm -rf "$target_dir"
    cp -R "$skill_dir" "$target_dir"
    SKILLS_COPIED=$((SKILLS_COPIED + 1))
  done < "$TMP_SKILLS"
  
  rm -f "$TMP_SKILLS"
  
  # Copy prompts
  TMP_PROMPTS="$(mktemp)"
  find "$SOURCE_ROOT" -type d -name ".*" -prune -o -type f -name "*.prompt.md" -print > "$TMP_PROMPTS"
  
  PROMPTS_COPIED=0
  while IFS= read -r prompt_file; do
    prompt_name="$(basename "$prompt_file")"
    target_file="$PROMPTS_DEST/$prompt_name"
  
    if [ "$(dirname "$prompt_file")" = "$PROMPTS_DEST" ]; then
      continue
    fi
  
    cp "$prompt_file" "$target_file"
    PROMPTS_COPIED=$((PROMPTS_COPIED + 1))
  done < "$TMP_PROMPTS"
  
  rm -f "$TMP_PROMPTS"
  echo "Copied $SKILLS_COPIED skill(s) to $SKILLS_DEST"
  echo "Copied $PROMPTS_COPIED prompt(s) to $PROMPTS_DEST"
done
