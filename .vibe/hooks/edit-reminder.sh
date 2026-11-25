#!/usr/bin/env bash
# post_tool hook (write_file / edit): one-line nudge to verify the change
# against the active compliance rulesets. Silent when no rules are active or
# only superseded/archived files exist.

set -u
cat >/dev/null

count=$(find compliance -type f -name '*.md' \
          ! -name 'README.md' ! -name 'CHANGELOG.md' \
          ! -path '*/superseded/*' \
          ! -name '.*' 2>/dev/null | wc -l)

# Exit silently without an ACTIVE ruleset, or before versioning exists at all.
if [ "$count" -eq 0 ]; then
  exit 0
fi
if [ ! -f compliance/VERSION ]; then
  exit 0
fi

printf '%s\n' '{"hook_specific_output": {"additional_context": "Compliance reminder: this project has active rulesets in compliance/. Verify the change you just made against them and the rules version before your final answer, and include a Compliance check section."}}'
