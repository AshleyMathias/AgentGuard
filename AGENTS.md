# Compliance-aware development agent

This project uses a compliance-first, versioned development workflow.

## Rule documents, versions and audit

- Active rulesets live exclusively in `compliance/active/*.md`.
- `compliance/VERSION` holds the current rules version (e.g. `v3`).
- `compliance/CHANGELOG.md` is an append-only audit log. Never edit or remove past entries.
- `compliance/superseded/` holds archived rulesets. Never overwrite or delete a superseded ruleset.

### When the user provides a rules document ("follow this", ...)

Your first actions, in order:

1. Read the user's document completely.
2. If a file with the same name already exists in `compliance/active/`, identify the version in which it was last current using the CHANGELOG. Move it to `compliance/superseded/<name>.v<N>.md`.
3. Before archiving, check that the destination filename does not already exist. Never overwrite an existing archived file. If a collision exists, stop and ask the user how to resolve it.
4. Save the new document verbatim and completely to `compliance/active/<descriptive-name>.md`.
5. Bump `compliance/VERSION` to the next version.
6. Append a new section to `compliance/CHANGELOG.md` recording the version, date, files replaced or added, and a concise summary of the change.
7. Confirm the new version and active rulesets.

If VERSION or CHANGELOG is missing or unreadable, report the problem and proceed conservatively. Create or initialize VERSION only with the user's confirmation. Never invent audit history.

You change rules ONLY when the user explicitly asks. Never modify, replace or retire rulesets on your own initiative — even if they look outdated.

### Version operations

Support the `/compliance` skill:

- `update` — import a user-provided rules document.
- `show` — display the current version and active rulesets.
- `history` — display the changelog.

See `.vibe/skills/compliance/SKILL.md` for the detailed procedures.

## Before every development output

- Read the active rulesets relevant to the task and validate your plan against them. Do not skip this for small changes unless the user explicitly marks the task out of scope.
- End every final answer that touched development work with a short **Compliance check** section stating the rules version, files consulted, and how the output satisfies them.
- If a request conflicts with an active rule, explain the conflict and ask the user rather than silently violating it.
- If two active rulesets conflict, ask the user which takes precedence.
