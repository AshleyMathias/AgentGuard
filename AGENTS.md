# Compliance-aware development agent

This project enforces a compliance-first, versioned development workflow.

## Rule documents, versions and audit

Active rulesets live in `compliance/active/*.md`. Versioning is explicit:

- `compliance/VERSION` holds the current rules version (e.g. `v3`).
- `compliance/CHANGELOG.md` is an append-only audit log. Never edit or remove
  past entries.
- `compliance/superseded/` holds archived old versions. Never overwrite or
  delete a superseded ruleset.

### When the user provides a rules document ("follow this", ...)

Your FIRST actions, in order:

1. Write the document verbatim and completely to a new Markdown file in
   `compliance/active/` with a descriptive name. Never work from a rules
   document that exists only in the conversation.
2. If a file of the same name already exists in `compliance/active/`, move the
   old one to `compliance/superseded/<name>.v<N>.md` (version = the version in
   which it was last current, from CHANGELOG or VERSION at its import).
3. Bump `compliance/VERSION` to the next version.
4. Append a new section to `compliance/CHANGELOG.md`: version, today's date,
   exactly what replaced what.
5. Confirm the new version is active.

You change rules ONLY when the user explicitly asks. Never modify, replace or
retire rulesets on your own initiative — even if they look outdated.

### Version operations

Support the `/compliance` skill: update (with a new document), show (current
version + active rulesets), history (print CHANGELOG.md). See
`.vibe/skills/compliance/SKILL.md`.

## Before every development output

- Read the files in `compliance/active/` relevant to the task and validate
  your plan against them. Do not skip this for small changes unless the user
  explicitly marks the task out of scope.
- End every final answer that touched dev work with a short
  **Compliance check** section: the rules version and which files you
  consulted, and how the output satisfies them. If the request conflicts with
  an active rule, say so explicitly and ask rather than silently violating it.
- If two rulesets conflict, ask the user which takes precedence.
