#!/bin/bash
# Pre-commit hook: warn if pubspec.yaml version matches the latest git tag.
# This suggests the developer forgot to bump the version for the new commit.
#
# Usage: symlink or copy to .git/hooks/pre-commit

PUBSPEC_VERSION=$(grep '^version:' pubspec.yaml | sed 's/version: //' | cut -d'+' -f1)
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null | sed 's/^v//')

if [ -n "$LATEST_TAG" ] && [ "$PUBSPEC_VERSION" = "$LATEST_TAG" ]; then
  echo "Warning: pubspec version ($PUBSPEC_VERSION) matches the latest tag."
  echo "Did you forget to bump the version for this new commit?"
fi
