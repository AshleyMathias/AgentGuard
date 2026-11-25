#!/usr/bin/env bash
# session_start hook: inject active compliance rules + rules version into the
# agent's context. Layout: compliance/active/*.md is the versioned home;
# compliance/*.md (flat, older template copies) is still honored. README.md,
# superseded/ and the *.md metadata files are never injected.
# Defensive behavior as before: no folder -> silent; nothing readable ->
# warning into context; some files unreadable -> named in the context; control
# bytes stripped before JSON encoding; always exit 0 (fail open).

set -u
cat >/dev/null

rules_dir="compliance"
active_dir="compliance/active"
max_bytes=49152
files=()
skipped=()
body=""

if [ ! -d "$rules_dir" ]; then
  exit 0
fi

# A file is an injectable ruleset only if it is a readable regular *.md,
# not README, not under superseded/. Searches the versioned active/ dir and
# the legacy flat layout.
collect_from() {
  local dir="$1"
  [ -d "$dir" ] || return 0
  local f base
  for f in "$dir"/*.md; do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    [ "$base" = "README.md" ] && continue
    if [ -f "$f" ] && [ -r "$f" ]; then
      files+=("$f")
      body+="=== RULESET FILE: $f ==="
      body+="$(tr -d '\r' < "$f" 2>/dev/null || printf '%s' "[unrecoverable read error]")"
      body+=$'\n'
    else
      skipped+=("$f")
    fi
  done
}

collect_from "$active_dir"
collect_from "$rules_dir"

if [ "${#files[@]}" -eq 0 ] && [ "${#skipped[@]}" -eq 0 ]; then
  exit 0
fi

skip_note=""
if [ "${#skipped[@]}" -gt 0 ]; then
  skip_note="WARNING: the following compliance files could NOT be read and were omitted:${skipped[*]}
"
fi

version_line=""
if [ -f "compliance/VERSION" ] && [ -r "compliance/VERSION" ]; then
  version_line="ACTIVE COMPLIANCE RULES VERSION: $(tr -d '[:space:]' < compliance/VERSION | head -c 32)
"
elif [ -e "compliance/VERSION" ]; then
  skip_note+="WARNING: compliance/VERSION exists but could not be read; version lineage unverified.
"
fi

if [ "${#files[@]}" -eq 0 ]; then
  context="${version_line}ACTIVE COMPLIANCE FOLDER FOUND BUT NO READABLE RULESETS. Per this project's instructions you must validate development output against the rulesets in compliance/active/. They could not be read automatically; read them directly, and flag the problem to the user before proceeding.

$skip_note"
elif [ "${#body}" -le "$max_bytes" ]; then
  context="${version_line}ACTIVE COMPLIANCE RULESETS (injected by the compliance hook). These rules govern this session. Re-read the files in compliance/active/ before any development output, validate your work against them, and end dev answers with a Compliance check section naming the rules version.

$skip_note
$body"
else
  list=""
  for f in "${files[@]}"; do
    list+="- $f
"
  done
  context="${version_line}ACTIVE COMPLIANCE RULESETS DETECTED. Per this project's instructions you must read and apply the rulesets in compliance/active/ before any development output. Too large to inject automatically; read these files directly now:
$list
$skip_note"
fi

# Escape for a JSON string. Three passes:
#   1. strip control characters (except newline and tab) that would make the
#      JSON payload invalid,
#   2. join all lines with literal \n (separate sed invocation: mixing the
#      slurp loop into the same call skips the s/// expressions on lines 2+),
#   3. escape backslash, quote and tab.
escaped=$(printf '%s' "$context" |
  tr -d '\000-\010\013\014\016-\037' |
  sed ':a;N;$!ba;s/\n/\\n/g' |
  sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/\t/\\t/g')

printf '{"hook_specific_output": {"additional_context": "%s"}}\n' "$escaped"
