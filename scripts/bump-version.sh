#!/usr/bin/env bash
set -euo pipefail

NEW_VERSION="${1:-}"

# Validate argument
if [[ -z "$NEW_VERSION" ]]; then
  echo "Usage: $0 <new-version>  (e.g. 1.2.0)" >&2
  exit 1
fi
if ! [[ "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: version must be X.Y.Z (got: $NEW_VERSION)" >&2
  exit 1
fi

# Require clean working tree
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: working tree is dirty — commit or stash changes first." >&2
  exit 1
fi

REPO_ROOT="$(git rev-parse --show-toplevel)"
TODAY="$(date +%Y-%m-%d)"

# 1. VERSION
echo "$NEW_VERSION" > "$REPO_ROOT/skills/prompt-architect/VERSION"

# 2. marketplace.json
sed -i '' "s/\"version\": \"[^\"]*\"/\"version\": \"$NEW_VERSION\"/" \
  "$REPO_ROOT/.claude-plugin/marketplace.json"

# 3. CHANGELOG.md — prepend new stub after the header line
CHANGELOG="$REPO_ROOT/CHANGELOG.md"
STUB="## [$NEW_VERSION] - $TODAY

### Added

-

### Changed

-

"
# Insert stub after line 4 (the header block ends at line 4)
HEADER="$(head -4 "$CHANGELOG")"
BODY="$(tail -n +5 "$CHANGELOG")"
printf '%s\n\n%s\n%s' "$HEADER" "$STUB" "$BODY" > "$CHANGELOG"

# 4. README.md — update "What's new in vX.Y.Z" heading (replaces any prior version)
sed -i '' "s/### What's new in v[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*/### What's new in v$NEW_VERSION/" \
  "$REPO_ROOT/README.md"

echo "Bumped to v$NEW_VERSION. Now edit CHANGELOG.md and README.md prose, then commit."
