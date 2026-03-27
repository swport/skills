#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_DIR="${HOME}/.agents/skills"

mkdir -p "$DEST_DIR"

TMP_LIST="$(mktemp)"
find "$SOURCE_ROOT" -type d -name ".*" -prune -o -type f -name "SKILL.md" -print > "$TMP_LIST"

COPIED=0
while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"
  target_dir="$DEST_DIR/$skill_name"

  if [ "$skill_dir" = "$target_dir" ]; then
    continue
  fi

  rm -rf "$target_dir"
  cp -R "$skill_dir" "$target_dir"
  COPIED=$((COPIED + 1))
done < "$TMP_LIST"

rm -f "$TMP_LIST"
echo "Copied $COPIED skill(s) to $DEST_DIR"
