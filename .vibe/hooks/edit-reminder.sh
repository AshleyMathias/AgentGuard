#!/usr/bin/env bash
# post_tool hook: remind the agent to verify changes against active rulesets.
# Active rulesets are stored exclusively in compliance/active/.

set -u
cat >/dev/null

active_dir="compliance/active"

count=$(find "$active_dir" -maxdepth 1 -type f -name '*.md' -readable 2>/dev/null | wc -l)

if [ "$count" -eq 0 ]; then
  exit 0
fi

if [ ! -f compliance/VERSION ] || [ ! -r compliance/VERSION ]; then
  exit 0
fi

printf '%s\n' '{"hook_specific_output": {"additional_context": "Compliance reminder: this project has active rulesets in compliance/active/. Verify the change you just made against them and the rules version before your final answer, and include a Compliance check section."}}'
