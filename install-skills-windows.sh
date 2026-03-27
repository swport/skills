#!/usr/bin/env bash
set -euo pipefail

SOURCE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v cygpath >/dev/null 2>&1 && [ -n "${USERPROFILE:-}" ]; then
  HOME_DIR="$(cygpath -u "$USERPROFILE")"
else
  HOME_DIR="${HOME}"
fi

DEST_DIR="${HOME_DIR}/.agents/skills"
mkdir -p "$DEST_DIR"

TMP_LIST="$(mktemp)"
find "$SOURCE_ROOT" -type f -name "SKILL.md" > "$TMP_LIST"

MOVED=0
while IFS= read -r skill_file; do
  skill_dir="$(dirname "$skill_file")"
  skill_name="$(basename "$skill_dir")"
  target_dir="$DEST_DIR/$skill_name"

  if [ "$skill_dir" = "$target_dir" ]; then
    continue
  fi

  rm -rf "$target_dir"
  mv "$skill_dir" "$target_dir"
  MOVED=$((MOVED + 1))
done < "$TMP_LIST"

rm -f "$TMP_LIST"
echo "Moved $MOVED skill(s) to $DEST_DIR"
