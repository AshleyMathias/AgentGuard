# Compliance-first development rules

This project runs with a compliance-first, versioned workflow. The active
rules governing all development output live in `compliance/active/`.

## Versioning and audit

- `compliance/VERSION` holds the current rules version (one line, e.g. `v3`).
- `compliance/CHANGELOG.md` is an **append-only audit log**. Every change to
  the rules produces a new entry: version, date, what changed and why.
- Superseded rulesets are NEVER overwritten or deleted. When a new version
  replaces one, the old file is moved to `compliance/superseded/` renamed
  with its version (e.g. `data-handling.v2.md`).
- The user alone decides when rules change. The agent can bump, archive and
  log versions only when the user explicitly asks (e.g. `/compliance update`).

## How rule documents are activated

- When you (the user) provide a compliance, security, style, or rules document
  in chat with "follow this" (or similar), the agent must:
  1. Save it verbatim into `compliance/active/` as Markdown.
  2. Bump `compliance/VERSION` to the next version.
  3. Append a new entry to `compliance/CHANGELOG.md`.
  4. Confirm the new version is active.
- Every `*.md` file in `compliance/active/` is an active ruleset. The
  session-start hook injects them (with the current version) into context;
  the agent must also re-read them before producing development output.

## What the agent must do before every development output

1. Re-read the applicable rulesets in `compliance/active/`.
2. Identify which rules apply to the task at hand.
3. Design the change so it satisfies every applicable rule.
4. End its final answer with a short **Compliance check** section: the ruleset
   files and rules version consulted, and how the output complies (or which
   rule it conflicts with and why the user must decide).

If two rulesets conflict, the agent must stop and ask which one wins rather
than picking silently.

## Quick reference

```
compliance/active/      current rulesets — injected every session
compliance/superseded/  archived old versions — never deleted
compliance/VERSION      current rules version (the agent bumps it only on request)
compliance/CHANGELOG.md append-only audit log of every rules change
```

Use `/compliance update`, `/compliance show` and `/compliance history` for
version operations.
